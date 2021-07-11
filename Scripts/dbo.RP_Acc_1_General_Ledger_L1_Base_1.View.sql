USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_1_General_Ledger_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_1_General_Ledger_L1_Base_1
PURPOSE: Get the information about business transaction and document associated with
	 it (Reservation, Contract, Sales Accessory)

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_1_General_Ledger_L2_Base_1
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_1_General_Ledger_L1_Base_1]
AS
-- Get the RESERVATION transactions
SELECT	Business_Transaction.RBR_Date, 
    	Reservation.Pick_Up_Location_ID AS Revenue_Location_ID, 
    	(case when Reservation.Foreign_Confirm_Number is null 
		then convert(varchar, Reservation.Confirmation_Number)
		else Reservation.Foreign_Confirm_Number
		end) AS Document_Number, 
    	'Reservation' AS Document_Type,
    	Business_Transaction.Business_Transaction_ID
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Reservation 
		ON Business_Transaction.Confirmation_Number = Reservation.Confirmation_Number

-- Get the CONTRACT transactions
UNION ALL
SELECT 	Business_Transaction.RBR_Date, 
    	Contract.Pick_Up_Location_ID AS Revenue_Location_ID, 
    	convert (varchar,Contract.Contract_Number) AS Document_Number,  
    	'Contract' AS Document_Type,
    	Business_Transaction.Business_Transaction_ID
FROM 	Business_Transaction 
	INNER JOIN
    	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number

-- Get the Sales Accesories transactions
UNION ALL
SELECT	Business_Transaction.RBR_Date, 
    	Sales_Accessory_Sale_Contract.Sold_At_Location_ID AS Revenue_Location_ID,
     	convert( varchar, Business_Transaction.Sales_Contract_Number) AS Document_Number,
     	'Acc.Sales' AS Document_Type,
	Business_Transaction.Business_Transaction_ID
FROM 	Business_Transaction 
     	INNER JOIN
    	Sales_Accessory_Sale_Contract 
		ON Business_Transaction.Sales_Contract_Number = Sales_Accessory_Sale_Contract.Sales_Contract_Number


























GO
