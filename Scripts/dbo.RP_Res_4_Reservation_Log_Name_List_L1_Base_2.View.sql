USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_4_Reservation_Log_Name_List_L1_Base_2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
VIEW NAME: RP_Res_4_Reservation_Log_Name_List_L1_Base_2
PURPOSE: Get the information about reservations

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Res_4_Reservation_Log_Name_List_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph T	Sep 10, 1999     Integrate WHERE clauses into the join condition for correct result
*/
CREATE VIEW [dbo].[RP_Res_4_Reservation_Log_Name_List_L1_Base_2]
AS
SELECT	
	Reservation.Confirmation_Number, 
	Reservation.Source_Code, 
	Reservation.Executive_Action_Indicator 	AS EXE, 
	Reservation.Program_Number	 	AS BCN, 
        Reservation.BCD_Number			AS BCD_Number,
	Reservation.Applicant_Status_Indicator 	AS APP, 
	Reservation.Perfect_Drive_Indicator 		AS PDP, 
	Reservation.Fastbreak_Indicator 		AS FBP, 
	Reservation.Pick_Up_On, 
	Reservation.Drop_Off_On, 
	--DATEDIFF(DAY, Reservation.Pick_Up_On, Reservation.Drop_Off_On) 	AS Length, 
	CEILING(dbo.GetRentalDays(DATEDIFF(hour, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On))) AS Length, 
	Reservation.Special_Comments		 AS Remarks, 
	Reservation.Rate_Level 			AS GIS_Rate_Level, 
	Vehicle_Rate.Rate_Name 			AS GIS_Rate_Name, 
	Vehicle_Class.Vehicle_Type_ID, 
	Reservation.Vehicle_Class_Code 		AS Vehicle_Class_ID, 
	Vehicle_Class.Vehicle_Class_Name, 
	Quoted_Vehicle_Rate.Rate_Name 		AS M_Rate_Name, 
	Quoted_Vehicle_Rate.Rate_Structure 	AS M_Rate_Structure, 
	Quoted_Vehicle_Rate.Authorized_DO_Charge 	AS M_Authorized_DO_Charge,
	Quoted_Vehicle_Rate.Per_KM_Charge 	AS M_Per_KM_Charge, 
	Quoted_Time_Period_Rate.Time_Period 	AS M_Time_Period, 
	Quoted_Time_Period_Rate.Time_Period_Start	AS M_Time_Period_Start,
	Quoted_Time_Period_Rate.Time_Period_End 	AS M_Time_Period_End,
	Quoted_Time_Period_Rate.Amount 		AS M_Amount, 
	Quoted_Time_Period_Rate.Km_Cap 		AS M_Km_Cap, 
	Quoted_Time_Period_Rate.Rate_Type 	AS M_Rate_Type, 
	Reservation.Status
FROM 	Vehicle_Class WITH(NOLOCK)
	INNER JOIN
    	Reservation 
		ON Vehicle_Class.Vehicle_Class_Code = Reservation.Vehicle_Class_Code
		AND Reservation.Status IN ('A','N')
     	LEFT OUTER JOIN
    	Vehicle_Rate 
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
     		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
     	LEFT OUTER JOIN
    	Quoted_Time_Period_Rate 
	INNER JOIN
    	Quoted_Vehicle_Rate 
		ON Quoted_Time_Period_Rate.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID
		AND Quoted_Time_Period_Rate.Rate_Type = 'regular'
     	
	ON Reservation.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID


























GO
