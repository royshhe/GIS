USE [GISData]
GO
/****** Object:  View [dbo].[RP_Adhoc_vehicle_at_foreign_location]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE VIEW [dbo].[RP_Adhoc_vehicle_at_foreign_location]
AS
SELECT  dbo.Vehicle.Unit_Number,
	dbo.Vehicle.MVA_Number, 
	dbo.Vehicle.Foreign_Vehicle_Unit_Number, 
	dbo.Vehicle_Model_Year.Model_Name, 
	dbo.Vehicle_Model_Year.Model_Year,
        dbo.Vehicle_Class.Vehicle_Type_ID, 
	dbo.Vehicle_Class.Vehicle_Class_Code, 
	dbo.Vehicle_Class.Vehicle_Class_Name, 
	dbo.Vehicle.Exterior_Colour, 
        dbo.Vehicle.Interior_Colour, 
	dbo.Vehicle.Current_Licence_Plate, 
	dbo.Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
        dbo.Owning_Company.Name AS Vehicle_Owning_Company_Name, 
	lt2.[Value] AS Vehicle_Rental_Status, 
	lt3.[Value] AS Vehicle_Condition_Status, 
        vm.Last_Move_Time AS Available_Since, 
	DATEDIFF(Day, vm.Last_Move_Time, GETDATE()) AS Idle_Days, 
        dbo.Location.Location AS Vehicle_Location_Name, 
	dbo.Vehicle.Current_Location_ID AS Vehicle_Location_ID,
	OC.Owning_Company_ID AS Foreign_Company_ID, 
	OC.Name as Foreign_Company_Name,
	dbo.Vehicle.Current_Km, 
        dbo.Vehicle.Do_Not_Rent_Past_Km, 
	dbo.Vehicle.Ownership_Date, 
	dbo.Vehicle.Do_Not_Rent_Past_Days, 
	0 AS Foreign_OC
FROM         dbo.Vehicle WITH (NOLOCK) INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Lookup_Table ON dbo.Vehicle.Owning_Company_ID = dbo.Lookup_Table.Code AND 
                      dbo.Lookup_Table.Category = 'BudgetBC Company' INNER JOIN
                      dbo.Owning_Company ON dbo.Vehicle.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID INNER Join
	              dbo.Owning_Company OC ON dbo.location.Owning_Company_ID = OC.Owning_Company_ID	INNER join 
			(SELECT MAX(VM1.Date_In) AS Last_Move_Time, VM1.Unit_Number As Unit_number FROM
					(SELECT     Movement_In as Date_in, Unit_Number
						FROM         dbo.Vehicle_Movement
		 			   UNION
		 			 SELECT Actual_Check_In as Date_in, Unit_Number
						FROM	 vehicle_on_contract) VM1 Group By VM1.Unit_Number) VM
				ON vehicle.unit_number=vm.unit_number LEFT OUTER JOIN
                      dbo.Lookup_Table lt2 ON dbo.Vehicle.Current_Rental_Status = lt2.Code AND lt2.Category = 'vehicle rental status' LEFT OUTER JOIN
                      dbo.Lookup_Table lt3 ON dbo.Vehicle.Current_Condition_Status = lt3.Code AND lt3.Category = 'vehicle condition status'
WHERE     (dbo.Vehicle.Current_Rental_Status = 'a' OR
                      dbo.Vehicle.Current_Rental_Status = 'c') AND (dbo.Vehicle.Current_Vehicle_Status = 'b' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'c' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'd' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'f' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'j' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'k') AND (dbo.Vehicle.Deleted = 0) AND (dbo.Vehicle.Current_Location_ID NOT IN
                          (SELECT     dbo.Location.Location_ID
                            FROM          dbo.Location INNER JOIN
                                                   dbo.Lookup_Table ON dbo.Location.Owning_Company_ID = dbo.Lookup_Table.Code AND 
                                                   dbo.Lookup_Table.Category = 'BudgetBC Company'))






GO
