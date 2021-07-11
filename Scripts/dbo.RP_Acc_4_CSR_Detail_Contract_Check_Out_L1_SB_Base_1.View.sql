USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_4_CSR_Detail_Contract_Check_Out_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Acc_4_CSR_Detail_Contract_Check_Out_L1_SB_Base_1
PURPOSE: Select all the information needed for Contract Check Out Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Contract Check Out Subreport of CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_4_CSR_Detail_Contract_Check_Out_L1_SB_Base_1]
AS
SELECT 	
	Business_Transaction.RBR_Date, 
    	Business_Transaction.Contract_Number, 
   	Contract.Pick_Up_Location_ID, 
    	RP__CSR_Who_Opened_The_Contract.User_ID 			AS CSR_Name, 
    	Vehicle_Class.Vehicle_Type_ID, 
       	Walk_Up = CASE 
		WHEN Contract.Confirmation_Number is not null
			THEN 0
		ELSE 1
		END,
	SUM(CASE
		WHEN Contract_Charge_Item.Charge_Type = 14
			THEN Contract_Charge_Item.Amount 
				- Contract_Charge_Item.GST_Amount_Included
				- Contract_Charge_Item.PST_Amount_Included 
				- Contract_Charge_Item.PVRT_Amount_Included
		ELSE 0
		END) 							AS FPO_Charge,
	SUM(CASE
		WHEN Contract_Charge_Item.Charge_Type = 33
			THEN Contract_Charge_Item.Amount 
				- Contract_Charge_Item.GST_Amount_Included
				- Contract_Charge_Item.PST_Amount_Included 
				- Contract_Charge_Item.PVRT_Amount_Included
		ELSE 0
		END)							AS Drop_Off_Charge,
	SUM(CASE
		WHEN Contract_Charge_Item.Charge_Type = 34
			THEN Contract_Charge_Item.Amount 
				- Contract_Charge_Item.GST_Amount_Included
				- Contract_Charge_Item.PST_Amount_Included 
				- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END) 						AS Additional_Driver_Charge
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
    	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
	INNER JOIN
    	RP__CSR_Who_Opened_The_Contract 
		ON Contract.Contract_Number = RP__CSR_Who_Opened_The_Contract.Contract_Number
     	INNER JOIN Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
    	(Business_Transaction.Transaction_Description = 'check out') 
    	AND 
	(NOT (Contract.Status = 'vd')) 
GROUP BY
	Business_Transaction.RBR_Date, 
    	Business_Transaction.Contract_Number, 
    	Contract.Pick_Up_Location_ID, 
    	RP__CSR_Who_Opened_The_Contract.User_ID, 
    	Vehicle_Class.Vehicle_Type_ID,
    	Contract.Confirmation_Number






























GO
