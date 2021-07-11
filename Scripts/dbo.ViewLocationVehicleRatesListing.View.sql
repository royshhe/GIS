USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleRatesListing]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*   AND (dbo.Location_Vehicle_Rate_Level.Valid_To > GETDATE())*/
CREATE VIEW [dbo].[ViewLocationVehicleRatesListing]
AS
SELECT     dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type, 
                      dbo.Location_Vehicle_Rate_Level.Rate_ID, dbo.Location_Vehicle_Rate_Level.Rate_Level, dbo.Location_Vehicle_Rate_Level.Valid_From, 
                      dbo.Location_Vehicle_Rate_Level.Valid_To, dbo.Location_Vehicle_Rate_Level.Rate_Selection_Type, dbo.Vehicle_Class.Vehicle_Class_Code
FROM         dbo.Location_Vehicle_Rate_Level INNER JOIN
                      dbo.Location_Vehicle_Class ON 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Location.Owning_Company_ID = 7425) AND (dbo.Location.Location IN ('B-01 YVR Airport', 'B-03 Downtown', 'B-04 Burrard', 'B-11 Cruise Ship'))
GO
