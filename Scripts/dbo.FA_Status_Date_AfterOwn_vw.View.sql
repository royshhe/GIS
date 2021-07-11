USE [GISData]
GO
/****** Object:  View [dbo].[FA_Status_Date_AfterOwn_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FA_Status_Date_AfterOwn_vw]
AS
SELECT     dbo.Vehicle.Unit_Number, MIN(dbo.Vehicle_History.Effective_On) AS ISD
FROM         dbo.Vehicle INNER JOIN
                      dbo.Vehicle_History ON dbo.Vehicle.Unit_Number = dbo.Vehicle_History.Unit_Number
WHERE   (dbo.Vehicle_History.Vehicle_Status = 'e')
GROUP BY dbo.Vehicle.Unit_Number



GO
