USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicleSoldHistory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVehicleSoldHistory]
AS
SELECT Vehicle.Unit_Number, Vehicle_Model_Year.Model_Name, 
    Vehicle_Model_Year.Model_Year, Vehicle.Serial_Number, 
    Lookup_Table1.Value AS Status, 
    ViewVehicleInServiceDate.InService AS [In Service], 
    Vehicle.Drop_ShipDate, Vehicle.Ownership_Date, 
    ViewLastestPullForDesposalDate.[Pulled For Disposal Date], 
    ViewVehicleSold.[Sold Date], Vehicle.Current_Km, 
    Lookup_Table.Value AS Manufacturer, 
    Lookup_Table1.Code
FROM Vehicle with(NOLOCK) INNER JOIN
    Vehicle_Model_Year ON
    Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     INNER JOIN
    Lookup_Table Lookup_Table ON 
    Vehicle_Model_Year.Manufacturer_ID = Lookup_Table.Code 
    Inner join 
    Lookup_Table Lookup_table2 on
    Vehicle.Owning_Company_ID=lookup_table2.code
    INNER JOIN
    ViewLastestPullForDesposalDate ON 
    Vehicle.Unit_Number = ViewLastestPullForDesposalDate.Unit_Number
    INNER JOIN
    ViewVehicleSold ON 
    Vehicle.Unit_Number = ViewVehicleSold.Unit_Number INNER JOIN
    Lookup_Table Lookup_Table1 ON 
    Vehicle.Current_Vehicle_Status = Lookup_Table1.Code LEFT OUTER
     JOIN
    ViewVehicleInServiceDate ON 
    Vehicle.Unit_Number = ViewVehicleInServiceDate.Unit_Number
WHERE (Lookup_Table1.Category = 'Vehicle Status') AND 
   (Lookup_Table2.Category = 'BudgetBC Company') and
   -- (Vehicle.Owning_Company_ID = '7425') AND 
    (Vehicle.Deleted = 0) AND 
    (Lookup_Table.Category = 'Manufacturer') AND 
    (ViewLastestPullForDesposalDate.[Pulled For Disposal Date] BETWEEN
     '2002-09-01' AND '2002-09-30') AND 
    (Vehicle.Current_Vehicle_Status = 'i')
GO
