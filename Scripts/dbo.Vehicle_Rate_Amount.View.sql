USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Rate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Vehicle_Rate_Amount]
AS
SELECT     dbo.Rate_Charge_Amount.Rate_ID, dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Vehicle_Rate.Rate_Name, dbo.Rate_Charge_Amount.Rate_Level, 
                      dbo.Rate_Time_Period.Time_Period, dbo.Rate_Time_Period.Time_Period_Start, dbo.Rate_Time_Period.Time_period_End, 
                      dbo.Rate_Time_Period.Type, dbo.Rate_Charge_Amount.Amount, dbo.Rate_Vehicle_Class.Per_KM_Charge
FROM         dbo.Rate_Charge_Amount INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Rate_Charge_Amount.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Rate_Time_Period ON dbo.Rate_Charge_Amount.Rate_Time_Period_ID = dbo.Rate_Time_Period.Rate_Time_Period_ID AND 
                      dbo.Rate_Charge_Amount.Type = dbo.Rate_Time_Period.Type AND dbo.Rate_Charge_Amount.Rate_ID = dbo.Rate_Time_Period.Rate_ID INNER JOIN
                      dbo.Rate_Vehicle_Class ON dbo.Rate_Charge_Amount.Rate_Vehicle_Class_ID = dbo.Rate_Vehicle_Class.Rate_Vehicle_Class_ID AND 
                      dbo.Rate_Charge_Amount.Rate_ID = dbo.Rate_Vehicle_Class.Rate_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Rate_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
WHERE     (dbo.Vehicle_Rate.Termination_Date > GETDATE()) AND (dbo.Rate_Charge_Amount.Termination_Date > GETDATE()) AND 
                      (dbo.Rate_Vehicle_Class.Termination_Date > GETDATE()) AND (dbo.Rate_Time_Period.Termination_Date > GETDATE()) AND 
                      (dbo.Rate_Charge_Amount.Type = 'Regular')


GO
