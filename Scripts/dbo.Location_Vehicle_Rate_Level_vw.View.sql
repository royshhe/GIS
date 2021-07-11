USE [GISData]
GO
/****** Object:  View [dbo].[Location_Vehicle_Rate_Level_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[Location_Vehicle_Rate_Level_vw]
AS
SELECT DISTINCT 
                      dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID, dbo.LocationVehicleRateLevel.Rate_ID, dbo.LocationVehicleRateLevel.Rate_Level, 
                      dbo.LocationVehicleRateLevel.Location_Vehicle_Rate_Type, dbo.LocationVehicleRateLevel.Valid_From, dbo.LocationVehicleRateLevel.Valid_To, 
                      dbo.LocationVehicleRateLevel.Rate_Selection_Type
FROM         dbo.LocationVehicleRateLevel INNER JOIN
                      dbo.Location_Vehicle_Class ON dbo.LocationVehicleRateLevel.Location_ID = dbo.Location_Vehicle_Class.Location_ID AND 
                      dbo.LocationVehicleRateLevel.Vehicle_Class_Code = dbo.Location_Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Location_Vehicle_Class.Valid_To >= GETDATE()) OR
                      (dbo.Location_Vehicle_Class.Valid_To IS NULL)


GO
