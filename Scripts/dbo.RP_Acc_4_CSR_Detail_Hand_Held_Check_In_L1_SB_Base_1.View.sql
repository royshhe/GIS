USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_4_CSR_Detail_Hand_Held_Check_In_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_4_CSR_Detail_Hand_Held_Check_In_L1_SB_Base_1
PURPOSE: Select all the information needed for Hand Held Check In Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Hand Held Check In Subreport of CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_4_CSR_Detail_Hand_Held_Check_In_L1_SB_Base_1]
AS
SELECT 
	Business_Transaction.RBR_Date, 
   	Business_Transaction.Location_ID,
   	Business_Transaction.User_ID 				AS CSR_Name,
	Vehicle_Class.Vehicle_Type_ID, 
   	Business_Transaction.Contract_Number,
	SUM( CASE
		WHEN Contract_Charge_Item.Charge_Type = 18
			THEN Contract_Charge_Item.Amount 
				- Contract_Charge_Item.GST_Amount_Included
				- Contract_Charge_Item.PST_Amount_Included 
				- Contract_Charge_Item.PVRT_Amount_Included
		ELSE 0
		END) 							AS Fuel_Charge
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    	LEFT OUTER JOIN
   	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'Check In') 
	AND
    	(Business_Transaction.Entered_On_Handheld = 1)
GROUP BY 	Business_Transaction.RBR_Date, 
   		Business_Transaction.Location_ID, 
   		Business_Transaction.User_ID, 
		Vehicle_Class.Vehicle_Type_ID, 
   		Business_Transaction.Contract_Number





















GO
