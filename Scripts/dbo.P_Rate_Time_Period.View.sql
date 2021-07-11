USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Time_Period]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Rate_Time_Period]
AS
SELECT     Rate_Time_Period_ID, Rate_ID, Effective_Date, Termination_Date, Time_Period, Time_Period_Start, Type, Time_period_End, Km_Cap
FROM         svbvm032.Geordydata.dbo.Rate_Time_Period AS Rate_Time_Period
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())


GO
