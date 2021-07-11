USE [GISData]
GO
/****** Object:  View [dbo].[ViewLastestPullForDesposalDate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewLastestPullForDesposalDate]
AS
SELECT MAX(Effective_On) AS [Pulled For Disposal Date], 
    Unit_Number
FROM Vehicle_History WITH(NOLOCK)
WHERE (Vehicle_Status = 'f')
GROUP BY Unit_Number


GO
