USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
VIEW NAME: RP_Acc_7_CSR_Performance_Reservation_Rates_L1_Base_1
PURPOSE: Get reservation rate information
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_7_CSR_Performance_Reservation_Rates_L2_Base_1
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/27	hard code the selection of Rate_Time_Period.Time_Period_Start and 
				Quoted_Time_Period_Rate.Time_Period_Start to improve performance
Jack Jian            2001/06/29       added 'Flat' in the conditions...   Bug Issue# 1854
Jack Jian 	2001/07/09 	Continute to add 'Hour , AM, PM , OV' in the conditions
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_Reservation_Rates_L1_Base_1]
AS
SELECT 	Reservation.Confirmation_Number, 
   	Vehicle_Rate.Rate_Name, 
	Rate_Time_Period.Type, 
   	Rate_Time_Period.Time_Period, 
   	Rate_Charge_Amount.Amount
FROM 	Reservation  WITH(NOLOCK)
	INNER JOIN
   	Vehicle_Rate 
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
    		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
    	INNER JOIN
   	Rate_Time_Period 
		ON Reservation.Rate_ID = Rate_Time_Period.Rate_ID 
		AND Reservation.Date_Rate_Assigned >= Rate_Time_Period.Effective_Date
    		AND Reservation.Date_Rate_Assigned <= Rate_Time_Period.Termination_Date
    	INNER JOIN
   	Rate_Vehicle_Class 
		ON Reservation.Rate_ID = Rate_Vehicle_Class.Rate_ID 	
		AND Reservation.Date_Rate_Assigned >= Rate_Vehicle_Class.Effective_Date
    		AND Reservation.Date_Rate_Assigned <= Rate_Vehicle_Class.Termination_Date
    		AND Reservation.Vehicle_Class_Code = Rate_Vehicle_Class.Vehicle_Class_Code
    	INNER JOIN
   	Rate_Charge_Amount 
		ON Reservation.Rate_ID = Rate_Charge_Amount.Rate_ID 
		AND Rate_Vehicle_Class.Rate_Vehicle_Class_ID = Rate_Charge_Amount.Rate_Vehicle_Class_ID
    		AND Rate_Time_Period.Rate_Time_Period_ID = Rate_Charge_Amount.Rate_Time_Period_ID
    		AND Rate_Time_Period.Type = Rate_Charge_Amount.Type 
		AND Reservation.Rate_Level = Rate_Charge_Amount.Rate_Level 
		AND Reservation.Date_Rate_Assigned >= Rate_Charge_Amount.Effective_Date
    		AND Reservation.Date_Rate_Assigned <= Rate_Charge_Amount.Termination_Date
WHERE 	((Rate_Time_Period.Type = 'Regular' AND Rate_Time_Period.Time_Period IN ('Day','Week','Month','Flat' , 'Hour' , 'AM' , 'PM' , 'OV'  ))
	OR
	(Rate_Time_Period.Type = 'Late' AND Rate_Time_Period.Time_Period in (  'Day' , 'Hour' ) ))
	AND
	(Rate_Time_Period.Time_Period_Start = 1)

UNION ALL
--Masetro Rates
SELECT 	Reservation.Confirmation_Number, 
   	Quoted_Vehicle_Rate.Rate_Name, 
   	Quoted_Time_Period_Rate.Rate_Type, 
   	Quoted_Time_Period_Rate.Time_Period, 
   	Quoted_Time_Period_Rate.Amount
FROM 	Quoted_Vehicle_Rate WITH(NOLOCK)
	INNER JOIN
   	Quoted_Time_Period_Rate 
		ON Quoted_Vehicle_Rate.Quoted_Rate_ID = Quoted_Time_Period_Rate.Quoted_Rate_ID
    	INNER JOIN
   	Reservation 
		ON Quoted_Vehicle_Rate.Quoted_Rate_ID = Reservation.Quoted_Rate_ID
WHERE 	((Quoted_Time_Period_Rate.Rate_Type = 'Regular' AND Quoted_Time_Period_Rate.Time_Period IN ('Day', 'Week','Month','Flat' , 'Hour' , 'AM' , 'PM' , 'OV'  ))
	OR
   	(Quoted_Time_Period_Rate.Rate_Type = 'Late' AND Quoted_Time_Period_Rate.Time_Period in (  'Day' , 'Hour' ) ))
	AND
	(Quoted_Time_Period_Rate.Time_Period_Start = 1)





















GO
