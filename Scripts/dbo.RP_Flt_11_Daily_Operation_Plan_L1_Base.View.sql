USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_11_Daily_Operation_Plan_L1_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Flt_11_Daily_Operation_Plan_L1_Base
PURPOSE: Get the current information about vehicles for BRAC locations

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: View RP_Flt_11_Daily_Operation_Plan_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/07	Add filtering to select BRAC locations
Joseph Tseung	1999/11/10	Exclude foreign vehicle units under Available Vehicles 
				and Due and Overdue Vehicle sections
Joseph Tseung	1999/11/19	Select contract with status = check out for Due and Overdue counts
Joseph Tseung	1999/11/23	Include overdue from previous days in Due count
Joseph Tseung	1999/11/25 	Exclude the vehicle support check in contract in the due count
				by making sure the actual check in time for the last VOC record is null
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/

CREATE VIEW [dbo].[RP_Flt_11_Daily_Operation_Plan_L1_Base]
AS
-- available vehicles
SELECT 	
	Vehicle.Unit_Number AS ID, 
	Vehicle.Current_Location_ID AS Location_ID, 
	Vehicle.Vehicle_Class_Code AS Vehicle_Class_Code,
      	Status = CASE 
		WHEN Vehicle.Current_Condition_Status IN ('a', 'd', 'f', 'h', 'j') THEN 
			'AR' 	-- available rentable
		ELSE 
			'ANR'	-- available not rentable
	END,
	-1 AS Hours_Overdue,
	Location.Rental_Location
FROM 	Vehicle WITH(NOLOCK)
	INNER
	JOIN
	Location
		ON Vehicle.Current_Location_ID = Location.Location_ID
		AND Vehicle.Foreign_Vehicle_Unit_Number IS NULL
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
WHERE 	(Current_Vehicle_Status = 'd') 
	AND 
   	(Current_Rental_Status IN ('a', 'c'))
	AND 
	Vehicle.Deleted = 0


UNION ALL
-- reservations
SELECT 	
	Reservation.Confirmation_Number AS ID, 
	Reservation.Pick_Up_Location_ID AS Location_ID, 
   	Reservation.Vehicle_Class_Code AS Vehicle_Class_Code,
	'R' AS Status,
	-1 AS Hours_Overdue,
	Location.Rental_Location
FROM 	Reservation
	INNER
	JOIN
	Location
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
WHERE 	Status =  'A'
	AND
	(DATEDIFF(DD, Pick_Up_On, GETDATE()) = 0)

UNION ALL

-- Overdue Vehicles from previous days
SELECT 	
	Vehicle_On_Contract.Contract_Number AS ID, 
   	Vehicle_On_Contract.Expected_Drop_Off_Location_ID  AS Location_ID, 
	Vehicle.Vehicle_Class_Code,
	'D' AS Status,
   	-1 AS Hours_Overdue,
	Location.Rental_Location   	

FROM 	Contract
	INNER
	JOIN
	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
	INNER 
	JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
		AND Vehicle.Foreign_Vehicle_Unit_Number IS NULL
	INNER
	JOIN
	Location
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 

WHERE 	(Contract.Status = 'CO')
	AND 
	Vehicle_On_Contract.Actual_Check_In IS NULL -- last vehicle on contract
	AND 
	(DATEDIFF(dd, GETDATE(), Vehicle_On_Contract.Expected_Check_In) < 0)
	AND 
	Vehicle.Deleted = 0

UNION ALL
-- Due and Overdue Vehicles for today only
SELECT 	
	Vehicle_On_Contract.Contract_Number AS ID, 
   	Vehicle_On_Contract.Expected_Drop_Off_Location_ID  AS Location_ID, 
	Vehicle.Vehicle_Class_Code,
	'D' AS Status,
   	ROUND(DATEDIFF(mi, Vehicle_On_Contract.Expected_Check_In, GETDATE()) / 60.0, 2) AS Hours_Overdue,
	Location.Rental_Location   	

FROM 	Contract
	INNER
	JOIN
	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
	INNER 
	JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
		AND Vehicle.Foreign_Vehicle_Unit_Number IS NULL
	INNER
	JOIN
	Location
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 

WHERE 	(Contract.Status = 'CO')	
	AND 
	Vehicle_On_Contract.Actual_Check_In IS NULL -- last vehicle on contract
	AND 
	(DATEDIFF(dd, GETDATE(), Vehicle_On_Contract.Expected_Check_In) = 0)
	AND 
	Vehicle.Deleted = 0

































GO
