USE [GISData]
GO
/****** Object:  View [dbo].[zTmpViewChangeTyes]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[zTmpViewChangeTyes]
AS
SELECT     dbo.Lookup_Table.Category, dbo.Lookup_Table.Code, dbo.Lookup_Table.[Value], dbo.Charge_GL.GL_Revenue_Account
FROM         dbo.Lookup_Table INNER JOIN
                      dbo.Charge_GL ON dbo.Lookup_Table.Code = dbo.Charge_GL.Charge_Type_ID
WHERE     (dbo.Lookup_Table.Category LIKE '%CHARGE TYPE%')

GO
