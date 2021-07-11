USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
VIEW NAME: RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base
PURPOSE: Get the information about vehicles and their turn back times

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/

CREATE VIEW [dbo].[RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base]
AS
SELECT 	Vehicle.Turn_Back_Deadline, 
	dbo.UpdatedVehicleISD(Vehicle.Unit_Number)  AS Acquired_Date, 
	Vehicle.Unit_Number,
	Vehicle.Program,
	Vehicle.Current_Licence_Plate, 
       	Vehicle.Current_Km, 
    	DATEDIFF(Day, dbo.UpdatedVehicleISD(Vehicle.Unit_Number), GETDATE()) AS Day_In_Service,
    	DATEDIFF(Month, dbo.UpdatedVehicleISD(Vehicle.Unit_Number), GETDATE()) AS Month_In_Service, 
    	Vehicle.Maximum_Km,
	Vehicle_On_Contract.Contract_Number, 
    	Vehicle_On_Contract.Expected_Check_In, 
    	Vehicle.Current_Rental_Status, 
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID, 
    	Vehicle.Vehicle_Model_ID,
	Vehicle.Vehicle_Class_Code
FROM 	Vehicle_On_Contract WITH(NOLOCK)
	INNER JOIN
    	Vehicle
		ON Vehicle.Unit_Number = Vehicle_On_Contract.Unit_Number
		AND (Vehicle.Current_Rental_Status = 'b') /* vehicle on rent */
     	INNER JOIN
    	Lookup_Table 
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
WHERE 	
	(Vehicle_On_Contract.Checked_Out =	(SELECT MAX(Checked_Out)
						 FROM Vehicle_On_Contract voc
					        	 WHERE voc.Unit_Number = Vehicle_On_Contract.Unit_Number))
        	AND (Vehicle_On_Contract.Actual_Check_In IS NULL)
        	AND (Vehicle.Current_Vehicle_Status = 'b'
          		OR Vehicle.Current_Vehicle_Status = 'c'
   	  		OR Vehicle.Current_Vehicle_Status = 'd'
	  	  --	OR Vehicle.Current_Vehicle_Status = 'f'
 	  		--OR Vehicle.Current_Vehicle_Status = 'g'
          		OR Vehicle.Current_Vehicle_Status = 'j'
	  		OR Vehicle.Current_Vehicle_Status = 'k'
          		OR Vehicle.Current_Vehicle_Status = 'l')
    	--AND (Vehicle.Program = 1)
	AND (Lookup_Table.Category = 'BudgetBC Company')
	AND Vehicle.Deleted = 0

UNION ALL
SELECT 	Vehicle.Turn_Back_Deadline, 
	Vehicle.Ownership_Date AS Acquired_Date, 
    	Vehicle.Unit_Number, 
    	Vehicle.Program,
    	Vehicle.Current_Licence_Plate, 
    	Vehicle.Current_Km, 
    	DATEDIFF(Day, Vehicle.Ownership_Date, GETDATE()) AS Day_In_Service, 
    	DATEDIFF(Month, Vehicle.Ownership_Date, GETDATE()) AS Month_In_Service, 
    	Vehicle.Maximum_Km, 
    	NULL AS Contract_number, 
    	NULL AS Due_Back_Date,
    	Vehicle.Current_Rental_Status, 
    	Vehicle_Movement.Receiving_Location_ID, 
    	Vehicle.Vehicle_Model_ID, 
	Vehicle.Vehicle_Class_Code
FROM 	Vehicle_Movement 
	INNER JOIN
    	Vehicle
		ON Vehicle.Unit_Number = Vehicle_Movement.Unit_Number
		AND (Vehicle.Current_Rental_Status = 'c') /* vehicle in transit */
     	INNER JOIN
    	Lookup_Table 
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
WHERE 	 (Vehicle.Current_Vehicle_Status = 'b'
        	OR Vehicle.Current_Vehicle_Status = 'c'
        	OR Vehicle.Current_Vehicle_Status = 'd'
		--OR Vehicle.Current_Vehicle_Status = 'f'
  --		OR Vehicle.Current_Vehicle_Status = 'g'
		OR Vehicle.Current_Vehicle_Status = 'j'
		OR Vehicle.Current_Vehicle_Status = 'k'
		OR Vehicle.Current_Vehicle_Status = 'l')
       	AND (Vehicle_Movement.Movement_In IS NULL)
        AND Vehicle_Movement.Movement_Out = (SELECT MAX(movement_out)
				            FROM vehicle_movement vom
				            WHERE vom.unit_Number = vehicle_movement.unit_Number)
	--AND (Vehicle.Program = 1)
	AND (Lookup_Table.Category = 'BudgetBC Company')
	AND Vehicle.Deleted = 0

UNION ALL
SELECT 	Turn_Back_Deadline, 
	Ownership_Date AS Acquired_Date, 
    	Unit_Number,
    	Vehicle.Program,
	Current_Licence_Plate,
	Current_Km, 
    	DATEDIFF(Day, Ownership_Date, GETDATE()) AS Day_In_Service,
	DATEDIFF(Month, Ownership_Date, GETDATE()) AS Month_In_Service,
	Maximum_Km,
	NULL AS Contract_Number,
	NULL AS Expected_Check_In, 
    	Current_Rental_Status,
	Current_Location_ID, 
    	Vehicle_Model_ID,
	Vehicle_Class_Code
FROM 	Vehicle
     	INNER JOIN
    	Lookup_Table 
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
WHERE 	(Current_Rental_Status = 'a' /* vehicle available */
		OR  Current_Rental_Status IS NULL) 
	 AND (Current_Vehicle_Status = 'b'
	   	OR Current_Vehicle_Status = 'c'
	   	OR Current_Vehicle_Status = 'd'
		--OR Current_Vehicle_Status = 'f'
  --      	OR Current_Vehicle_Status = 'g'
        	OR Current_Vehicle_Status = 'j'

        	OR Current_Vehicle_Status = 'k'
        	OR Current_Vehicle_Status = 'l')
    	 --AND (Vehicle.Program = 1)
	 AND (Lookup_Table.Category = 'BudgetBC Company')
	 AND Vehicle.Deleted = 0



























GO
