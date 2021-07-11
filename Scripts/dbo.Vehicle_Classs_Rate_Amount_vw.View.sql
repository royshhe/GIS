USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Classs_Rate_Amount_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vehicle_Classs_Rate_Amount_vw]
AS
SELECT     RTP.Time_Period, RTP.Time_Period_Start, RTP.Time_period_End, RCA.Amount, RCA.Effective_Date AS RCA_Effective_Date, 
                      RCA.Termination_Date AS RCA_Termination_Date, RVC.Effective_Date AS RVC_Effective_date, RVC.Termination_Date AS RVC_Termination_date, 
                      RTP.Effective_Date AS RPT_Effective_date, RTP.Termination_Date AS RTP_Termination_Date, RCA.Rate_ID, RCA.Rate_Level, 
                      RVC.Vehicle_Class_Code, RVC.Per_KM_Charge
FROM         dbo.Rate_Charge_Amount RCA INNER JOIN
                      dbo.Rate_Time_Period RTP ON RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID AND RCA.Rate_ID = RTP.Rate_ID INNER JOIN
                      dbo.Rate_Vehicle_Class RVC ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID AND RCA.Rate_ID = RVC.Rate_ID
WHERE     (RCA.Type = 'Regular')
GO
