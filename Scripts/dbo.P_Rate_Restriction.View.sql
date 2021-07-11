USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Restriction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[P_Rate_Restriction]
AS
SELECT     Rate_ID, Effective_Date, Termination_Date, Restriction_ID, Time_of_Day, Number_of_Days, Number_of_Hours
FROM         svbvm032.Geordydata.dbo.Rate_Restriction AS Rate_Restriction
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())

GO
