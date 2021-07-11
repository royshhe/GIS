USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_6_Reservation_Prebooked_By_GIS_Rate_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: 	RP_Res_6_Reservation_Prebooked_By_GIS_Rate_L1_Base
PURPOSE: 	To retrieve the reservation records and calculate the number of days booked
	 	before pick up for each reservation for GIS rates by rate level.
	 	
AUTHOR: 	Joseph Tseung
DATE CREATED:Dec 17, 1998
USED BY: 	Stored Procedure RP_SP_Res_6_Reservation_Prebooked_By_GIS_Rate
MOD HISTORY:
Name    		Date        	Comments
Joseph Tseung	Jan 13, 1999	Add Company ID, Location ID, Vehicle Class Name and Rate Level
Joseph T	Sep 23, 1999     Change View Name
*/

CREATE VIEW [dbo].[RP_Res_6_Reservation_Prebooked_By_GIS_Rate_L1_Base] 
AS
SELECT 	
	DISTINCT Reservation.Confirmation_Number,                       -- primary key for reservations
	Reservation.Status,               					-- status of reservation
	Reservation.Pick_up_on,					 	-- date vehicle is claimed to pick up
	MIN(Reservation_Change_History.Changed_On) AS Created_On,	-- date the reservation is created
	DATEDIFF(dd, MIN(Reservation_Change_History.Changed_On), Reservation.Pick_up_on) AS NumDaysBeforePU,  -- Number of days booked before pick up date
	Reservation.Source_Code, 					-- source of reservation
	Vehicle_Class.Vehicle_Type_ID,					-- vehicle type
	Owning_Company.Owning_Company_ID, 				-- company ID
	Owning_Company.Name AS Company_Name, 				-- company description
	Location.Location_ID AS Location_ID, 				-- location ID 
	Location.Location AS Location_Name, 				-- location name
	Reservation.Vehicle_Class_Code,					-- vehicle class id
	Vehicle_Class.Vehicle_Class_Name,				-- vehicle class name
	Vehicle_Rate.Rate_Name,						-- vehicle rate name
	Reservation.Rate_Level						-- vehicle rate level
FROM 	Location WITH(NOLOCK)	
	INNER JOIN 	
	Reservation 			
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Location.Rental_Location = 1	-- location has to be rental location
	INNER JOIN 	
	Vehicle_Rate			
		ON Reservation.Rate_ID = Vehicle_Rate.Rate_ID
		AND Reservation.Date_Rate_Assigned >= Vehicle_Rate.Effective_Date
		AND Reservation.Date_Rate_Assigned <= Vehicle_Rate.Termination_Date
	INNER JOIN	
	Vehicle_Class			
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN 	
	Reservation_Change_History 	
		ON Reservation_Change_History.Confirmation_Number = Reservation.Confirmation_Number
	INNER JOIN	
	Owning_Company			
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID 
GROUP BY 	
	Reservation.Confirmation_Number,
	Reservation.Status,
	Reservation.Pick_up_on,
	Reservation.Source_Code, 
	Vehicle_Class.Vehicle_Type_ID, 
	Owning_Company.Owning_Company_ID, 
	Owning_Company.Name, 
	Location.Location_ID, 
	Location.Location, 
	Reservation.Vehicle_Class_Code, 
	Vehicle_Class.Vehicle_Class_Name,
	Vehicle_Rate.Rate_Name, 
	Reservation.Rate_Level
HAVING
	(Reservation.Status IN ('N', 'O', 'A'))














GO
