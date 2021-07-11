USE [GISData]
GO
/****** Object:  View [dbo].[ViewLocationVehicleClassVancouver]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewLocationVehicleClassVancouver]
AS
SELECT     dbo.Location_Vehicle_Class.*
FROM         dbo.Location_Vehicle_Class INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID
WHERE     (dbo.Location.Hub_ID = 1) AND (dbo.Location.Rental_Location = 1) AND (dbo.Location.Owning_Company_ID = 7425) AND (dbo.Location.Delete_Flag = 0)
and Valid_to>getDate() or Valid_to is null



GO
