USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_SR_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
VIEW NAME: RP_Flt_6_Units_Available_For_Rent_L1_SR_Base
PURPOSE: Get the information about vehicles for Location and Company subreports

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/01/01
USED BY: Stored Procedure RP_SP_Flt_6_Units_Available_For_Rent_SR
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_SR_Base]
AS

-- select BRAC vehicles for all locations (BRAC and foreign)
SELECT 	Vehicle.Unit_Number, 
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Code, 
    	Vehicle_Class.Vehicle_Class_Name, 
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
    	Owning_Company.Name AS Vehicle_Owning_Company_Name, 
    	DATEDIFF(Day, Vehicle.Rental_Status_Effective_On, GETDATE()) AS Idle_Days,
 	Location.Location AS Vehicle_Location_Name, 
    	Vehicle.Current_Location_ID AS Vehicle_Location_ID,
    	Vehicle.Current_Km, 
    	Vehicle.Do_Not_Rent_Past_Km, 
    	Vehicle.Ownership_Date,
    	Vehicle.Do_Not_Rent_Past_Days

FROM 	Vehicle  WITH(NOLOCK)
	INNER JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     	INNER JOIN
    	Vehicle_Class 
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID 	
	INNER 
	JOIN
    	Lookup_Table 
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN
	Owning_Company 
		ON Vehicle.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	LEFT OUTER JOIN
    	Lookup_Table lt2
		ON Vehicle.Current_Rental_Status = lt2.Code 	
		AND (lt2.Category = 'vehicle rental status') 
	LEFT OUTER JOIN
    	Lookup_Table lt3
		ON Vehicle.Current_Condition_Status = lt3.Code
		AND (lt3.Category = 'vehicle condition status') 
WHERE 	(Vehicle.Current_Rental_Status = 'a' OR
    	Vehicle.Current_Rental_Status = 'c')	
	AND 
   	(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'c' OR
	Vehicle.Current_Vehicle_Status = 'd' OR
    	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k')
	AND
	Vehicle.Deleted = 0

UNION ALL

-- select Foreign vehicles for BRAC locations only
SELECT 	Vehicle.Unit_Number, 
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Code, 
    	Vehicle_Class.Vehicle_Class_Name, 
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
    	Owning_Company.Name AS Vehicle_Owning_Company_Name, 
    	DATEDIFF(Day, Vehicle.Rental_Status_Effective_On, GETDATE()) AS Idle_Days,
 	Location.Location AS Vehicle_Location_Name, 
    	Vehicle.Current_Location_ID AS Vehicle_Location_ID,
    	Vehicle.Current_Km, 
    	Vehicle.Do_Not_Rent_Past_Km, 
    	Vehicle.Ownership_Date,
    	Vehicle.Do_Not_Rent_Past_Days

FROM 	Vehicle 
	INNER JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     	INNER JOIN
    	Vehicle_Class 
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location 
		ON Vehicle.Current_Location_ID = Location.Location_ID 	
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER
	JOIN
	Lookup_Table lt1
		ON Vehicle.Owning_Company_ID <> lt1.Code
		AND lt1.Category = 'BudgetBC Company'
	INNER JOIN
	Owning_Company 
		ON Vehicle.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	LEFT OUTER JOIN
    	Lookup_Table lt2
		ON Vehicle.Current_Rental_Status = lt2.Code 	
		AND (lt2.Category = 'vehicle rental status') 
	LEFT OUTER JOIN
    	Lookup_Table lt3
		ON Vehicle.Current_Condition_Status = lt3.Code
		AND (lt3.Category = 'vehicle condition status') 
WHERE 	(Vehicle.Current_Rental_Status = 'a' OR
    	Vehicle.Current_Rental_Status = 'c')	
	AND 
   	(Vehicle.Current_Vehicle_Status = 'b' OR
    	Vehicle.Current_Vehicle_Status = 'c' OR
	Vehicle.Current_Vehicle_Status = 'd' OR
    	Vehicle.Current_Vehicle_Status = 'f' OR
    	Vehicle.Current_Vehicle_Status = 'j' OR
    	Vehicle.Current_Vehicle_Status = 'k')
	AND
	Vehicle.Deleted = 0















GO
