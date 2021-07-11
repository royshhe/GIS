USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_ACC_31_GetIBARInvoiceListing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[RP_SP_ACC_31_GetIBARInvoiceListing] -- '2016-04-01' , '2017-04-01' 
	@paramStartDate varchar(20) = '15 April 1999' ,
	@paramEndDate varchar(20) = '15 April 1999' 
	 
AS
 -- convert strings to datetime
DECLARE 	@StartDate datetime 
DECLARE 	@EndDate datetime 
SELECT	@StartDate	= CONVERT(datetime, @paramStartDate) 
SELECT	@EndDate	= CONVERT(datetime, @paramEndDate) 
	 


--Invoice Generated..................

SELECT ar.RBR_Date as Interim_Bill_Date, 
	   convert(varchar,ar.Customer_Account) as Customer_Account, 
	   con.Email_address,	--'pni@budgetbc.com' as Email_address,	
	   ar.Contract_Number, 
	   rtrim(convert(varchar,ar.Contract_Number)) + '-' +
				RIGHT(CONVERT(varchar, 
				ar.doc_ctrl_num_seq + 1000), 3) as InvoiceNumber,
	   ar.Amount, 
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
		
Inner Join 
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
                   
WHERE (ar.Doc_Ctrl_Num_Base LIKE '%M') AND 
		ar.RBR_Date Between @StartDate and @EndDate and 
		customer_account<>'BRACCRE'

union 

--Invoice not Generated Yet......................

--Select	Interim_Bill.*,Contract_Payment_Item.*,AR_Payment.*
select	IB.Interim_Bill_Date,
		convert(varchar,CBP.Customer_Code) as Customer_Account, 
	    C.Email_address as Email_address,	--'pni@budgetbc.com' as Email_address,	
	    IB.contract_number, 
	    '' as InvoiceNumber,
	    null as Amount, 
        null as TotalAmount,
       convert(varchar,(Select Max(ITBStart.StartDate) from 
		   (SELECT Contract_Number, dateadd(day,1, Interim_Bill_Date) StartDate
					FROM  dbo.Interim_Bill IB1   
					Where IB1.Contract_number=c.Contract_number and IB1.Interim_Bill_Date <  IB.Interim_Bill_Date
							and isnull(ib1.void,0)<>1
					Union 
					Select Contract_Number, Pick_up_on as StartDate
					from Contract  
					where Contract_number= IB.Contract_Number 
		   )   ITBStart
		),101)
		 as BillStartDate , 
		convert(varchar,IB.Interim_Bill_Date,101)  as  BillEndDate
From	Interim_Bill IB left join 
			Contract_Payment_Item
				INNER JOIN
				  AR_Payment ON
					Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
					And Contract_Payment_Item.Sequence = AR_Payment.Sequence
			on	AR_Payment.Contract_Number = IB.Contract_Number
			And AR_Payment.Contract_Billing_Party_ID = IB.Contract_Billing_Party_ID
			And AR_Payment.Interim_Bill_Date = IB.Interim_Bill_Date
		inner join contract C on IB.contract_number=C.contract_number
		inner join Contract_billing_party CBP  on IB.contract_number=CBP.contract_number
Where Contract_Payment_Item.amount is null	and (isnull(IB.void,0)<>1 )
		and IB.Interim_Bill_Date Between @StartDate and @EndDate
		and c.status in ('OP','CO')

--and Interim_Bill.contract_number='2012434'

order by Interim_Bill_Date,Customer_Account
GO
