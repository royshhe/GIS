USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_SR_Cdn_Cash_Totals
PURPOSE: Get breakdown of Canadian cash amounts for all transactions 

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/12/16
USED BY: Subreport (Cdn Cash Totals by Location/Company) of report RP_Con_4_Location_EOD_Reconciliation.rpt
MOD HISTORY:
Name 		Date		Comments
*/

create VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals]
AS
-- Select Cdn Cert amounts for contracts
SELECT
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Prepayment.payment_type AS Cert_Type,
	sum(Prepayment.Foreign_currency_amt_collected) as Cert_Amount,
	Prepayment.Currency_ID	

FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Business_Transaction 
		ON Contract.Contract_Number = Business_Transaction.Contract_Number
		AND Business_Transaction.Transaction_Type = 'Con'
        INNER 
	JOIN
    	Location loc1 
		ON Business_Transaction.Location_ID = loc1.Location_ID 
	INNER
     	JOIN
    	Lookup_Table lt1
		ON loc1.Owning_Company_ID = lt1.Code 
		AND lt1.Category = 'BudgetBC Company'
	INNER
	JOIN
    	Contract_Payment_Item 
		ON Business_Transaction.Business_Transaction_ID = Contract_Payment_Item.Business_Transaction_ID
	INNER 
	JOIN
	Location loc2
		ON Contract_Payment_Item.Collected_At_Location_ID = loc2.Location_ID
		AND Contract_Payment_Item.Copied_Payment = 0
	INNER
     	JOIN
    	Lookup_Table lt2
		ON loc2.Owning_Company_ID = lt2.Code 
		AND lt2.Category = 'BudgetBC Company' 
	INNER 
	JOIN
   	Prepayment  
		ON Contract_Payment_Item.Contract_Number = Prepayment.Contract_Number
     		AND Contract_Payment_Item.Sequence = Prepayment.Sequence 
		AND Prepayment.payment_type in ('Certificate')
--where Business_Transaction.RBR_Date='2010/10/26'
group by	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Prepayment.payment_type,
	Prepayment.Currency_ID
GO
