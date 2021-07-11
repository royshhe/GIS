USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_5_CSR_Summary_Sales_Accessories_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_5_CSR_Summary_Sales_Accessories_L1_SB_Base_1
PURPOSE: Select all the information needed for Sales Accessories Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Sales Accessories Subreport of CSR Summary Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_5_CSR_Summary_Sales_Accessories_L1_SB_Base_1]
AS
-- Contract Sales Accessories
SELECT 	
	Business_Transaction.RBR_Date, 
    	Contract.Pick_Up_Location_ID, 
    	RP__CSR_Who_Opened_The_Contract.User_ID 	AS CSR_Name, 
    	Vehicle_Class.Vehicle_Type_ID, 
    	Sales_Accessory.Sales_Accessory, 
    	Contract_Charge_Item.Quantity, 
    	Contract_Charge_Item.Amount 
		- Contract_Charge_Item.PST_Amount_Included
     		- Contract_Charge_Item.GST_Amount_Included 
		- Contract_Charge_Item.PVRT_Amount_Included  AS Amount
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
     	INNER JOIN
    	RP__CSR_Who_Opened_The_Contract 
		ON Contract.Contract_Number = RP__CSR_Who_Opened_The_Contract.Contract_Number
	INNER JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER JOIN
    	Sales_Accessory 
		ON Contract_Charge_Item.Sales_Accessory_ID = Sales_Accessory.Sales_Accessory_ID
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
    	(Business_Transaction.Transaction_Description = 'Check In') 
    	AND 
	(NOT (Contract.Status = 'vd')) 
	AND 
    	(Contract_Charge_Item.Charge_Type = '13')

UNION ALL

-- Separate Sales Accessories
SELECT 	
	Business_Transaction.RBR_Date, 
    	Business_Transaction.Location_ID AS Pick_Up_Location_ID, 
    	Business_Transaction.User_ID AS CSR_Name, 
    	'Truck' 	AS Vehicle_Type_ID, 
    	Sales_Accessory.Sales_Accessory, 
    	Sales_Accessory_Sale_Item.Quantity, 
    	Sales_Accessory_Sale_Item.Amount
FROM 	Business_Transaction 
	INNER JOIN
    	Sales_Accessory_Sale_Item 
		ON Business_Transaction.Sales_Contract_Number = Sales_Accessory_Sale_Item.Sales_Contract_Number
     	INNER JOIN
    	Sales_Accessory 
		ON Sales_Accessory_Sale_Item.Sales_Accessory_ID = Sales_Accessory.Sales_Accessory_ID
WHERE 	
	(Business_Transaction.Transaction_Type = 'SLS') 
	AND 
    	(Business_Transaction.Transaction_Description = 'Sale')






















GO
