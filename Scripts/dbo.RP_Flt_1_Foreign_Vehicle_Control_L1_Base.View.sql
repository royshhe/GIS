USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_1_Foreign_Vehicle_Control_L1_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_1_Foreign_Vehicle_Control_L1_Base
PURPOSE: Get the information about vehicles

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Flt_1_Foreign_Vehicle_Control_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/
CREATE VIEW [dbo].[RP_Flt_1_Foreign_Vehicle_Control_L1_Base]
AS
SELECT 	Vehicle.Unit_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number, 
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
    	Vehicle.Current_Licence_Plate,
	Vehicle.Vehicle_Model_ID, 
    	Vehicle.Vehicle_Class_Code, 
	Vehicle.Current_Km, 
    	Vehicle_On_Contract.Checked_Out	AS Date_Out, 
    	Vehicle_On_Contract.Expected_Check_In AS Expected_Date_In, 
    	Vehicle.Current_Location_ID AS Available_Location_ID, 
    	CONVERT(varchar(25), Vehicle_On_Contract.Contract_Number) AS MTCN, 
    	Contract.Last_Name + ' ' + Contract.First_Name AS Customer_Name,
     	Vehicle.Current_Rental_Status, 
    	Vehicle.Current_Condition_Status, 
    	NULL 	AS Idle_Days
FROM	Vehicle WITH(NOLOCK)
	INNER JOIN 
	Lookup_Table Lookup_Table1
		ON Vehicle.Owning_Company_ID <> Lookup_Table1.Code
		AND (Lookup_Table1.Category = 'BudgetBC Company') --not include BRAC BC
	INNER JOIN
    	Vehicle_On_Contract
		ON Vehicle.Unit_Number = Vehicle_On_Contract.Unit_Number
	INNER JOIN
    	Contract 
		ON Vehicle_On_Contract.Contract_Number = Contract.Contract_Number
WHERE 	
    	(Vehicle_On_Contract.Actual_Check_In IS NULL) 
	AND (Vehicle_On_Contract.Checked_Out = (SELECT MAX(Checked_Out)
      					             FROM Vehicle_On_Contract 	AS voc
					             WHERE voc.Unit_Number = Vehicle_On_Contract.Unit_Number))  
	AND (Vehicle.Current_Rental_Status = 'b') /* vehicle on rent */
	AND (Vehicle.Current_Vehicle_Status = 'b' 
	            OR Vehicle.Current_Vehicle_Status = 'd' 
	            OR Vehicle.Current_Vehicle_Status = 'f' 
	            OR Vehicle.Current_Vehicle_Status = 'j' 
	            OR Vehicle.Current_Vehicle_Status = 'k')
	AND Vehicle.Deleted = 0

UNION ALL
SELECT 	Unit_Number, 
	Foreign_Vehicle_Unit_Number, 
    	Owning_Company_ID,
	Current_Licence_Plate, 
    	Vehicle_Model_ID, 
	Vehicle_Class_Code, 
	Current_Km,
	NULL AS Date_Out, 
	NULL AS Date_In, 
    	Current_Location_ID AS Available_Location_ID, 
	NULL AS MTCN, 
	NULL AS Customer_Name,
	Current_Rental_Status, 
    	Current_Condition_Status, 
	DATEDIFF(DAY,  Vehicle.Rental_Status_Effective_On, GETDATE()) AS Idle_Days
FROM 	Vehicle
	INNER JOIN 
	Lookup_Table Lookup_Table1
		ON Vehicle.Owning_Company_ID <> Lookup_Table1.Code
		AND (Lookup_Table1.Category = 'BudgetBC Company') --not include BRAC BC
WHERE 	(Current_Rental_Status = 'a') AND /* vehicle available */
    	(Current_Vehicle_Status = 'b' OR
    	 Current_Vehicle_Status = 'd' OR
    	 Current_Vehicle_Status = 'f' OR
    	 Current_Vehicle_Status = 'j' OR
    	 Current_Vehicle_Status = 'k')
	AND Vehicle.Deleted = 0

UNION ALL
SELECT  Vehicle.Unit_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number, 
    	Vehicle.Owning_Company_ID, 
	Vehicle.Current_Licence_Plate, 
    	Vehicle.Vehicle_Model_ID, 
	Vehicle.Vehicle_Class_Code, 
    	Vehicle.Current_Km, 
    	Vehicle_Movement.Movement_Out AS Date_Out, 
	NULL AS Date_In, 
	Vehicle.Current_Location_ID AS Available_Location_ID, 
    	Lookup_Table.Value AS MTCN, 
	NULL AS Customer_Name, 
	Vehicle.Current_Rental_Status, 
    	Vehicle.Current_Condition_Status, 
	DATEDIFF(DAY, Vehicle.Rental_Status_Effective_On, GETDATE()) AS Idle_Days
FROM 	Vehicle 
	INNER JOIN
    	Vehicle_Movement 
		ON     Vehicle.Unit_Number = Vehicle_Movement.Unit_Number
	INNER JOIN
	Lookup_Table
		ON Vehicle.Current_Condition_Status = Lookup_Table.Code 
		AND Lookup_Table.Category = 'Vehicle Condition Status'
	INNER JOIN 
	Lookup_Table Lookup_Table1
		ON Vehicle.Owning_Company_ID <> Lookup_Table1.Code
		AND (Lookup_Table1.Category = 'BudgetBC Company') --not include BRAC BC
WHERE   (Vehicle_Movement.Movement_Out =  (SELECT MAX(Movement_Out)
					  FROM Vehicle_Movement AS vm
    					  WHERE vm.unit_number = vehicle_movement.unit_number)) 
	AND (Vehicle_Movement.Movement_In IS NULL) 
	AND (Vehicle.Current_Rental_Status = 'c') /* vehicle in transit */
	AND (Vehicle.Current_Vehicle_Status = 'b'
	 OR  Vehicle.Current_Vehicle_Status = 'd'
	 OR  Vehicle.Current_Vehicle_Status = 'f'
	 OR  Vehicle.Current_Vehicle_Status = 'j'
	 OR  Vehicle.Current_Vehicle_Status = 'k') 
	AND Vehicle.Deleted = 0	
































GO
