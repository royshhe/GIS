USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_7_Reservation_Summary_By_GIS_Rate_Name_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Res_7_Reservation_Summary_By_GIS_Rate_Name_L1_Base
PURPOSE: Get the information about reservations

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Res_7_Reservation_Summary_By_GIS_Rate_Name_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_7_Reservation_Summary_By_GIS_Rate_Name_L1_Base]
AS
SELECT 	Reservation.Source_Code,
 	Vehicle_Class.Vehicle_Type_ID, 
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID, 
    	Vehicle_Class.Vehicle_Class_Name, 
    	Location.Owning_Company_ID AS Company_ID, 
    	Owning_Company.Name AS Company_Name, 
    	Reservation.Pick_Up_Location_ID, 
    	Location.Location AS Pick_Up_Location_Name, 
    	CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On) + ' '
		+ DATENAME(month, Reservation.Pick_Up_On) + ' ' + DATENAME(Year, Reservation.Pick_Up_On))) 
		AS Pick_Up_Day, 
    	Vehicle_Rate.Rate_Name,
	Reservation.Rate_Level, 
    	Reservation.Status, Reservation.Confirmation_Number
FROM 	Reservation WITH(NOLOCK)
	INNER JOIN
    	Vehicle_Class
 		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Location 
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
    	Owning_Company 
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	INNER JOIN
    	Vehicle_Rate 
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
     		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
WHERE 	Reservation.Status IN ('N', 'O', 'A')
















GO
