USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_4_CSR_Detail_Optional_Extras_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Acc_4_CSR_Detail_Optional_Extras_L1_SB_Base_1
PURPOSE: Select all the information needed for Optional Extra Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Optional Extra Subreport of CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_4_CSR_Detail_Optional_Extras_L1_SB_Base_1]
AS
SELECT 	
	Business_Transaction.RBR_Date, 
   	Business_Transaction.Contract_Number, 
   	Contract.Pick_Up_Location_ID, 
   	RP__CSR_Who_Opened_The_Contract.User_ID 	AS CSR_Name, 
   	Vehicle_Class.Vehicle_Type_ID, 
   	Contract_Charge_Item.Amount 
		- Contract_Charge_Item.GST_Amount_Included
    		- Contract_Charge_Item.PST_Amount_Included 
		- Contract_Charge_Item.PVRT_Amount_Included AS Amount,
	Optional_Extra.Optional_Extra, 
	ROUND(DATEDIFF(mi, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) / 1440.0,1) AS Rental_Days
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
	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
    	INNER JOIN
	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
	(Business_Transaction.Transaction_Description = 'Check In') 
   	AND 
	(NOT (Contract.Status = 'vd')) 
	AND 
   	(Contract_Charge_Item.Charge_Type = '12') 
	AND 
   	(Vehicle_On_Contract.Actual_Check_In =	(SELECT MAX(voc.Actual_Check_In)
     						FROM Vehicle_On_Contract voc
     						WHERE voc.contract_Number = Vehicle_On_Contract.Contract_Number))






















GO
