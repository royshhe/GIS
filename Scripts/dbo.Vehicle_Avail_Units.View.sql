USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Avail_Units]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: Isolate the fields that are used in to retrieve a unit using the 'Get Vehicle' button
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 6 2000	Added Current_Licencing_prov_State and Displayed_Unit_Number 
*/
CREATE VIEW [dbo].[Vehicle_Avail_Units] AS
/* 3/12/99 - cpy modified - return condition status desc instead of code */

	SELECT	V.Unit_Number, 
		V.Foreign_Vehicle_Unit_Number, 
		V.Current_Licence_Plate, 
		VMY.Model_Name,	
		VMY.Model_Year, 
		V.Exterior_Colour, 
		V.Current_Km, 
		V.Smoking_Flag, OC.Name, 
		OC.Owning_Company_ID, 
		V.Current_Location_ID, 
		VC.Vehicle_Type_ID, 
		VC.Vehicle_Class_Code, 
		V.Program, 
		V.Maximum_Rental_Period,
		LT.Value as Current_Condition_Status, -- V.Current_Condition_Status, 
		V.Do_Not_Rent_Past_Km, 
		V.Ownership_Date, 
		V.Do_Not_Rent_Past_Days, 
		V.Turn_Back_Deadline, 
		V.Next_Scheduled_Maintenance,
		V.Current_Rental_Status, 
		VMY.Foreign_Model_Only, 
		VMY.Manufacturer_ID, 
		V.Current_Licencing_Prov_State,
		ISNULL(V.Foreign_Vehicle_Unit_Number, V.Unit_Number) as Displayed_Unit_Number,
		vmy.Addendum
	FROM	Lookup_Table LT,
		Owning_Company OC,
		Vehicle_Model_Year VMY,
		Vehicle_Class VC,
		Vehicle V
                          WITH(NOLOCK)
	WHERE	V.Owning_Company_ID = OC.Owning_Company_ID
	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	AND	V.Vehicle_Class_Code = VC.Vehicle_Class_Code
	AND	V.Current_Condition_Status = LT.Code
	AND	LT.Category = 'Vehicle Condition Status'
	AND	V.Current_Vehicle_Status = 'd'
	AND	V.Current_Rental_Status IN ('a','b','c')
	AND	V.Current_Condition_Status IN ('a','d','f','h','j')
	AND	V.Deleted = 0
GO
