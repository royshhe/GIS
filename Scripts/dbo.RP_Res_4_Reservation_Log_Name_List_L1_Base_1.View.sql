USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_4_Reservation_Log_Name_List_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Res_4_Reservation_Log_Name_List_L1_Base_1
PURPOSE: Get the information about reservations

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Res_4_Reservation_Log_Name_List_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_4_Reservation_Log_Name_List_L1_Base_1]
AS
SELECT Location.Owning_Company_ID 			AS Company_ID, 
    	Owning_Company.Name 				AS Company_Name, 
	Reservation.Pick_Up_Location_ID, 
	Location.Location 					AS Pick_Up_Location_Name, 
    	Location1.Location 				AS Drop_Off_Location_Name, 
    	Reservation.Last_Name + ', ' + Reservation.First_Name 	AS Customer_Name,
     	Reservation.Confirmation_Number, 
	Reservation.Foreign_Confirm_Number,
    	Reservation.Contact_Phone_Number 		AS Phone_Number,
	Reservation.Flight_Number
	,
	Reservation.Last_Name, 
    Reservation.First_Name 
FROM 	Reservation WITH(NOLOCK)
	INNER JOIN
    	Location 
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
	INNER JOIN	
	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
		AND Location.Rental_Location = 1 -- location has to be rental location
     	INNER JOIN
    	Location Location1
		ON Location1.Location_ID = Reservation.Drop_Off_Location_ID
    	




























GO
