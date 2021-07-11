USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates_L2_Base_2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
VIEW NAME: RP_Acc_7_CSR_Performance_Reservation_Rates_L2_Base_2
PURPOSE: Get amounts for different time intervals for reservation rate
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main 
	to populate RP_Acc_7_CSR_Performance_Reservation_Rates table
MOD HISTORY:
Name 		Date		Comments
Jack Jian	Jun 29, 2001      Added 'flat' into day class ...  Bug Issue# 1854
Jack Jian 	2001/07/09 	Continute to add 'Hour , AM, PM , OV' in the conditions
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates_L2_Base_2]
AS
SELECT 	Confirmation_Number,
	Rate_Name,
	MAX(CASE 
		WHEN Type = 'Late' AND Time_Period in (  'Day'  , 'Hour' ) THEN
			Amount
		ELSE
			NULL
	     END
	) AS Late_Day_Rate,
	MAX(CASE 
--		WHEN Type = 'Regular' AND ( Time_Period = 'Day'  or  Time_Period = 'Flat' ) THEN
		WHEN Type = 'Regular' AND ( Time_Period in ( 'Day' ,  'Flat'  , 'Hour' , 'AM' , 'PM' , 'OV'  ) ) THEN
			Amount
		ELSE
			NULL
	     END
	) AS Daily_Rate,
	MAX(CASE 
		WHEN Type = 'Regular' AND Time_Period = 'Week' THEN
			Amount
		ELSE
			NULL
	     END
	) AS Weekly_Rate,
	MAX(CASE 
		WHEN Type = 'Regular' AND Time_Period = 'Month' THEN
			Amount
		ELSE
			NULL
	     END
	) AS Monthly_Rate
FROM RP_Acc_7_CSR_Performance_Reservation_Rates_L1_Base_1 WITH(NOLOCK)
GROUP BY 
	Confirmation_Number, 
	Rate_Name






















GO
