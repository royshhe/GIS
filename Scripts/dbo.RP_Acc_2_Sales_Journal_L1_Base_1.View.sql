USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_2_Sales_Journal_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_2_Sales_Journal_L1_Base_1
PURPOSE: Get the information about business transaction and documents associated with
		it (Reservation, Contract, Sales Accessory)

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_2_Sales_Journal_L1_Base_1
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/01	include Maestro reservation number (foreign reservation number) in record selection
*/
CREATE VIEW [dbo].[RP_Acc_2_Sales_Journal_L1_Base_1]
AS
-- Get the RESERVATION  info
SELECT 	Business_Transaction.Business_Transaction_ID, 
    	Business_Transaction.RBR_Date, 
	Business_Transaction.Transaction_Date,
    	'Reservation' AS Document_Type,
    	Reservation.Confirmation_Number AS Document_Number,
	Reservation.Foreign_Confirm_Number AS Foreign_Document_Number,
    	Business_Transaction.Transaction_Description,
		Reservation.Pick_Up_Location_ID	AS Revenue_Location_ID,
		CASE Vehicle_Class.Vehicle_Type_ID
		WHEN 	'Truck' THEN 	'Truck Rental'
		WHEN 	'Car' 	THEN 	'Car Rental'
		ELSE '*** Undefined ***'
		END 		AS Sales_Type
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Reservation 
		ON Business_Transaction.Confirmation_Number = Reservation.Confirmation_Number
     	INNER JOIN
    	Vehicle_Class 
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
-- Get the CONTRACT info
UNION ALL
SELECT Business_Transaction.Business_Transaction_ID, 
    	Business_Transaction.RBR_Date, 
	Business_Transaction.Transaction_Date,
	'Contract' AS Document_Type,
    	Business_Transaction.Contract_Number AS Document_Number,
	NULL AS Foreign_Document_Number,
    	Business_Transaction.Transaction_Description,
	Contract.Pick_Up_Location_ID AS Revenue_Location_ID,
	CASE Vehicle_Class.Vehicle_Type_ID
	WHEN 	'Truck' THEN 	'Truck Rental'
	WHEN 	'Car' 	THEN 	'Car Rental'
	ELSE  '*** Undefined ***'
	END		AS Sales_Type
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
     	INNER JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
-- Get the ACCESSORY info
UNION ALL
SELECT 	Business_Transaction.Business_Transaction_ID, 
    	Business_Transaction.RBR_Date, 
	Business_Transaction.Transaction_Date,
	'Acc.Sales' AS Document_Type,    	
	Business_Transaction.Sales_Contract_Number AS Document_Number, 
	NULL AS Foreign_Document_Number,
    	Business_Transaction.Transaction_Description,
	Sales_Accessory_Sale_Contract.Sold_At_Location_Id AS Revenue_Location_ID,
	'Accessory Sales' AS Sales_Type
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Sales_Accessory_Sale_Contract 
		ON Business_Transaction.Sales_Contract_Number = Sales_Accessory_Sale_Contract.Sales_Contract_Number





















GO
