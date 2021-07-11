USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_GetARInvoiceByCustNo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ITB_GetARInvoiceByCustNo]  -- '2014-05-03','FORMULA M' 
	@paramRBRDate varchar(20) = '15 April 1999',
	@paramCustNo  varchar(20) 
	 
AS
 -- convert strings to datetime
DECLARE 	@RBRDate datetime 
DECLARE		@GST	 decimal(7, 2)
DECLARE		@PST	 decimal(7, 2)

SELECT	@RBRDate	= CONVERT(datetime, @paramRBRDate) 
	
 
	SELECT 	 @GST=Tax_Rate/100
	--select *
	FROM		Tax_Rate
	WHERE	@RBRDate BETWEEN Valid_From AND Valid_To and TAX_Type='GST'
	SELECT 	 @PST=Tax_Rate/100
	FROM		Tax_Rate
	WHERE	@RBRDate BETWEEN Valid_From AND Valid_To and TAX_Type='PST'


SELECT ar.RBR_Date, 
	   --con.Email_address,		
	   ar.Customer_Account, 
	  
	   ar.Amount, 
	   ar.Contract_Number, 
	   --ar.Doc_Ctrl_Num_Base, 
	   --ar.Doc_Ctrl_Num_Type, 
	   --ar.Doc_Ctrl_Num_Seq, 
--	   ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +
--				RIGHT(CONVERT(varchar, 
--				ar.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
	   rtrim(convert(varchar,ar.Contract_Number)) + '-' +
				RIGHT(CONVERT(varchar, 
				ar.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
       Tot.TotalAmount,
--       Round((ar.Amount/(1 + Tot.GSTRate+Tot.PSTRate))*Tot.GSTRate,2) GSTAmount,
--       Round((ar.Amount/(1 + Tot.GSTRate+Tot.PSTRate))*Tot.PSTRate,2) PSTAmount,
		case when convert(decimal(9,2),isnull(ITB.PST,0))>0 and @PST<>convert(decimal(9,2),isnull(ITB.PST,0))
				then  convert(decimal(9,2),(((ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+convert(decimal(9,2),isnull(ITB.PST,0))))*@GST
							+ isnull(ITB.Coverage_Amount,0)*@GST))
				else  convert(decimal(9,2),(((ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@GST
							+ isnull(ITB.Coverage_Amount,0)*@GST))
			end	 as GSTAmount,
		case when convert(decimal(9,2),isnull(ITB.PST,0))>0 and @PST<>convert(decimal(9,2),isnull(ITB.PST,0))
				then convert(decimal(9,2),((ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+convert(decimal(9,2),isnull(ITB.PST,0))))*convert(decimal(9,2),isnull(ITB.PST,0)))
				else convert(decimal(9,2),((ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))*@PST)
			end	 as PSTAmount,
       --Tot.PSTRate,
	   --Tot.GSTAmount/Tot.NetAmount GSTRate,
	   --Tot.PSTAmount/Tot.NetAmount PSTRate,
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
		),101) as BillStartDate , convert(varchar,ITB.Interim_Bill_Date,101) BillEndDate,

		case when convert(decimal(9,2),isnull(ITB.PST,0))>0 and @PST<>convert(decimal(9,2),isnull(ITB.PST,0))
				then convert(decimal(9,2),(ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+convert(decimal(9,2),isnull(ITB.PST,0)))) 
				else convert(decimal(9,2),(ar.Amount-isnull(ITB.Coverage_Amount,0)-isnull(ITB.Coverage_Amount,0)*@GST)/(1+@GST+@PST))
			end as Base_Amount,
		isnull(ITB.Coverage_Amount,0) Coverage_Amount

FROM  dbo.AR_Export ar 

Inner Join 
		--(Select	
		--	Contract_Payment_Item.RBR_date, 
		--	Interim_Bill.Contract_number,
		--	Interim_Bill.Interim_Bill_Date,	 
		--	Contract_Payment_Item.Amount,
		--	Interim_Bill.Current_Km
		--From
		--	Contract_Payment_Item
		--INNER JOIN AR_Payment 
		--	ON  Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
		--		And Contract_Payment_Item.Sequence = AR_Payment.Sequence
		-- Inner JOIN Interim_Bill 
		--	ON  AR_Payment.Contract_Number = Interim_Bill.Contract_Number
		--		And AR_Payment.Contract_Billing_Party_ID = Interim_Bill.Contract_Billing_Party_ID
		--		And AR_Payment.Interim_Bill_Date = Interim_Bill.Interim_Bill_Date
		 
			
		--)ITB
Interim_bill_vw ITB
		On  ar.Contract_Number=	 ITB.Contract_Number And  ar.RBR_Date=ITB.RBR_Date
			And ar.ITB_BU_ID=ITB.Business_transaction_id
		--Inner Join dbo.Contract Con On ar.Contract_Number=con.Contract_Number
			
	 
 

Inner JOIN         
	(	   SELECT Contract_Number, SUM(Amount+GST_Amount+PST_Amount+PVRT_Amount) AS TotalAmount--,
--				  SUM(GST_Amount + GST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included) GSTRate,
--				  Sum(PST_Amount+  PST_Amount_Included)/SUM(Amount-GST_Amount_Included - PST_Amount_Included) PSTRate,
--                  SUM(GST_Amount + GST_Amount_Included) GSTAmount,
--                  Sum(PST_Amount+  PST_Amount_Included) PSTAmount
        FROM   (SELECT Contract_Number, Amount,GST_Amount,PST_Amount,PVRT_Amount,GST_Amount_Included,  PST_Amount_Included
                        FROM   dbo.Contract_Charge_Item AS cci
                        UNION ALL
                        SELECT Contract_Number, Flat_Amount * - 1 AS Amount,0 GST_Amount,0 PST_Amount,0 PVRT_Amount, 0 GST_Amount_Included, 0 PST_Amount_Included
                        FROM  dbo.Contract_Reimbur_and_Discount AS cci
                ) AS Con
								 
		 
		Group by  Contract_Number
      ) AS Tot ON ar.Contract_Number = Tot.Contract_Number
                   
WHERE (ar.Doc_Ctrl_Num_Base LIKE '%M') AND (ar.RBR_Date =@RBRDate)
	   AND (ar.Customer_Account=@paramCustNo)
GO
