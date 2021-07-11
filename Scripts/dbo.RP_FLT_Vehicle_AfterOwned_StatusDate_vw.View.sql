USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_Vehicle_AfterOwned_StatusDate_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_FLT_Vehicle_AfterOwned_StatusDate_vw]
AS
SELECT     dbo.Vehicle.Unit_Number, MIN(dbo.Vehicle_History.Effective_On) AS AfterOwnedStatusDate
FROM         dbo.Vehicle INNER JOIN
                      dbo.Vehicle_History ON dbo.Vehicle.Unit_Number = dbo.Vehicle_History.Unit_Number
WHERE     (dbo.Vehicle_History.Vehicle_Status > 'b') AND (dbo.Vehicle_History.Vehicle_Status <= 'e')
GROUP BY dbo.Vehicle.Unit_Number

GO
