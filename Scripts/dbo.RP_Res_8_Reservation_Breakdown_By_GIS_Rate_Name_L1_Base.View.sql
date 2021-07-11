USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_8_Reservation_Breakdown_By_GIS_Rate_Name_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: 	RP_Res_8_Reservation_Breakdown_By_GIS_Rate_Name_L1_Base
PURPOSE: 	To retrieve the reservation records for each status for GIS rates. 

AUTHOR: 	Joseph Tseung
DATE CREATED: Dec 10, 1998
USED BY: 	View RP_Res_8_Reservation_Breakdown_By_GIS_Rate_Name_L2_Main 

MOD HISTORY:
Name    		Date        	Comments
Joseph Tseung	Jan 13, 1999	Add Location ID and Rate Level
*/
-- This view is used by "Reservation Breakdown" report.
CREATE VIEW [dbo].[RP_Res_8_Reservation_Breakdown_By_GIS_Rate_Name_L1_Base] 
AS
SELECT 	DISTINCT 	Reservation.Confirmation_Number,	-- primary key for reservations
			Reservation.Status,			-- status of reservation
			Reservation.Pick_up_on,			-- date vehicle is claimed to pick up
			Reservation.Source_Code,		-- source of reservation
			Vehicle_Class.Vehicle_Type_ID,		-- vehicle type
			Location.Location_ID,			-- location ID
			Location.Location AS Location_Name,	-- location name
			Vehicle_Rate.Rate_Name,			-- name of vehicle's rate
			Reservation.Rate_Level
FROM 	Location WITH(NOLOCK)	
	INNER JOIN 	
	Reservation 	
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Location.Rental_Location = 1 		-- location has to be rental location
	INNER JOIN
	Lookup_Table
		ON Lookup_Table.Code = Location.Owning_Company_ID
		AND Lookup_Table.Category = 'BudgetBC Company'	-- location has to be owned by BRAC BC
	INNER JOIN	
	Vehicle_Class	
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN 	
	Vehicle_Rate	
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
WHERE
	Reservation.Status IN ('N', 'O', 'A', 'C')

























GO
