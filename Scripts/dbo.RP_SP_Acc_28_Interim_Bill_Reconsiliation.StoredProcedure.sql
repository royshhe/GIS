USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_28_Interim_Bill_Reconsiliation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure  [dbo].[RP_SP_Acc_28_Interim_Bill_Reconsiliation]
as
SELECT	CON.Contract_Number,
CON.Pick_up_On,
Con.Drop_Off_On DueBack,
    arcust.address_Name,
    DBPB.PO_Number,
    CON.Email_address,	
	--CON.Pick_Up_Location_Id,
	--CON.Vehicle_Class_Code,
	--CON.Rate_ID,
	--CON.Rate_Assigned_Date,
	--CON.Rate_Level,
	--CON.Flex_Discount,
	--CON.Member_Discount_ID,
	(Case When VEH.Foreign_Vehicle_Unit_Number is null then VEH.Unit_number Else VEH.Foreign_Vehicle_Unit_Number End) Unit_Number,
	VMY.Model_Name,
	
 
	 
   (Select Max(ITBStart.StartDate) from 
	   (SELECT  Contract_Number, 
				dateadd(day,1, Interim_Bill_Date) StartDate
				FROM  dbo.Interim_Bill ITB   
				Where ITB.Contract_number=Con.Contract_number 
					And ITB.Interim_Bill_Date <  IB.Interim_Bill_Date
				Union 
				Select Contract_Number, Pick_up_on as StartDate
				from Contract  
				where Contract_number= IB.Contract_Number 
	   )   ITBStart
	) as BillStartDate , 
	--ITBAR.BillStartDate BillStartDate1,
	
	IB.Interim_Bill_Date BillEndDate,
	--ITBAR.BillEndDate,	
	--IB.Current_KM,
	
	--VMY.PST_Rate,
	--IB.Contract_Billing_Party_ID,
	Tot.TotalAmount,
	InvoiceNumber,
	ITBAR.RBR_Date, 
	ITBAR.Amount AmountBilled
			    
FROM	Contract CON 
Inner Join	Contract_Billing_Party CBP
	On	CON.Contract_Number = CBP.Contract_Number
		AND	CBP.Billing_Type = 'p'	-- Primary
		AND	CBP.Billing_Method = 'Direct Bill'
Inner Join armaster_base arcust
	On	CBP.customer_code= arcust.customer_code
Inner join 
	Direct_Bill_Primary_Billing DBPB
	On 	CON.contract_number = DBPB.Contract_Number
	AND	DBPB.Issue_Interim_Bills = CONVERT(Bit, '1')
Inner Join Vehicle_On_Contract VOC
	on CON.Contract_Number = VOC.Contract_Number AND VOC.Actual_Check_In IS NULL
inner join Vehicle VEH 
	on VOC.Unit_Number = VEH.Unit_Number
Inner join Vehicle_Model_Year VMY
	on 	VEH.Vehicle_Model_Id = VMY.Vehicle_Model_Id
Inner JOIN         
	(SELECT Contract_Number, SUM(Amount) AS TotalAmount
        FROM   (SELECT Contract_Number, Amount
                        FROM   dbo.Contract_Charge_Item AS cci
                        UNION ALL
                        SELECT Contract_Number, Flat_Amount * - 1 AS Amount
                        FROM  dbo.Contract_Reimbur_and_Discount AS cci
                ) AS Con
								  
		Group by  Contract_Number
      ) AS Tot ON con.Contract_Number = Tot.Contract_Number

Left join
	Interim_Bill IB
	On CON.Contract_Number = IB.Contract_Number
	AND	CBP.Contract_Billing_Party_Id = IB.Contract_Billing_Party_Id 
Left Join

( 		 
	SELECT ar.RBR_Date, 
		   --con.Email_address,		
		   ar.Customer_Account, 
		  
		   ar.Amount, 
		   ar.Contract_Number, 
		  
		   ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +
					RIGHT(CONVERT(varchar, 
					ar.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
	       
		  
		 --  (Select Max(ITBStart.StartDate) from 
			--   (SELECT Contract_Number, dateadd(day,1, Interim_Bill_Date) StartDate
			--			FROM  dbo.Interim_Bill IB   
			--			Where IB.Contract_number=ar.Contract_number and IB.Interim_Bill_Date <  ITB.Interim_Bill_Date
			--			Union 
			--			Select Contract_Number, Pick_up_on as StartDate
			--			from Contract  
			--			where Contract_number= ITB.Contract_Number 
			--   )   ITBStart
			--) as BillStartDate , 
			ITB.Interim_Bill_Date BillEndDate,
			ITB.Contract_Billing_Party_Id
				 
	FROM  dbo.AR_Export ar 
			
	Inner Join Interim_bill_vw ITB
			On  ar.Contract_Number=	 ITB.Contract_Number And  ar.RBR_Date=ITB.RBR_Date
				And ar.ITB_BU_ID=ITB.Business_transaction_id
	Inner Join dbo.Contract Con On ar.Contract_Number=con.Contract_Number
			           
	WHERE (ar.Doc_Ctrl_Num_Base LIKE '%i') --AND (ar.RBR_Date =@RBRDate)
 )	ITBAR
 	On CON.Contract_Number = ITBAR.Contract_Number
	AND	CBP.Contract_Billing_Party_Id = ITBAR.Contract_Billing_Party_Id 
	And IB.Interim_Bill_Date=ITBAR.BillEndDate
WHERE	CON.Status = 'CO'
 
order by  CON.Contract_Number,   IB.Interim_Bill_Date
 

--( 		 
--	SELECT ar.RBR_Date, 
--		   con.Email_address,		
--		   ar.Customer_Account, 
		  
--		   ar.Amount, 
--		   ar.Contract_Number, 
		  
--		   ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +
--					RIGHT(CONVERT(varchar, 
--					ar.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
	       
--		   ,
--		   (Select Max(ITBStart.StartDate) from 
--			   (SELECT Contract_Number, dateadd(day,1, Interim_Bill_Date) StartDate
--						FROM  dbo.Interim_Bill IB   
--						Where IB.Contract_number=ar.Contract_number and IB.Interim_Bill_Date <  ITB.Interim_Bill_Date
--						Union 
--						Select Contract_Number, Pick_up_on as StartDate
--						from Contract  
--						where Contract_number= ITB.Contract_Number 
--			   )   ITBStart
--			) as BillStartDate , ITB.Interim_Bill_Date BillEndDate
				 
--	FROM  dbo.AR_Export ar 
			
--	Inner Join 
			
--			Interim_bill_vw ITB
--			On  ar.Contract_Number=	 ITB.Contract_Number And  ar.RBR_Date=ITB.RBR_Date
--				And ar.ITB_BU_ID=ITB.Business_transaction_id
--			Inner Join dbo.Contract Con On ar.Contract_Number=con.Contract_Number
				
		 
	 

	                   
--	WHERE (ar.Doc_Ctrl_Num_Base LIKE '%i') --AND (ar.RBR_Date =@RBRDate)
-- )   IB
GO
