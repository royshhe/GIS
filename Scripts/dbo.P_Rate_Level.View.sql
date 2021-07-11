USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Level]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Rate_Level]
AS
SELECT     Rate_ID, Effective_Date, Termination_Date, Rate_Level
FROM         svbvm032.Geordydata.dbo.Rate_Level AS Rate_Level
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())


GO
