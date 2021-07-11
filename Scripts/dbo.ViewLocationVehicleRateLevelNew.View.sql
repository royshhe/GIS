USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleRateLevelNew]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewLocationVehicleRateLevelNew]
AS
SELECT     dbo.LocationVehicleRateLevel.*
FROM         dbo.LocationVehicleRateLevel
WHERE     (Valid_To > GETDATE())

GO
