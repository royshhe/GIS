USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L1_Sales_Accessory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L1_Sales_Accessory
PURPOSE: Get information about Sales Accessory charges included in the rate

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L1_Sales_Accessory]
AS
SELECT 	Contract_Sales_Accessory.Contract_Number, 
   	Sales_Accessory.GL_Revenue_Account, 
   	Sales_Accessory.Sales_Accessory AS Description, 
   	Included_Sales_Accessory.Included_Amount * Included_Sales_Accessory.Quantity AS Amount, 
	GST_Exempt = CASE
		WHEN Contract_Sales_Accessory.GST_Exempt = 1 
		THEN 	'Y'
		ELSE 	''
	END, 
	PST_Exempt = CASE
		WHEN Contract_Sales_Accessory.PST_Exempt = 1 
		THEN 	'Y'
		ELSE 	''
	END
FROM 	Contract_Sales_Accessory  WITH(NOLOCK)
	INNER JOIN
   	Sales_Accessory 
		ON Contract_Sales_Accessory.Sales_Accessory_ID = Sales_Accessory.Sales_Accessory_ID
    	INNER JOIN
   	Included_Sales_Accessory 
		ON Sales_Accessory.Sales_Accessory_ID = Included_Sales_Accessory.Sales_Accessory_ID
    	INNER JOIN
   	Contract 
		ON Contract_Sales_Accessory.Contract_Number = Contract.Contract_Number
    		AND Included_Sales_Accessory.Rate_ID = Contract.Rate_ID 
		AND Included_Sales_Accessory.Effective_Date <= Contract.Rate_Assigned_Date
    		AND Included_Sales_Accessory.Termination_Date >= Contract.Rate_Assigned_Date
WHERE 	(Contract_Sales_Accessory.Included_In_Rate = 'Y')















GO
