USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Class_NONGIS_Rate_Amount_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vehicle_Class_NONGIS_Rate_Amount_vw]
AS
SELECT     dbo.Quoted_Time_Period_Rate.Time_Period, dbo.Quoted_Time_Period_Rate.Time_Period_Start, dbo.Quoted_Time_Period_Rate.Time_Period_End, 
                      dbo.Quoted_Time_Period_Rate.Amount, dbo.Quoted_Time_Period_Rate.Rate_Type, dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID
FROM         dbo.Quoted_Time_Period_Rate INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
WHERE     (dbo.Quoted_Time_Period_Rate.Rate_Type = 'Regular')
GO
