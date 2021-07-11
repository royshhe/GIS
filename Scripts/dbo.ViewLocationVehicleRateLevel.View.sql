USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleRateLevel]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewLocationVehicleRateLevel]
AS
SELECT     Location_Vehicle_Class_ID, Rate_ID, Rate_Level, Location_Vehicle_Rate_Type, Valid_From, Valid_To, Rate_Selection_Type
FROM         dbo.Location_Vehicle_Rate_Level
WHERE     Valid_To is null or (Valid_To > GETDATE())  




GO
