USE [GISData]
GO
/****** Object:  View [dbo].[ViewVehicleOwnSold]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewVehicleOwnSold]
AS
SELECT     Unit_Number, CONVERT(Datetime, SUM((CASE WHEN Status = 'Owned' THEN CONVERT(numeric(10, 4), Effective_On) ELSE 0 END))) AS OwnedDate, 
                      CONVERT(Datetime, SUM((CASE WHEN Status = 'Sold' THEN CONVERT(numeric(10, 4), Effective_On) ELSE 0 END))) AS SoldDate
FROM         dbo.ViewVehicleStatusHistory
GROUP BY Unit_Number
GO
