USE [GISData]
GO
/****** Object:  View [dbo].[ViewNewVehicleReport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewNewVehicleReport]
AS
SELECT Vehicle.Unit_Number, Vehicle_Model_Year.Model_Name, 
    Vehicle_Model_Year.Model_Year, Vehicle.Serial_Number, 
    Lookup_Table.Value AS status, Vehicle.Ownership_Date, 
    Vehicle.Current_Km, Vehicle.Drop_ShipDate, 
    ViewVehicleInServiceDate.InService, 
    Vehicle.Turn_Back_Deadline, ' ' AS [pull for Disposal], 
    ' ' AS sold, Lookup_Table1.Value AS Manufacturer
FROM Vehicle inner join Lookup_table lookup_table2 on
    Vehicle.Owning_Company_ID=lookup_table2.code
     INNER JOIN
    Vehicle_Model_Year ON 
    Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     LEFT OUTER JOIN
    ViewVehicleInServiceDate ON 
    Vehicle.Unit_Number = ViewVehicleInServiceDate.Unit_Number LEFT
     OUTER JOIN
    Lookup_Table Lookup_Table1 ON 
    Vehicle_Model_Year.Manufacturer_ID = Lookup_Table1.Code LEFT
     OUTER JOIN
    Lookup_Table ON 
    Vehicle.Current_Vehicle_Status = Lookup_Table.Code
WHERE (Lookup_Table.Category = 'Vehicle Status') AND 
     (Lookup_Table2.Category = 'BudgetBC Company') and 
    --(Vehicle.Owning_Company_ID = '7425') AND 
    (Vehicle.Deleted = 0) AND 
    (Lookup_Table1.Category = 'Manufacturer') AND 
    (((Vehicle.Drop_ShipDate BETWEEN '2002-04-01' AND 
    '2002-04-30') AND (Vehicle.Ownership_Date BETWEEN 
    '2002-04-01' AND '2002-04-30')) OR
    ((Vehicle.Drop_ShipDate BETWEEN '2002-03-01' AND 
    '2002-03-30') AND (Vehicle.Ownership_Date BETWEEN 
    '2002-04-01' AND '2002-04-30')))
GO
