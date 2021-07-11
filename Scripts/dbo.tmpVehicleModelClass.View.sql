USE [GISData]
GO
/****** Object:  View [dbo].[tmpVehicleModelClass]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[tmpVehicleModelClass]
AS
SELECT     dbo.Vehicle_Model_Year.Model_Name, dbo.Vehicle_Model_Year.Model_Year, dbo.Vehicle_Model_Year.Vehicle_Model_ID, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Class.Vehicle_Class_Code
FROM         dbo.Vehicle_Model_Year INNER JOIN
                      dbo.Vehicle_Class_Vehicle_Model_Yr ON 
                      dbo.Vehicle_Model_Year.Vehicle_Model_ID = dbo.Vehicle_Class_Vehicle_Model_Yr.Vehicle_Model_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Vehicle_Class_Vehicle_Model_Yr.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code

GO
