USE [GISData]
GO
/****** Object:  View [dbo].[P_Rate_Charge_Amount]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Rate_Charge_Amount]
AS
SELECT     Rate_ID, Effective_Date, Termination_Date, Rate_Level, Rate_Time_Period_ID, Rate_Vehicle_Class_ID, Type, Amount
FROM         svbvm032.Geordydata.dbo.Rate_Charge_Amount AS Rate_Charge_Amount
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())


GO
