USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_GetARInvoice]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[ITB_GetARInvoice]-- '2015-03-10' 
	@paramRBRDate varchar(20) = '15 April 1999' 
	 
AS
 -- convert strings to datetime
DECLARE 	@RBRDate datetime 
SELECT	@RBRDate	= CONVERT(datetime, @paramRBRDate) 
	 

SELECT ar.RBR_Date, 
	   con.Email_address,	--'pni@budgetbc.com' as Email_address,	
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
       Tot.TotalAmount
       ,
       convert(varchar,(Select Max(ITBStart.StartDate) from 
		   (SELECT Contract_Number, dateadd(day,1, Interim_Bill_Date) StartDate
					FROM  dbo.Interim_Bill IB   
					Where IB.Contract_number=ar.Contract_number and IB.Interim_Bill_Date <  ITB.Interim_Bill_Date
							and isnull(ib.void,0)<>1
					Union 
					Select Contract_Number, Pick_up_on as StartDate
					from Contract  
					where Contract_number= ITB.Contract_Number 
		   )   ITBStart
		),101) as BillStartDate , convert(varchar,ITB.Interim_Bill_Date,101) as  BillEndDate
			 
FROM  dbo.AR_Export ar 
--Inner join

--     (Select Max(ITBStart.StartDate) from 
--		   (SELECT Contract_Number, Interim_Bill_Date StartDate
--					FROM  dbo.Interim_Bill IB   
--					Where IB.Contract_number=ar.Contract_number and IB.Interim_Bill_Date <  ITB.Interim_Bill_Date
--					Union 
--					Select Contract_Number, Pick_up_on as StartDate
--					from Contract  
--					where Contract_number= ITB.Contract_Number 
--		   )   ITBStart
--		) as PrevITBDate
		
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
		Inner Join dbo.Contract Con On ar.Contract_Number=con.Contract_Number
			
	 
 

Inner JOIN         
	(SELECT Contract_Number, SUM(Amount) AS TotalAmount
        FROM   (SELECT Contract_Number, Amount
                        FROM   dbo.Contract_Charge_Item AS cci
                        UNION ALL
                        SELECT Contract_Number, Flat_Amount * - 1 AS Amount
                        FROM  dbo.Contract_Reimbur_and_Discount AS cci
                ) AS Con
								  
		Group by  Contract_Number
      ) AS Tot ON ar.Contract_Number = Tot.Contract_Number
                   
WHERE (ar.Doc_Ctrl_Num_Base LIKE '%M') AND (ar.RBR_Date =@RBRDate)
	and customer_account<>'BRACCRE'

	 ----select * from	 AR_Export   where contract_number=1724109
	 --select * from Contract_Payment_Item	where contract_number=1724853




GO
