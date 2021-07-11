USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit
PURPOSE: Get all CREDIT CARD and CASH  payments or refunds for BRAC contracts

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_In,
	   View RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out,
	   View RP_Con_6_Contract_Open_Overdue_L3_Main_Contract_Overdue
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit]
AS
-- get all CREDIT CARD payments or refunds for BRAC contracts
SELECT 
    	Contract_Payment_Item.Contract_Number, 
    	Contract_Payment_Item.Sequence, 
    	Credit_Card_Type.Credit_Card_Type AS Payment_Method, 
    	Contract_Payment_Item.Amount AS Advance_Deposit,
	Contract_payment_item.payment_type
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
	Contract_Payment_Item 
		ON Contract_Payment_Item.Contract_Number = Contract.Contract_Number
	INNER 
	JOIN
    	Business_Transaction 
		ON Contract_Payment_Item.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
		AND Business_Transaction.Transaction_Description IN ('Check Out','Change','Open','Interim Billng') --prior to check in
	INNER 
	JOIN
    	Credit_Card_Payment 
		ON Contract_Payment_Item.Contract_Number = Credit_Card_Payment.Contract_Number
		AND Contract_Payment_Item.Sequence = Credit_Card_Payment.Sequence
     	INNER 
	JOIN
    	Credit_Card 
		ON Credit_Card.Credit_Card_Key = Credit_Card_Payment.Credit_Card_Key
     	INNER 
	JOIN
    	Credit_Card_Type 
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID
	
UNION ALL

-- get all CASH payments or refunds for BRAC contracts
SELECT 
    	Contract_Payment_Item.Contract_Number, 
    	Contract_Payment_Item.Sequence, 
    	Lookup_Table.Value AS Payment_Method, 
    	Contract_Payment_Item.Amount AS Advance_Deposit,
	Contract_payment_item.payment_type
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
	INNER 
	JOIN
    	Lookup_Table lt2
		ON Location.Owning_Company_ID = lt2.Code 
		AND lt2.Category = 'BudgetBC Company' 
	INNER 
	JOIN
	Contract_Payment_Item 
		ON Contract_Payment_Item.Contract_Number = Contract.Contract_Number
	INNER 
	JOIN
    	Business_Transaction 
		ON Contract_Payment_Item.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
		AND Business_Transaction.Transaction_Description IN ('Check Out','Change','Open','Interim Billng') --prior to check in
	INNER 
	JOIN
    	Cash_Payment 
		ON Contract_Payment_Item.Contract_Number = Cash_Payment.Contract_Number
		AND Contract_Payment_Item.Sequence = Cash_Payment.Sequence
	INNER 
	JOIN
	Lookup_Table
		ON Cash_Payment.Cash_Payment_Type = Lookup_Table.Code
		AND Lookup_Table.Category IN ('Cash Payment Method', 'Cash Refund Method')





















GO
