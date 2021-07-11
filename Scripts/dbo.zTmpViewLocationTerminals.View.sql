USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewLocationTerminals]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewLocationTerminals]
AS
SELECT     dbo.Location.Location, dbo.Terminal.Terminal_ID, dbo.Terminal.Location_ID
FROM         dbo.Terminal INNER JOIN
                      dbo.Location ON dbo.Terminal.Location_ID = dbo.Location.Location_ID

GO
