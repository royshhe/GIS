USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Res_Opened_To_Con]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME:  	 RP_Res_11_Reservation_Rate_Performance_L2_Base_Res_Opened_To_Con
PURPOSE:           Group all reservations that are opened to contracts

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	 RP_Res_11_Reservation_Rate_Performance_L3_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Res_Opened_To_Con]
AS
SELECT 
	Contract.Contract_Number, 
    	Contract.Confirmation_Number,
	Contract.Vehicle_Class_Code,
	Rate_ID = CASE WHEN Contract.Rate_ID IS NOT NULL
			THEN Contract.Rate_ID
			ELSE Contract.Quoted_Rate_ID
		   END,
	Rate_Level = CASE WHEN Contract.Rate_ID IS NOT NULL
			THEN Contract.Rate_Level
			ELSE NULL
		          END,
	Contract.Status,
	Business_Transaction.RBR_Date AS Check_Out_RBR_Date
FROM 	Contract
	INNER 
	JOIN
    	Reservation 
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
	LEFT 
	JOIN
	Business_Transaction
		ON Contract.Contract_Number = Business_Transaction.Contract_Number
		AND Business_Transaction.Transaction_Type = 'Con'
		AND Business_Transaction.Transaction_Description = 'Check Out'
 	























GO
