USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintInterimBillBal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*  PURPOSE:		To retrieve the interimbill information for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintInterimBillBal]-- 1988488
	@ContractNumber varchar(35)
AS
	/* 2/25/99 - cpy created - get interim bill data with address */

	SET Rowcount 2000
	
	 -- convert strings to datetime
	DECLARE		@GST	 decimal(7, 2)
	DECLARE		@PST	 decimal(7, 2)
	DECLARE 	@PUDate datetime 
	Declare		@ActualCheckInDate datetime
	Declare		@FinalInvNum  varchar(20)
	Declare		@FinalBillStartDate datetime
	

	select @PUDate= Pick_up_on from contract where contract_number=Convert(int,@ContractNumber)
	select @ActualCheckInDate=Actual_check_in from RP__Last_Vehicle_On_Contract where contract_number=Convert(int,@ContractNumber)
 
	SELECT 	 @GST=Tax_Rate/100
	--select *
	FROM		Tax_Rate
	WHERE	@PUDate BETWEEN Valid_From AND Valid_To and TAX_Type='GST'

	--get vehicle model PST rate
	SELECT 	 @PST=pst/100
	FROM		Contract_Vehicle_PST_Rate_vw
	WHERE	contract_number=@ContractNumber
 
	if @PST is null 
		SELECT 	 @PST=Tax_Rate/100
		FROM		Tax_Rate
		WHERE	@PUDate BETWEEN Valid_From AND Valid_To and TAX_Type='PST'


	
	CREATE TABLE #IterimBillBal(
		InvoiceOrder [int] null,
		RecordType	 [Varchar](25) NULL,	 
		InvoiceNumber  [Varchar](25) NULL,	 
		BillStartDate    [datetime] NULL,
		BillEndDate	   [datetime] NULL,
		TotalAmount		[decimal](9, 2) NULL,
		RentalCharge	[decimal](9, 2) NULL,
		LDW				[decimal](9, 2) NULL,
		OtherCoverage	[decimal](9, 2) NULL,
		FuleFPO			[decimal](9, 2) NULL,
		OptionalExtra   [decimal](9, 2) NULL,
		Other			[decimal](9, 2) NULL,
		GSTAmount	   [decimal](9, 2) NULL,
		PSTAmount	   [decimal](9, 2) NULL,
		PVRTAmount	   [decimal](9, 2) NULL 
	) ON [PRIMARY]
	Insert into #IterimBillBal
	Select * from 
	(	
		
		SELECT
			0 as InvoiceOrder,
			'Total' RecordType,      
			rtrim(convert(varchar, Contract_Number)) InvoiceNumber,
			Pick_Up_on BillStartDate,
			Drop_off_On BillEndDate,
			SUM(Amount)+SUM(GST_Amount)+SUM(PST_Amount)	+SUM(PVRT_Amount) as TotalAmount,
			SUM(CASE WHEN Charge_Type IN (10, 50, 51, 52)   THEN Amount ELSE 0 END) AS RentalCharge,
			SUM(CASE WHEN OptionalExtraType IN ('LDW') OR (Charge_Type = 61 AND Charge_Item_Type = 'a')  or Charge_Type in (91) THEN Amount ELSE 0 END) AS LDW, 
			SUM(CASE WHEN OptionalExtraType IN ('PAI','PEC','ELI', 'BUYDOWN') 
					OR (Charge_Type in (62,63,67,98) AND (Charge_Item_Type = 'a' or Charge_Item_Type = 'm' ) ) 
					OR Charge_Type in (90,92) THEN Amount ELSE 0 END
			) AS OtherCoverage, 
			SUM(CASE WHEN Charge_Type in (14,18,88) THEN Amount ELSE 0 END) AS FuleFPO,
			SUM(CASE WHEN Charge_Type=12 and OptionalExtraType not in  ('LDW','PAI','PEC','ELI', 'BUYDOWN')  THEN Amount ELSE 0 END) AS OptionalExtra, 
			SUM(CASE WHEN Charge_Type NOT IN (10,12, 14,18,88,50, 51, 52,61,62,63,67,71,72,73,90,92,98)   THEN Amount ELSE 0 END) AS Other, 
			SUM(GST_Amount )+ SUM(CASE WHEN Charge_Type IN (71)   THEN Amount ELSE 0 END) GSTAmount,
			SUM(PST_Amount )+ SUM(CASE WHEN Charge_Type IN (72)   THEN Amount ELSE 0 END) PSTAmount, 
			SUM(PVRT_Amount )+ SUM(CASE WHEN Charge_Type IN (73)   THEN Amount ELSE 0 END) PVRTAmount
			
			
--71                       	GST/HST
--72                       	PST
--73                       	PVRT


		FROM       
		(
			Select 
				c.Contract_Number,
				c.Pick_Up_on,
				voc.Actual_check_in as Drop_off_On,--c.Drop_off_On,	
				bt.RBR_Date, 	 
				dbo.Optional_Extra.Type AS OptionalExtraType,   
				cci.Charge_Type,
				cci.Charge_Description,
				cci.Charge_item_type,
				cci.Optional_Extra_ID,
				c.Reservation_Revenue,
				Amount = cci.Amount 	- cci.GST_Amount_Included
							- cci.PST_Amount_Included 
							- cci.PVRT_Amount_Included,
				 
				GST_Amount + GST_Amount_Included  GST_Amount,
				PST_Amount + PST_Amount_Included PST_Amount, 
				PVRT_Amount+PVRT_Amount_Included PVRT_Amount
					
					--select *
			FROM 	Contract c WITH(NOLOCK)
				
				INNER JOIN
    				Business_Transaction bt 
					ON bt.Contract_Number = c.Contract_Number
				inner join RP__Last_Vehicle_On_Contract VOC on VOC.Contract_Number = c.Contract_Number
				
				left JOIN
    				Contract_Charge_Item cci
					ON c.Contract_Number = cci.Contract_Number
				 LEFT OUTER JOIN
								  dbo.Optional_Extra ON cci.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID 
								  --AND 
								  --dbo.Optional_Extra.Delete_Flag = 0
			WHERE 	
			(bt.Transaction_Type = 'con') 
				AND 
    				(bt.Transaction_Description in ('check in', 'foreign check in') )
    				AND 	
				c.Status = 'CI'
			  
				
			union  all

			SELECT
				c.Contract_Number,
				c.Pick_Up_on,
				c.Drop_off_On,
				bt.RBR_Date, 
				NULL AS OptionalExtraType,
			     
				(Case When cci.Reimbursement_Reason in ('Customer Service Charge', 'Miscellaneous Charge') then '60'
					 When  cci.Reimbursement_Reason ='Repair and Maintenance' then   '27'
					 When  cci.Reimbursement_Reason ='Oil Refill Charge' then  '29'
					 When  cci.Reimbursement_Reason ='Taxi Charge' then	 '28'
					 When  cci.Reimbursement_Reason ='Tire Charge' then	 '24'
					 When  cci.Reimbursement_Reason ='Towing Charge' then  '26'
					 When  cci.Reimbursement_Reason ='Drop Charge' then	'33'
				End)  Charge_Type,
				cci.Reimbursement_Reason Charge_Description,
				'c' Charge_item_type,
				NULL Optional_Extra_ID,
				c.Reservation_Revenue,
				Amount = cci.Flat_Amount*(-1), 	 	
				0 GST_Amount,
				0 PST_Amount, 
				0 PVRT_Amount
				
			FROM  dbo.Contract AS c
			INNER JOIN dbo.Business_Transaction AS bt 
				ON c.Contract_Number = bt.Contract_Number 
			INNER JOIN dbo.Contract_Reimbur_and_Discount AS cci 
				ON c.Contract_Number = cci.Contract_Number and cci.type='Reimbursement'             
			where 
			(bt.Transaction_Type = 'con') 
				AND 
    				(bt.Transaction_Description in ('check in', 'foreign check in') )
    				AND 	
			c.Status = 'CI'											   
		) cca
		where Contract_Number = Convert(int,@ContractNumber)
		--where cca.rbr_date='2013-12-31'
		GROUP BY Contract_Number,Pick_Up_on,Drop_off_On	
	)TotalCharge

	Union	

  
	select  InvoiceOrder,
			RecordType,
			InvoiceNumber,
			BillStartDate,
			BillEndDate,
			sum(Total_Amount) as Total_Amount,
			sum(RentalCharge) as RentalCharge,
			sum(LDW) as LDW,
			sum(OtherCoverage) as OtherCoverage,
			sum(FuleFPO) as FuleFPO,
			sum(OptionalExtra) as OptionalExtra,
			sum(Other) as Other,
			sum(GSTAmount) as GSTAmount,
			sum(PSTAmount) as PSTAmount,
			sum(PVRTAmount) as PVRTAmount
	  FROM
		(SELECT	
			1 as InvoiceOrder,
			'Billed' RecordType,      
			rtrim(convert(varchar,CPI.Contract_Number)) + '-' +
					RIGHT(CONVERT(varchar, 
					ARE.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
					
			convert(varchar,(Select Max(ITBStart.StartDate) from 
			   (SELECT Contract_Number, dateadd(day,1, Interim_Bill_Date) StartDate
						FROM  dbo.Interim_Bill IB   
						Where IB.Contract_number=ar.Contract_number and IB.Interim_Bill_Date <  ITB.Interim_Bill_Date
								and isnull(IB.Void,0)<>1
						Union 
						Select Contract_Number, Pick_up_on as StartDate
						from Contract  
						where Contract_number= ITB.Contract_Number 
			   )   ITBStart
			),101) as BillStartDate , 
			convert(varchar,ITB.Interim_Bill_Date,101) BillEndDate,		 
			CPI.Amount Total_Amount,
			convert(decimal(9,2),(CPI.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST)) as RentalCharge,
			isnull(ITB.Coverage_Amount,0) LDW,	 
			--ARM.Address_Name,
			--L.Location,
			
			0 OtherCoverage, 
			0 FuleFPO,
			0 OptionalExtra, 
			0 Other, 
			convert(decimal(9,4),(((CPI.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@GST
				+ isnull(ITB.Coverage_Amount,0)*@GST)) as GSTAmount,
			convert(decimal(9,4),((CPI.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@PST) as PSTAmount,
			0 PVRTAmount
	       


		   --Tot.PSTRate,
			
			
			--,
					
					
			--ARE.doc_ctrl_num_base + ARE.doc_ctrl_num_type +
			--		RIGHT(CONVERT(varchar, 
			--		ARE.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber
		   --Tot.TotalAmount,
		FROM
			Contract_Payment_Item CPI
			INNER JOIN AR_Payment AR
			  ON CPI.Contract_Number = AR.Contract_Number
			 And CPI.Sequence = AR.Sequence
			JOIN Location L
			  ON CPI.Collected_At_Location_Id = L.Location_Id
		
			 JOIN Interim_Bill ITB
			   ON AR.Contract_Number =ITB.Contract_Number
			  And AR.Contract_Billing_Party_ID =ITB.Contract_Billing_Party_ID
			  And AR.Interim_Bill_Date =ITB.Interim_Bill_Date

			JOIN Contract_Billing_Party CBP
			  ON AR.Contract_Number = CBP.Contract_Number
			 And AR.Contract_Billing_Party_Id = CBP.Contract_Billing_Party_Id

			JOIN armaster ARM
			  ON CBP.Customer_Code = ARM.Customer_Code
			 AND ARM.Address_Type = 0	
		 	  
		Left JOIN dbo.AR_Export ARE 
			ON CPI.Contract_Number = ARE.Contract_Number 
			AND CPI.Business_Transaction_ID = ARE.ITB_BU_ID  


		WHERE
			ITB.Contract_Number = Convert(int,@ContractNumber)
		) Billed
	group by InvoiceOrder,
			RecordType,
			InvoiceNumber,
			BillStartDate,
			BillEndDate
 Union
	select  InvoiceOrder,
			RecordType,
			InvoiceNumber,
			BillStartDate,
			BillEndDate,
			sum(Total_Amount) as Total_Amount,
			sum(RentalCharge) as RentalCharge,
			sum(LDW) as LDW,
			sum(OtherCoverage) as OtherCoverage,
			sum(FuleFPO) as FuleFPO,
			sum(OptionalExtra) as OptionalExtra,
			sum(Other) as Other,
			sum(GSTAmount) as GSTAmount,
			sum(PSTAmount) as PSTAmount,
			sum(PVRTAmount) as PVRTAmount
	  FROM
		(SELECT	
			1 as InvoiceOrder,
			'Billed' RecordType,      
			'Cash' as InvoiceNumber,
					
			Collected_On as BillStartDate , 
			Collected_On  as BillEndDate,		 
			Amount Total_Amount,
			0 as RentalCharge,
			0 as  LDW,	 
			0 OtherCoverage, 
			0 FuleFPO,
			0 OptionalExtra, 
			0 Other, 
			0 as GSTAmount,
			0 as PSTAmount,
			0 PVRTAmount

		FROM
			Contract_Payment_Item CPI

		WHERE
			Contract_Number = Convert(int,@ContractNumber)
			and CPI.payment_type='Cash'
		) Cash
	group by InvoiceOrder,
			RecordType,
			InvoiceNumber,
			BillStartDate,
			BillEndDate		

		
	select top 1 
			@FinalInvNum=substring(InvoiceNumber,1,charindex('-',InvoiceNumber))+right(convert(varchar,(convert(int,substring(InvoiceNumber,charindex('-',InvoiceNumber)+1,3))+1)+1000),3),
			@FinalBillStartDate=dateadd(day,1, BillEndDate) 
		from #IterimBillBal	
		where RecordType='Billed' and InvoiceNumber <>'Cash'
		order by BillStartDate desc

	select	InvoiceOrder ,
			RecordType	,	 
		InvoiceNumber ,	 
		BillStartDate  ,
		BillEndDate	  ,
		RentalCharge,
		LDW				,
		OtherCoverage	,
		FuleFPO			,
		OptionalExtra   ,
		Other			,
		PVRTAmount	,  
		GSTAmount	  ,
		PSTAmount	 ,
		TotalAmount	
	from #IterimBillBal
	union
	select 
	99 as InvoiceOrder,
	'Final Bill',
	isnull(@FinalInvNum,'') as InvoiceNumber,	 
	@FinalBillStartDate BillStartDate,
	@ActualCheckInDate BillEndDate,
	sum(Case When RecordType='Billed' Then  RentalCharge*(-1) Else RentalCharge End) RentalCharge,
	sum(Case When RecordType='Billed' Then  LDW*(-1) Else LDW End) LDW,
	sum(Case When RecordType='Billed' Then  OtherCoverage*(-1) Else OtherCoverage End) OtherCoverage,
	sum(Case When RecordType='Billed' Then  FuleFPO*(-1) Else FuleFPO End) FuleFPO,
	sum(Case When RecordType='Billed' Then  OptionalExtra*(-1) Else OptionalExtra End) OptionalExtra,
	sum(Case When RecordType='Billed' Then  Other*(-1) Else Other End) Other,
	sum(Case When RecordType='Billed' Then  PVRTAmount*(-1) Else PVRTAmount End) PVRTAmount,
	sum(Case When RecordType='Billed' Then  GSTAmount*(-1) Else GSTAmount End) GSTAmount,
	sum(Case When RecordType='Billed' Then  PSTAmount*(-1) Else PSTAmount End) PSTAmount,
	sum(Case When RecordType='Billed' Then  TotalAmount*(-1) Else TotalAmount End) TotalAmount
	from
	#IterimBillBal
	order by  InvoiceOrder,BillStartDate


	drop table #IterimBillBal
	
	RETURN @@ROWCOUNT






GO
