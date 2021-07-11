USE [GISData]
GO
/****** Object:  View [dbo].[tmpSalesJournalGLMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[tmpSalesJournalGLMapping]
AS
SELECT     dbo.Sales_Journal.Business_Transaction_ID, dbo.Sales_Journal.Sequence, dbo.Sales_Journal.GL_Account, dbo.GLChartMapping.Account_Code_New, 
                      dbo.Sales_Journal.Amount, dbo.Business_Transaction.RBR_Date
FROM         dbo.Sales_Journal INNER JOIN
                      dbo.Business_Transaction ON dbo.Sales_Journal.Business_Transaction_ID = dbo.Business_Transaction.Business_Transaction_ID INNER JOIN
                      dbo.GLChartMapping ON dbo.Sales_Journal.GL_Account = dbo.GLChartMapping.Account_Code_Old
WHERE     (dbo.Business_Transaction.RBR_Date = '2005-10-12')
GO
