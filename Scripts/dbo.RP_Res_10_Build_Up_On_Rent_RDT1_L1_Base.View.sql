USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_RDT1_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME:  	RP_Res_10_Build_Up_On_Rent_RDT1_L1_Base
PURPOSE:    	This view counts number of Reservation Due Today for BRAC (local) and foreign locations
   		(reservations with status of active and drop off date = date of day being counted) in the
		next 45 days

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/02/24	Exclude foreign reservations (reservations picked up at foreign locations)
				in the count
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_RDT1_L1_Base]
AS
SELECT	CONVERT(datetime, CONVERT(varchar(12), Reservation.Drop_Off_On, 112)) AS Rpt_Date, 
	Reservation.Vehicle_Class_Code,
	Reservation.Drop_Off_Location_ID AS Location_ID,
	COUNT(Reservation.Confirmation_Number) AS Cnt

FROM 	Reservation  WITH(NOLOCK)
	JOIN
	Location
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	JOIN
    	Lookup_Table 
		ON Lookup_Table.Code = Location.Owning_Company_ID 
		AND Lookup_Table.Category = 'BudgetBC Company'    		

   		
WHERE 	Reservation.Status = "A" 
	AND DATEDIFF(dd, GETDATE(), Reservation.Drop_Off_On) >= 0 
	AND DATEDIFF(dd, DATEADD(dd, 179, GETDATE()), Reservation.Drop_Off_On) <= 0 

GROUP BY 	
	CONVERT(datetime, CONVERT(varchar(12), Reservation.Drop_Off_On, 112)), 
	Reservation.Vehicle_Class_Code,
	Reservation.Drop_Off_Location_ID



























GO
