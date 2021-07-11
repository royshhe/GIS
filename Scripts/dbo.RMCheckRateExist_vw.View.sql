USE [GISData]
GO
/****** Object:  View [dbo].[RMCheckRateExist_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RMCheckRateExist_vw]
AS
SELECT     *
FROM         dbo.TmpLocationVehicleRateLevel
WHERE     (Rate NOT IN
                          (SELECT     Rate_name
                            FROM          Vehicle_rate
                           WHERE      dbo.Vehicle_Rate.Termination_Date > GETDATE() ))




GO
