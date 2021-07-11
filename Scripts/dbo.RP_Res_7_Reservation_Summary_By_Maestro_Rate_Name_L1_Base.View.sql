USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_7_Reservation_Summary_By_Maestro_Rate_Name_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Res_7_Reservation_Summary_By_Maestro_Rate_Name_L1_Base
PURPOSE: Get the information about reservations

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Res_7_Reservation_Summary_By_Maestro_Rate_Name_L2_main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_7_Reservation_Summary_By_Maestro_Rate_Name_L1_Base]
AS
SELECT DISTINCT 
    	Reservation.Confirmation_Number, Owning_Company.Name, 
    	Location.Location, CONVERT(datetime, CONVERT(varchar(20), 
    			DATENAME(day, Reservation.Pick_Up_On) 
    			+ ' ' + DATENAME(month, Reservation.Pick_Up_On) 
    			+ ' ' + DATENAME(Year, Reservation.Pick_Up_On))) AS Day, 
    	Vehicle_Class.Vehicle_Class_Name,
	Reservation.Status, 
    	Quoted_Vehicle_Rate.Rate_Name, 
    	Vehicle_Class.Vehicle_Type_ID, 
    	Reservation.Pick_Up_Location_ID, 
    	Location.Owning_Company_ID, 
    	Reservation.Vehicle_Class_Code
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
    	Quoted_Vehicle_Rate 
		ON Reservation.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID
WHERE 	(Reservation.Status IN ('N', 'O', 'A')) AND 
    	(Reservation.Source_Code = 'Maestro')













GO
