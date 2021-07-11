USE [GISData]
GO
/****** Object:  View [dbo].[zTmpOptionalExtraGLMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[zTmpOptionalExtraGLMapping]
AS
SELECT     dbo.Optional_Extra_GL.Vehicle_Type_ID, dbo.Optional_Extra_GL.GL_Revenue_Account, dbo.GLChartMapping.Account_Code_New, 
                      dbo.GLChartMapping.Account_description_New
FROM         dbo.Optional_Extra_GL INNER JOIN
                      dbo.GLChartMapping ON dbo.Optional_Extra_GL.GL_Revenue_Account = dbo.GLChartMapping.Account_Code_Old

GO
