USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_5_Vehicle_Utilization_Current_L1_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
VIEW NAME: RP_Flt_5_Vehicle_Utilization_Current_L1_Main
PURPOSE: Select all the information needed for Vehicle Utilization - Current Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Vehicle Utilization - Current Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/11/10	exclude Vehicle Status (Damaged: Not Repairable) from report
Joseph Tseung	1999/11/10	select Vehicle Status
Joseph Tseung	2000/01/21	Exclude deleted vehicles
Roy He Hard code Hub Information  --- too bad


*/
CREATE VIEW [dbo].[RP_Flt_5_Vehicle_Utilization_Current_L1_Main]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Owning_Company.Name AS Location_Owning_Company_Name, dbo.Location.Location AS Current_Location_Name, 
                      dbo.Vehicle_Class.Vehicle_Type_ID, dbo.Vehicle.Current_Rental_Status AS Vehicle_Rental_Status, 
                      dbo.Vehicle.Current_Condition_Status AS Vehicle_Condition_Status, dbo.Vehicle.Current_Vehicle_Status AS Vehicle_Status, 
                      Hub='Vancouver'
	       FROM         dbo.Vehicle WITH (NOLOCK) INNER JOIN
                      dbo.Location ON dbo.Vehicle.Current_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Owning_Company ON dbo.Location.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID INNER JOIN
                      dbo.Lookup_Table ON dbo.Vehicle.Owning_Company_ID = dbo.Lookup_Table.Code INNER JOIN
                      dbo.Lookup_Table LookupHub ON dbo.Location.Hub_ID = LookupHub.Code
WHERE     (--dbo.Vehicle.Current_Vehicle_Status = 'b' OR   -- according to Estella, we should not include owned status
                      dbo.Vehicle.Current_Vehicle_Status = 'd' OR
                      dbo.Vehicle.Current_Vehicle_Status = 'j') AND (dbo.Lookup_Table.Category = 'BudgetBC Company') AND (dbo.Vehicle.Deleted = 0) AND 
                      (LookupHub.Category = 'Hub')





GO
