USE [GISData]
GO
/****** Object:  View [dbo].[ViewUserFees]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewUserFees]
AS
SELECT     Transaction_Type, Transaction_Description, COUNT(*) AS NumberOfTrans
FROM         dbo.Business_Transaction
WHERE     (Transaction_Date >= '2003-01-01') AND (Transaction_Date < '2004-01-01')
GROUP BY Transaction_Description, Transaction_Type


GO
