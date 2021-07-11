USE [GISData]
GO
/****** Object:  View [dbo].[ViewRateVCAmount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewRateVCAmount]
AS
SELECT DISTINCT 
                      RVC.Vehicle_Class_Code, RVC.Rate_ID, RTP.Km_Cap, RCA.Rate_Level, RTP.Time_Period, RTP.Time_Period_Start, RTP.Time_period_End, 
                      RCA.Amount, RCA.Type, RVC.Per_KM_Charge, dbo.Vehicle_Rate.Rate_Name
FROM         dbo.Rate_Charge_Amount RCA INNER JOIN
                      dbo.Rate_Vehicle_Class RVC ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID AND RCA.Rate_ID = RVC.Rate_ID INNER JOIN
                      dbo.Rate_Time_Period RTP ON RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID AND RCA.Rate_ID = RTP.Rate_ID INNER JOIN
                      dbo.Vehicle_Rate ON RCA.Rate_ID = dbo.Vehicle_Rate.Rate_ID
WHERE     (RCA.Type = 'Regular') AND (RCA.Termination_Date = 'Dec 31 2078 11:59PM') AND (RTP.Termination_Date = 'Dec 31 2078 11:59PM') AND 
                      (RVC.Termination_Date = 'Dec 31 2078 11:59PM') AND (dbo.Vehicle_Rate.Termination_Date = 'Dec 31 2078 11:59PM')
GO
