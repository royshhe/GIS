USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleUtilization]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[CreateVehicleUtilization]
 
AS
   
   
   Delete RP_Flt_15_Vehicle_Utilization where RP_Date>=Convert(datetime, convert(varchar, getdate(), 111)) and RP_Date<=Convert(datetime, convert(varchar, getdate(), 111))+1
   Delete RP_Acc_15_Vehicle_Utilization where RP_Date>=Convert(datetime, convert(varchar, getdate(), 111)) and RP_Date<=Convert(datetime, convert(varchar, getdate(), 111))+1
   
   -- Not include Pull for disposal
   Insert Into RP_Flt_15_Vehicle_Utilization
   
   -- Taking Snapshot of the record, inccluding Vehcle Class Name, location_name, Hub Name etc, in case Name changed
      
   Select dbo.Location.Hub_ID, LookupHub.Value as Hub,dbo.Vehicle.Current_Location_ID, dbo.Location.Location AS Current_Location_Name,dbo.Vehicle_Class.Vehicle_Type_ID,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Class_Name,
   sum(Case 
		When Current_Vehicle_Status='b'  or
			 (	Current_Condition_Status is not null and Current_Rental_Status in ('a', 'c') 
				and Current_Condition_Status in ('a','d', 'f', 'h', 'j') 
			  )Then 1
		Else 0
   End) Rentable,
   
   sum(Case 
		When  
			 (	Current_Condition_Status is not null and Current_Rental_Status in ('a', 'c') 
				and Current_Condition_Status in ('b','c', 'e', 'g', 'i','k','l') 
			  )Then 1
		Else 0
   End) Not_Rentable,
   
   
   sum(Case 
		When Current_Rental_Status   ='b'	Then 1
		Else 0
   End) Rented,
   getdate()
  -- Convert(datetime, convert(varchar, getdate(), 111)) as RP_Date
   	   		
	

   FROM       dbo.Vehicle WITH (NOLOCK) INNER JOIN
              dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID INNER JOIN
              dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
              dbo.Owning_Company ON dbo.Location.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID INNER JOIN
              dbo.Lookup_Table ON dbo.Vehicle.Owning_Company_ID = dbo.Lookup_Table.Code INNER JOIN
              dbo.Lookup_Table LookupHub ON dbo.Location.Hub_ID = LookupHub.Code
                   
	WHERE     ( dbo.Vehicle.Current_Vehicle_Status = 'd' OR
              dbo.Vehicle.Current_Vehicle_Status = 'j') AND (dbo.Lookup_Table.Category = 'BudgetBC Company') AND (dbo.Vehicle.Deleted = 0) AND 
              (LookupHub.Category = 'Hub')
    Group by   dbo.Location.Hub_ID, LookupHub.Value  ,dbo.Vehicle.Current_Location_ID, dbo.Location.Location,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Type_ID,dbo.Vehicle_Class.Vehicle_Class_Name
    Order by dbo.Vehicle_Class.Vehicle_Type_ID

-------for Accounting purpose     RP_Acc_15_Vehicle_Utilization
   -- Include Pull for disposal	
   Insert Into RP_Acc_15_Vehicle_Utilization
   
   -- Taking Snapshot of the record, inccluding Vehcle Class Name, location_name, Hub Name etc, in case Name changed
      
   Select dbo.Location.Hub_ID, LookupHub.Value as Hub,dbo.Vehicle.Current_Location_ID, dbo.Location.Location AS Current_Location_Name,dbo.Vehicle_Class.Vehicle_Type_ID,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Class_Name,
   sum(Case 
		When   dbo.Vehicle.Current_Vehicle_Status <> 'f'	And
			 (	Current_Condition_Status is not null and Current_Rental_Status in ('a', 'c') 
				and Current_Condition_Status in ('a','d', 'f', 'h', 'j') 
			  )Then 1
		Else 0
   End) Rentable,
   
   sum(Case 
		When dbo.Vehicle.Current_Vehicle_Status = 'f' Or 
			 (	Current_Condition_Status is not null and Current_Rental_Status in ('a', 'c') 
				and Current_Condition_Status in ('b','c', 'e', 'g', 'i','k','l') 
			  )Then 1
		Else 0
   End) Not_Rentable,
   
   
   sum(Case 
		When Current_Rental_Status   ='b'	Then 1
		Else 0
   End) Rented,
   getdate()
  -- Convert(datetime, convert(varchar, getdate(), 111)) as RP_Date
   	   		
	

   FROM       dbo.Vehicle WITH (NOLOCK) INNER JOIN
              dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID INNER JOIN
              dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
              dbo.Owning_Company ON dbo.Location.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID INNER JOIN
              dbo.Lookup_Table ON dbo.Vehicle.Owning_Company_ID = dbo.Lookup_Table.Code INNER JOIN
              dbo.Lookup_Table LookupHub ON dbo.Location.Hub_ID = LookupHub.Code
                   
	WHERE     (		dbo.Vehicle.Current_Vehicle_Status = 'c' 
				OR dbo.Vehicle.Current_Vehicle_Status = 'd'	
				OR dbo.Vehicle.Current_Vehicle_Status = 'f'
				Or dbo.Vehicle.Current_Vehicle_Status = 'j') AND (dbo.Lookup_Table.Category = 'BudgetBC Company') AND (dbo.Vehicle.Deleted = 0) AND 
              (LookupHub.Category = 'Hub')
    Group by   dbo.Location.Hub_ID, LookupHub.Value  ,dbo.Vehicle.Current_Location_ID, dbo.Location.Location,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Type_ID,dbo.Vehicle_Class.Vehicle_Class_Name
    Order by dbo.Vehicle_Class.Vehicle_Type_ID
    
--a                        	Drop Ship
--b                        	Owned
--c                        	Held
--d                        	Rental
--e                        	Lease
--f                        	Pulled For Disposal
--g                        	Signed Off
--i                        	Sold
--j                        	Stolen
--k                        	Damaged: Not Repairable
--l                        	Written Off


--a                        	O.K.
--b                        	Claims - Not Drivable
--c                        	Claims - Not Rentable
--d                        	Claims - Rentable
--e                        	O/S - Not Rentable
--f                        	O/S - Rentable
--g                        	Turnback - Not Rentable
--h                        	Turnback - Rentable
--i                        	Stolen
--j                        	Not Inspected
--k                        	Maintenance - Not Rentable
--l                        	Maintenance - Rentable

    
--Select * from lookup_table where category like '%vehicle condition status%'

--select * from vehicle where (current_condition_status in ('k','l') and current_vehicle_status ='d')
-- or current_vehicle_status in ('l','k','e')
 
-- select * from vehicle where current_vehicle_status in ('l','k','e')
GO
