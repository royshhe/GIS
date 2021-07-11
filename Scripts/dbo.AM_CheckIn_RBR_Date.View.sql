USE [GISData]
GO
/****** Object:  View [dbo].[AM_CheckIn_RBR_Date]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[AM_CheckIn_RBR_Date]
AS
SELECT     max(dbo.Business_Transaction.RBR_Date) AS Checkin_RBR_Date, dbo.Business_Transaction.Contract_Number
FROM         dbo.Business_Transaction WITH(NOLOCK) INNER JOIN
                      dbo.Contract WITH(NOLOCK) ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
--WHERE     (dbo.Business_Transaction.Transaction_Description in ( 'Check in', 'Foreign Check In') ) AND (dbo.Business_Transaction.Transaction_Type = 'Con') AND 
	WHERE     (dbo.Business_Transaction.Transaction_Description in ( 'Check in') ) AND (dbo.Business_Transaction.Transaction_Type = 'Con') AND 	
                      (dbo.Contract.Status = 'ci')
Group by dbo.Business_Transaction.Contract_Number
GO
