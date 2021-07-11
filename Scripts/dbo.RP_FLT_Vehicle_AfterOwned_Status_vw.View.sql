USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_Vehicle_AfterOwned_Status_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_FLT_Vehicle_AfterOwned_Status_vw]
AS
SELECT     dbo.Vehicle_History.Unit_Number, max(dbo.Vehicle_History.Vehicle_Status) as Vehicle_Status, dbo.Vehicle_History.Effective_On
FROM         dbo.RP_FLT_Vehicle_AfterOwned_StatusDate_vw INNER JOIN
                      dbo.Vehicle_History ON dbo.RP_FLT_Vehicle_AfterOwned_StatusDate_vw.Unit_Number = dbo.Vehicle_History.Unit_Number AND 
                      dbo.RP_FLT_Vehicle_AfterOwned_StatusDate_vw.AfterOwnedStatusDate = dbo.Vehicle_History.Effective_On
Group by dbo.Vehicle_History.Unit_Number,  dbo.Vehicle_History.Effective_On

GO
