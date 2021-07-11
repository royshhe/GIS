USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleClass]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ViewLocationVehicleClass]
AS
SELECT     dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID, dbo.Location.Location + '  -  ' + dbo.Vehicle_Class.Vehicle_Class_Name AS LocationVC
FROM         dbo.Location_Vehicle_Class INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Location_Vehicle_Class.Valid_To IS NULL) OR
                      (dbo.Location_Vehicle_Class.Valid_To > GETDATE())

GO
