USE [GISData]
GO
/****** Object:  View [dbo].[zTmpTaxGLMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[zTmpTaxGLMapping]
AS
SELECT     dbo.Tax_Rate.Tax_Type, dbo.Tax_Rate.Payables_Clearing_Account, dbo.GLChartMapping.Account_Code_Old, 
                      dbo.GLChartMapping.Account_description_Old, dbo.GLChartMapping.Account_Code_New, dbo.GLChartMapping.Account_description_New
FROM         dbo.Tax_Rate INNER JOIN
                      dbo.GLChartMapping ON dbo.Tax_Rate.Payables_Clearing_Account = dbo.GLChartMapping.Account_Code_Old

GO
