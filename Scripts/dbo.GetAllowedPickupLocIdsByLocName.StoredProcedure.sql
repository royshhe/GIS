USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllowedPickupLocIdsByLocName]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllowedPickupLocIdsByLocName]

	@LocName varchar(100)
AS

SELECT     dbo.AllowedPickupLocation.AllowedPickUPLocationID
FROM         dbo.AllowedPickupLocation INNER JOIN
                      dbo.Location ON dbo.AllowedPickupLocation.LocationID = dbo.Location.Location_ID
where  dbo.Location.Location=@LocName
GO
