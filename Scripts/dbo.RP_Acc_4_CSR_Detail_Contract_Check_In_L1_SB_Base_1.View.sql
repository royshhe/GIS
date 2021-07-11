USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_4_CSR_Detail_Contract_Check_In_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_4_CSR_Detail_Contract_Check_In_L1_SB_Base_1
PURPOSE: Select all the information needed for Contract Check In Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Contract Check In Subreport of CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/02/15	Correct rounding of reservation revenue
Joseph Tseung   2000/02/15	Get the Maestro reservation number
*/
CREATE VIEW [dbo].[RP_Acc_4_CSR_Detail_Contract_Check_In_L1_SB_Base_1]
AS
SELECT Business_Transaction.RBR_Date, 
   	Contract.Pick_Up_Location_ID, 
   	RP__CSR_Who_Opened_The_Contract.User_ID	AS CSR_Name, 
   	Vehicle_Class.Vehicle_Type_ID, 
   	Business_Transaction.Contract_Number, 
   	Contract.Confirmation_Number, 
	Reservation.Foreign_Confirm_Number AS Foreign_Confirmation_Number,
	Contract.Reservation_Revenue AS Reservation_Revenue,
	ROUND(DATEDIFF(mi, Contract.Pick_Up_On,RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0,1)  AS Contract_Rental_Days,
                  SUM( 	CASE 
			WHEN Contract_Charge_Item.Charge_Type IN (10, 11, 20, 50, 51, 52)
			THEN Contract_Charge_Item.Amount	
						- Contract_Charge_Item.GST_Amount_Included 
						- Contract_Charge_Item.PST_Amount_Included
   						- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
		END)  AS Contract_Revenue
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Business_Transaction 
		ON Contract.Contract_Number = Business_Transaction.Contract_Number
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
   	RP__Last_Vehicle_On_Contract 
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number
	LEFT JOIN
	Reservation 
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
WHERE 	
	(NOT (Contract.Status = 'vd')) 	
	AND 
   	(Business_Transaction.Transaction_Type = 'con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'Check In') 
	AND
    	(Contract.Confirmation_Number IS NOT NULL) 
GROUP BY	Business_Transaction.RBR_Date, 
   		Contract.Pick_Up_Location_ID, 
   		RP__CSR_Who_Opened_The_Contract.User_ID,
   		Vehicle_Class.Vehicle_Type_ID, 
   		Business_Transaction.Contract_Number, 
   		Contract.Confirmation_Number, 
   		Reservation.Foreign_Confirm_Number,
		Contract.Reservation_Revenue,
		RP__Last_Vehicle_On_Contract.Actual_Check_In,
		Contract.Pick_Up_On

























GO
