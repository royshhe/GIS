USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateFleetMix]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[CreateFleetMix]
 
AS
   
   
   Delete RP_Flt_7_Fleet_Mix where RP_Date>=Convert(datetime, convert(varchar, getdate(), 111)) and RP_Date<=Convert(datetime, convert(varchar, getdate(), 111))+1
   
   Insert Into RP_Flt_7_Fleet_Mix
   
   -- Taking Snapshot of the record, inccluding Vehcle Class Name, location_name, Hub Name etc, in case Name changed
      
   Select dbo.Location.Hub_ID, LookupHub.Value as Hub,dbo.Vehicle.Current_Location_ID, dbo.Location.Location AS Current_Location_Name,dbo.Vehicle_Class.Vehicle_Type_ID,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Class_Name,
   sum(Case 
		When  Current_Rental_Status in ('a', 'c') Then 1
			Else 0
   End) available,
   
   sum(Case 
		When Current_Rental_Status   ='b'	Then 1
			Else 0
   End) OnRent,
   getdate()
  -- Convert(datetime, convert(varchar, getdate(), 111)) as RP_Date
   	   		
	
--SELECT 	Vehicle.Unit_Number,
--	Vehicle_Class.Vehicle_Type_ID,
--    	Location.Location AS Current_Location_Name,
--    	Vehicle.Current_Rental_Status AS Vehicle_Rental_Status,
--    	Vehicle_Class.Vehicle_Class_Code,
--    	Vehicle_Class.Vehicle_Class_Name,
--	Vehicle_Class.DisplayOrder,
--    	Vehicle.Current_Location_ID
             
FROM 	Vehicle with(nolock)
	INNER JOIN
    	Location
		ON  Vehicle.Current_Location_ID = Location.Location_ID
	INNER JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Lookup_Table  as LookupHub
		ON Vehicle.Owning_Company_ID = CONVERT(smallint,LookupHub.Code)
WHERE   Vehicle.Current_Vehicle_Status = 'd'
	AND
	(LookupHub.Category = 'BudgetBC Company')
	AND
	Vehicle.Deleted = 0

Group by   dbo.Location.Hub_ID, LookupHub.Value  ,dbo.Vehicle.Current_Location_ID, dbo.Location.Location,dbo.Vehicle_Class.Vehicle_Class_Code,dbo.Vehicle_Class.Vehicle_Class_Name,vehicle_class.vehicle_type_id
Order by dbo.Location.Hub_ID,dbo.Vehicle.Current_Location_ID,dbo.Vehicle_Class.Vehicle_Type_ID

GO
