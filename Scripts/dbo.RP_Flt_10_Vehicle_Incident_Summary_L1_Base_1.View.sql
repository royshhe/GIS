USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L1_Base_1]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_10_Vehicle_Incident_Summary_L1_Base_1
PURPOSE: Find vehicle's current location

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Flt_10_Vehicle_Incident_Summary_L2_Main
MOD HISTORY:
Name 		Date		Comments
Vivian Leung	09 Nov 2001	Included vehicles with NULL rental status
*/

CREATE VIEW [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L1_Base_1]
AS
-- vehicle on contract
SELECT Vehicle.Unit_Number, 
    	Location.Location AS Current_Location_Name
FROM 	Vehicle  WITH(NOLOCK)
	INNER JOIN
    	Vehicle_On_Contract 
		ON Vehicle.Unit_Number = Vehicle_On_Contract.Unit_Number 
	INNER JOIN
    	Location 
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID  /* expected check in location */
WHERE 	
	(Vehicle.Current_Rental_Status = 'b') AND 
    	/*(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'd' OR
    	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k') AND */
    	(Vehicle_On_Contract.Checked_Out = (SELECT MAX(Checked_Out)
					  FROM Vehicle_On_Contract voc
      					  WHERE voc.Unit_Number = Vehicle_On_Contract.Unit_Number))
     	AND (Vehicle_On_Contract.Actual_Check_In IS NULL)
UNION ALL

-- vehicle in transit
SELECT
 	Vehicle.Unit_Number, 
    	Location.Location AS Current_Location_Name
FROM 	Vehicle 
	INNER JOIN
    	Vehicle_Movement 
		ON Vehicle.Unit_Number = Vehicle_Movement.Unit_Number 
	INNER JOIN
    	Location 
		ON Vehicle_Movement.Receiving_Location_ID = Location.Location_ID  /* location vehicle is being moved to */
WHERE 	
	(Vehicle.Current_Rental_Status = 'c') AND 
    	/*(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'd' OR
    	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k') AND */
    	(Vehicle_Movement.Movement_Out = (SELECT MAX(Movement_Out)
     					  FROM Vehicle_Movement vom
      					  WHERE vom.Unit_Number = Vehicle_Movement.Unit_Number))
   	AND (Vehicle_Movement.Movement_In IS NULL)
UNION ALL

-- vehicle available
SELECT 	
	Unit_Number, 
    	Location.Location AS Current_Location_Name 
FROM 	Vehicle 
	INNER JOIN
    	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID 
WHERE 	
	(Current_Rental_Status = 'a' or
	Current_Rental_Status is NULL)/* AND 
    	(Current_Vehicle_Status = 'b' OR
    	Current_Vehicle_Status = 'd' OR
    	Current_Vehicle_Status = 'f' OR
   	Current_Vehicle_Status = 'j' OR
	Current_Vehicle_Status = 'k')*/



















GO
