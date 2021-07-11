USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GenerateVCRateAmount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GenerateVCRateAmount]

as


Insert into Rate_Level
SELECT DISTINCT 
                      dbo.Vehicle_Rate.Rate_ID, GETDATE() AS Effective_Date, '12/31/2078 11:59:00 PM' AS Termination_Date, 
                      dbo.Rate_Charge_Amount_Input.Rate_Level
FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Charge_Amount_Input ON dbo.Vehicle_Rate.Rate_ID = dbo.Rate_Charge_Amount_Input.Rate_ID
WHERE     (dbo.Vehicle_Rate.Termination_Date = 'Dec 31 2078 11:59PM')  AND (dbo.Rate_Charge_Amount_Input.Rate_Level <> 'A')


Insert into Rate_charge_amount

SELECT DISTINCT 
                      dbo.Vehicle_Rate.Rate_ID, GETDATE() AS Effective_Date, '12/31/2078 11:59:00 PM' AS Termination_Date, dbo.Rate_Charge_Amount_Input.Rate_Level, 
                      RTP.Rate_Time_Period_ID, RVC.Rate_Vehicle_Class_ID, dbo.Rate_Charge_Amount_Input.Type, dbo.Rate_Charge_Amount_Input.Amount
FROM         dbo.Rate_Vehicle_Class RVC INNER JOIN
                      dbo.Rate_Time_Period RTP INNER JOIN
                      dbo.Vehicle_Rate ON RTP.Rate_ID = dbo.Vehicle_Rate.Rate_ID ON RVC.Rate_ID = dbo.Vehicle_Rate.Rate_ID INNER JOIN
                      dbo.Rate_Charge_Amount_Input ON RVC.Rate_ID = dbo.Rate_Charge_Amount_Input.Rate_ID AND 
                      RTP.Rate_ID = dbo.Rate_Charge_Amount_Input.Rate_ID AND RTP.Time_Period = dbo.Rate_Charge_Amount_Input.Time_Period AND 
                      RTP.Time_Period_Start = dbo.Rate_Charge_Amount_Input.Time_Period_Start AND 
                      RTP.Time_period_End = dbo.Rate_Charge_Amount_Input.Time_Period_End AND RTP.Type = dbo.Rate_Charge_Amount_Input.Type AND 
                      RVC.Vehicle_Class_Code = dbo.Rate_Charge_Amount_Input.Vehicle_Class_Code
WHERE     (RTP.Termination_Date = 'Dec 31 2078 11:59PM') AND (RVC.Termination_Date = 'Dec 31 2078 11:59PM') AND 
                      (dbo.Vehicle_Rate.Termination_Date = 'Dec 31 2078 11:59PM')
 AND (dbo.Rate_Charge_Amount_Input.Rate_Level <> 'A') and (dbo.Rate_Charge_Amount_Input.Rate_Level <> 'z')



--delete Rate_Charge_Amount_Input





GO
