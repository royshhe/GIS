USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_ContractOpen_Counting]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Adhoc_ContractOpen_Counting]
AS
SELECT     Transaction_Type, Transaction_Description, COUNT(*) AS NumberOfTrans, MONTH(Transaction_Date) AS TransMonth, YEAR(Transaction_Date) 
                      AS TransYear
FROM         dbo.Business_Transaction
WHERE     (Transaction_Date >= '2000-01-01') AND (Transaction_Date < '2004-09-01') AND (Transaction_Description = 'Check Out')
GROUP BY Transaction_Description, Transaction_Type, MONTH(Transaction_Date), YEAR(Transaction_Date)
GO
