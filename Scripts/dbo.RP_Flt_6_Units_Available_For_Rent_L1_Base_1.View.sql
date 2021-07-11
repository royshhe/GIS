USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Flt_6_Units_Available_For_Rent_L1_Base_1
PURPOSE: Get the information about vehicles

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Flt_6_Units_Available_For_Rent
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/20	Add fields Current_Km, Do_Not_Rent_Past_Km, Ownership_Date, Do_Not_Rent_Past_Days 	
				in order to show warning or restriction level of the vehicle unit on the report
Joseph Tseung	2000/01/21	Exclude deleted vehicles
Joseph Tseung	2000/02/02	Select BRAC vehicles for all locations and Foreign vehicles for BRAC locations only.
Joseph Tseung	2000/02/02	Add Vehicle Type ID field
*/
CREATE VIEW [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_1]

--select * from [RP_Flt_6_Units_Available_For_Rent_L1_Base_1] where unit_number=180001
AS
-- select BRAC vehicles for all locations (BRAC and foreign)
SELECT 	Vehicle.Unit_Number, 
	Vehicle.MVA_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number, 
    	Vehicle_Model_Year.Model_Name, 
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Code, 
    	Vehicle_Class.Vehicle_Class_Name, 
	Vehicle.Exterior_Colour, 
    	Vehicle.Interior_Colour, 
	Vehicle.Current_Licence_Plate, 
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
    	Owning_Company.Name AS Vehicle_Owning_Company_Name, 
    	lt2.Value AS Vehicle_Rental_Status, 
    	lt3.Value AS Vehicle_Condition_Status, 
    	(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    	     Else vm.Last_Move_in
    	End) AS Available_Since, 
    	
    	(Case When DATEDIFF(Day,     	
    						(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    							 Else vm.Last_Move_in
    						End),    	
    						GETDATE()
    				)>=0 
    		   Then  DATEDIFF(Day,     	
    					(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    						 Else vm.Last_Move_in
    					End),    	
    					GETDATE()
    				  ) 
    			Else 0
    	End)AS Idle_Days,
    	
    --DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE()) AS Loc_Idle_Days,
    
		(Case When  DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE())>=0 
    		   Then   DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE())
    			Else 0
    	End)AS Loc_Idle_Days,
    	
    
 	Location.Location AS Vehicle_Location_Name, 
    	Vehicle.Current_Location_ID AS Vehicle_Location_ID,
    	Vehicle.Current_Km, 
    	Vehicle.Do_Not_Rent_Past_Km, 
    	Vehicle.Ownership_Date,
    	Vehicle.Do_Not_Rent_Past_Days,
	0 AS Foreign_OC ,
	location.hub_id as Hub_id

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
	Left join 
	
	-- Last Rent first, if none, last movement
	(SELECT MAX(VM1.Date_In) AS Last_Date_In, Max(Movement_In) as Last_Move_In, VM1.Unit_Number As Unit_number FROM
		(
		
		 SELECT  Null Date_In,   
				 Movement_In , 
				 Unit_Number
		 FROM    dbo.Vehicle_Movement
		 UNION
		 SELECT (Case When Actual_Check_In is not null then Actual_Check_In 
				Else Expected_Check_In 
				End)as Date_in, 
				Null Movement_In, 
				Unit_Number
		 FROM	vehicle_on_contract) VM1 Group By VM1.Unit_Number) VM
		on vehicle.unit_number=vm.unit_number
		
	-- Last Rental or movement, whichever is lastest	
	Left join 	
		
		(SELECT MAX(VM2.Date_In) AS Last_Move_Time, VM2.Unit_Number As Unit_number FROM
		(SELECT     Movement_In as Date_in, Unit_Number
			FROM         dbo.Vehicle_Movement
		 UNION
		 --SELECT Actual_Check_In as Date_in, Unit_Number
			--FROM	 vehicle_on_contract
			
			SELECT (Case When Actual_Check_In is not null then Actual_Check_In 
				Else Expected_Check_In 
				End)as Date_in,	 				
				Unit_Number
			FROM	vehicle_on_contract
		 
			) VM2 Group By VM2.Unit_Number) LocVM		
		on vehicle.unit_number=LocVM.unit_number
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
	Vehicle.MVA_Number,
    	Vehicle.Foreign_Vehicle_Unit_Number, 
    	Vehicle_Model_Year.Model_Name, 
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Code, 
    	Vehicle_Class.Vehicle_Class_Name, 
	Vehicle.Exterior_Colour, 
    	Vehicle.Interior_Colour, 
	Vehicle.Current_Licence_Plate, 
    	Vehicle.Owning_Company_ID AS Vehicle_Owning_Company_ID, 
    	Owning_Company.Name AS Vehicle_Owning_Company_Name, 
    	lt2.Value AS Vehicle_Rental_Status, 
    	lt3.Value AS Vehicle_Condition_Status, 
    	(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    	     Else vm.Last_Move_in
    	End) AS Available_Since, 
    --	DATEDIFF(Day,     	
    --			(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    --				 Else vm.Last_Move_in
    --			End),    	
    --			GETDATE()
    --	) AS Idle_Days,
    --DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE()) AS Loc_Idle_Days,    
    
    
    (Case When DATEDIFF(Day,     	
    						(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    							 Else vm.Last_Move_in
    						End),    	
    						GETDATE()
    				)>=0 
    		   Then  DATEDIFF(Day,     	
    					(Case When vm.Last_Date_In is not null Then vm.Last_Date_In
    						 Else vm.Last_Move_in
    					End),    	
    					GETDATE()
    				  ) 
    			Else 0
       End)AS Idle_Days,
    	
    --DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE()) AS Loc_Idle_Days,
    
	  (Case When  DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE())>=0 
    		   Then   DATEDIFF(Day, LocVM.Last_Move_Time, GETDATE())
    			Else 0
      End)AS Loc_Idle_Days,
    		
 	Location.Location AS Vehicle_Location_Name, 
    	Vehicle.Current_Location_ID AS Vehicle_Location_ID,
    	Vehicle.Current_Km, 
    	Vehicle.Do_Not_Rent_Past_Km, 
    	Vehicle.Ownership_Date,
    	Vehicle.Do_Not_Rent_Past_Days,
	1 AS Foreign_OC ,
	location.hub_id as Hub_id
 

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
	inner join 
	(SELECT MAX(VM1.Date_In) AS Last_Date_In, Max(Movement_In) as Last_Move_In, VM1.Unit_Number As Unit_number FROM
		(
		
		 SELECT  Null Date_In,   Movement_In , Unit_Number
			FROM         dbo.Vehicle_Movement
		 UNION
		 SELECT(Case When Actual_Check_In is not null then Actual_Check_In 
				Else Expected_Check_In 
				End)as Date_in, 
				Null Movement_In, 
				Unit_Number
		 FROM	vehicle_on_contract) VM1 Group By VM1.Unit_Number) VM
 		ON vehicle.unit_number=vm.unit_number
 	inner join 	
		
		(SELECT MAX(VM2.Date_In) AS Last_Move_Time, VM2.Unit_Number As Unit_number FROM
		(SELECT     Movement_In as Date_in, Unit_Number
			FROM         dbo.Vehicle_Movement
		 UNION
		 --SELECT Actual_Check_In as Date_in, Unit_Number
			--FROM	 vehicle_on_contract
			
				
			SELECT (Case When Actual_Check_In is not null then Actual_Check_In 
				Else Expected_Check_In 
				End)as Date_in,	 				
				Unit_Number
			FROM	vehicle_on_contract
			) VM2 Group By VM2.Unit_Number) LocVM		
		on vehicle.unit_number=LocVM.unit_number
		
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
