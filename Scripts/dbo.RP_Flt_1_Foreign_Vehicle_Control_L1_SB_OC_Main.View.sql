USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_1_Foreign_Vehicle_Control_L1_SB_OC_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Flt_1_Foreign_Vehicle_Control_L1_SB_OC_Main
PURPOSE: Get the information about vehicles

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Subreport in the Foreign Vehicle Control (by Owning Company) Report
    	 to create tabel with the location totals at the end of report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/
CREATE VIEW [dbo].[RP_Flt_1_Foreign_Vehicle_Control_L1_SB_OC_Main]
AS
SELECT 	Vehicle.Unit_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number, 
	Vehicle.Owning_Company_ID, 
	Vehicle.Current_Rental_Status, 
    	Vehicle.Current_Condition_Status,
    	Owning_Company.Name AS Vehicle_Owning_Company_Name,
    	Vehicle_Class.Vehicle_Type_ID
FROM 	Vehicle  WITH(NOLOCK)
	INNER JOIN
	Lookup_Table
		ON Vehicle.Owning_Company_ID <> Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER JOIN
    	Vehicle_On_Contract
		ON Vehicle.Unit_Number = Vehicle_On_Contract.Unit_Number 
   	 INNER JOIN 	
	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID
    	INNER JOIN
    	Vehicle_Class 
		ON Vehicle_Class.Vehicle_Class_Code = Vehicle.Vehicle_Class_Code
	INNER JOIN 
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Lookup_Table Lookup_Table_1
		ON Location.Owning_Company_ID = Lookup_Table_1.Code
		AND Lookup_Table_1.Category = 'BudgetBC Company'
WHERE 	(Vehicle.Current_Rental_Status = 'b') 
	AND 
    	(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'd' OR
     	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k') AND 
    	(Vehicle_On_Contract.Checked_Out =	(SELECT MAX(Checked_Out)
				    	 FROM Vehicle_On_Contract voc
    					 WHERE voc.Unit_Number = Vehicle_On_Contract.Unit_Number))
	AND (Vehicle_On_Contract.Actual_Check_In IS NULL)
	AND Vehicle.Deleted = 0

UNION ALL
SELECT 	Vehicle.Unit_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number, 
    	Vehicle.Owning_Company_ID, 
	Vehicle.Current_Rental_Status, 
    	Vehicle.Current_Condition_Status,
    	Owning_Company.Name AS Vehicle_Owning_Company_Name,
    	Vehicle_Class.Vehicle_Type_ID
FROM 	Vehicle 
	INNER JOIN
	Lookup_Table
		ON Vehicle.Owning_Company_ID <> Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER JOIN
    	Vehicle_Movement 
		ON Vehicle.Unit_Number = Vehicle_Movement.Unit_Number
    	INNER JOIN 
	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID
    	INNER JOIN
	Vehicle_Class 
		ON Vehicle_Class.Vehicle_Class_Code = Vehicle.Vehicle_Class_Code
	INNER JOIN 
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Lookup_Table Lookup_Table_1
		ON Location.Owning_Company_ID = Lookup_Table_1.Code
		AND Lookup_Table_1.Category = 'BudgetBC Company'
WHERE	(Vehicle.Current_Rental_Status = 'c') AND 
    	(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'd' OR
    	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k') AND 
    	(Vehicle_Movement.Movement_Out = (SELECT MAX(Movement_Out)
					  FROM Vehicle_Movement vom
					  WHERE vom.Unit_Number = Vehicle_Movement.Unit_Number))
     	AND (Vehicle_Movement.Movement_In IS NULL)
	AND Vehicle.Deleted = 0

UNION ALL
SELECT 	Unit_Number, 
	Foreign_Vehicle_Unit_Number, 
    	Vehicle.Owning_Company_ID, 
	Current_Rental_Status, 
    	Current_Condition_Status,
    	Owning_Company.Name Vehicle_Owning_Company_Name,
    	Vehicle_Class.Vehicle_Type_ID
FROM 	Vehicle
	INNER JOIN
	Lookup_Table
		ON Vehicle.Owning_Company_ID <> Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
    	INNER JOIN 
	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID
	INNER JOIN
    	Vehicle_Class 
		ON Vehicle_Class.Vehicle_Class_Code = Vehicle.Vehicle_Class_Code
	INNER JOIN 
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Lookup_Table Lookup_Table_1
		ON Location.Owning_Company_ID = Lookup_Table_1.Code
		AND Lookup_Table_1.Category = 'BudgetBC Company'
WHERE 	(Current_Rental_Status = 'a') AND 
    	(Current_Vehicle_Status = 'b' OR
    	Current_Vehicle_Status = 'd' OR
    	Current_Vehicle_Status = 'f' OR
    	Current_Vehicle_Status = 'j' OR
    	Current_Vehicle_Status = 'k')
	AND Vehicle.Deleted = 0




















GO
