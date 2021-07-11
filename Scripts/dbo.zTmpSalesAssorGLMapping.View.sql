USE [GISData]
GO
/****** Object:  View [dbo].[zTmpSalesAssorGLMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[zTmpSalesAssorGLMapping]
AS
SELECT     dbo.Sales_Accessory.Sales_Accessory_ID, dbo.Sales_Accessory.Unit_Description, dbo.Sales_Accessory.GL_Revenue_Account, 
                      dbo.GLChartMapping.Account_description_Old, dbo.GLChartMapping.Account_Code_New, dbo.GLChartMapping.Account_description_New
FROM         dbo.Sales_Accessory INNER JOIN
                      dbo.GLChartMapping ON dbo.Sales_Accessory.GL_Revenue_Account = dbo.GLChartMapping.Account_Code_Old

GO
