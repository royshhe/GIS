USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehiclesoldHistory2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVehiclesoldHistory2]
AS
SELECT     dbo.Vehicle.Unit_Number, dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, dbo.Vehicle.Serial_Number, 
                      Lookup_Table1.[Value] AS Status, dbo.ViewVehicleInServiceDate.InService AS [In Service], dbo.Vehicle.Drop_ShipDate, dbo.Vehicle.Ownership_Date, 
                      dbo.ViewLastestPullForDesposalDate.[Pulled For Disposal Date], dbo.ViewVehicleSold.[Sold Date], dbo.Vehicle.Current_Km, 
                      Lookup_Table.[Value] AS Manufacturer, Lookup_Table1.Code
FROM         dbo.Vehicle WITH (NOLOCK) INNER JOIN
                      dbo.Vehicle_Model_Year ON dbo.Vehicle.Vehicle_Model_ID = dbo.Vehicle_Model_Year.Vehicle_Model_ID INNER JOIN
                      dbo.Lookup_Table Lookup_Table ON dbo.Vehicle_Model_Year.Manufacturer_ID = Lookup_Table.Code INNER JOIN
                      dbo.ViewLastestPullForDesposalDate ON dbo.Vehicle.Unit_Number = dbo.ViewLastestPullForDesposalDate.Unit_Number INNER JOIN
                      dbo.ViewVehicleSold ON dbo.Vehicle.Unit_Number = dbo.ViewVehicleSold.Unit_Number INNER JOIN
                      dbo.Lookup_Table Lookup_Table1 ON dbo.Vehicle.Current_Vehicle_Status = Lookup_Table1.Code LEFT OUTER JOIN
                      dbo.ViewVehicleInServiceDate ON dbo.Vehicle.Unit_Number = dbo.ViewVehicleInServiceDate.Unit_Number
WHERE     (Lookup_Table1.Category = 'Vehicle Status') AND (dbo.Vehicle.Owning_Company_ID = '7425') AND (dbo.Vehicle.Deleted = 0) AND 
                      (Lookup_Table.Category = 'Manufacturer') AND (dbo.ViewVehicleSold.[Sold Date] BETWEEN '2002-09-01' AND '2002-09-30') AND 
                      (dbo.Vehicle.Current_Vehicle_Status = 'i')
GO
