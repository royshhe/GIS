USE [GISData]
GO
/****** Object:  View [dbo].[RMCheckDuplicationLocationRateLevel_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RMCheckDuplicationLocationRateLevel_vw]
AS
SELECT     COUNT(*) AS Expr1, dbo.LocationVehicleRateLevel.Rate_Level, dbo.LocationVehicleRateLevel.Location_Vehicle_Rate_Type, 
                      dbo.LocationVehicleRateLevel.Valid_From, dbo.LocationVehicleRateLevel.Rate_Selection_Type, dbo.Vehicle_Rate.Rate_Name, dbo.Location.Location, 
                      dbo.Vehicle_Class.Vehicle_Class_Name
FROM         dbo.LocationVehicleRateLevel INNER JOIN
                      dbo.Vehicle_Rate ON dbo.LocationVehicleRateLevel.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Location ON dbo.LocationVehicleRateLevel.Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.LocationVehicleRateLevel.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Vehicle_Rate.Termination_Date > GETDATE())
GROUP BY dbo.LocationVehicleRateLevel.Vehicle_Class_Code, dbo.LocationVehicleRateLevel.Rate_Level, 
                      dbo.LocationVehicleRateLevel.Location_Vehicle_Rate_Type, dbo.LocationVehicleRateLevel.Valid_From, 
                      dbo.LocationVehicleRateLevel.Rate_Selection_Type, dbo.Vehicle_Rate.Rate_Name, dbo.Location.Location, 
                      dbo.Vehicle_Class.Vehicle_Class_Name
HAVING      (COUNT(*) > 1)

GO
