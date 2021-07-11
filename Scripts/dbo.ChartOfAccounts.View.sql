USE [GISData]
GO
/****** Object:  View [dbo].[ChartOfAccounts]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ChartOfAccounts]
AS
SELECT     dbo.glchart_base.account_code, dbo.glchart_base.account_description, dbo.glactype.type_description, dbo.AccountTypeMapping.ACCTTYPE, 
                      dbo.AccountTypeMapping.ACCTBAL, dbo.glchart_base.inactive_flag
FROM         dbo.glchart_base INNER JOIN
                      dbo.AccountTypeMapping ON dbo.glchart_base.account_type = dbo.AccountTypeMapping.AccountType INNER JOIN
                      dbo.glactype ON dbo.glchart_base.account_type = dbo.glactype.type_code
GO
