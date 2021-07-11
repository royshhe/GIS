USE [GISData]
GO
/****** Object:  View [dbo].[zTmpChargeGL_Mapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[zTmpChargeGL_Mapping]
AS
SELECT DISTINCT 
                      dbo.Charge_GL.Charge_Type_ID, dbo.Charge_GL.Vehicle_Type_ID, dbo.Charge_GL.GL_Revenue_Account AS GL_Revenue_Account_old, 
                      dbo.glchart_base.account_description AS Acount_description_old, dbo.GLChartMapping.Account_Code_New AS GL_Revenue_Accoun_New, 
                      dbo.GLChartMapping.Account_description_New, dbo.Lookup_Table.[Value]
FROM         dbo.Charge_GL INNER JOIN
                      dbo.GLChartMapping ON dbo.Charge_GL.GL_Revenue_Account = dbo.GLChartMapping.Account_Code_Old INNER JOIN
                      dbo.glchart_base ON dbo.Charge_GL.GL_Revenue_Account = dbo.glchart_base.account_code INNER JOIN
                      dbo.Lookup_Table ON dbo.Charge_GL.Charge_Type_ID = dbo.Lookup_Table.Code
WHERE     (dbo.Lookup_Table.Category LIKE 'Charge Type%')

GO
