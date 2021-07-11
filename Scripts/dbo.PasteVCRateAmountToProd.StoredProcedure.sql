USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PasteVCRateAmountToProd]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[PasteVCRateAmountToProd]

as


UPDATE    Rate_Level
SET              Termination_Date = getdate()
--SELECT     Rate_Level.*
FROM         Rate_Level
where dbo.Rate_Level.Rate_ID in (select distinct Rate_id from
                      dbo.Rate_Charge_Amount_Input) and dbo.Rate_Level.Termination_Date>getdate()


-- create rate level
Insert into Rate_Level
SELECT DISTINCT 
                      dbo.Vehicle_Rate.Rate_ID, GETDATE() AS Effective_Date, '12/31/2078 11:59:00 PM' AS Termination_Date, 
                      dbo.Rate_Charge_Amount_Input.Rate_Level
FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Charge_Amount_Input ON dbo.Vehicle_Rate.Rate_ID = dbo.Rate_Charge_Amount_Input.Rate_ID
WHERE     (dbo.Vehicle_Rate.Termination_Date = 'Dec 31 2078 11:59PM')  --AND (dbo.Rate_Charge_Amount_Input.Rate_Level <> 'A')


-- Terminate the current rate amount
UPDATE    Rate_charge_amount
SET              Termination_Date = getdate()
--SELECT     Rate_Charge_Amount.*
FROM         dbo.Rate_Charge_Amount 
where dbo.Rate_Charge_Amount.Rate_ID in (select distinct Rate_id from
                      dbo.Rate_Charge_Amount_Input) and dbo.Rate_Charge_Amount.Termination_Date>getdate()
And
Rate_Vehicle_Class_ID in 
(
	SELECT     Rate_Vehicle_Class.Rate_Vehicle_Class_ID
	FROM         Rate_Vehicle_Class
	where dbo.Rate_Vehicle_Class.Rate_ID in (select distinct Rate_id from
						  dbo.Rate_Charge_Amount_Input) and dbo.Rate_Vehicle_Class.Termination_Date>getdate()
		  and Vehicle_Class_Code in (select Vehicle_Class_Code from dbo.Rate_Charge_Amount_Input)
)

UPDATE    Rate_Vehicle_Class
SET              Termination_Date = getdate()
--SELECT     Rate_Vehicle_Class.*
FROM         Rate_Vehicle_Class
where dbo.Rate_Vehicle_Class.Rate_ID in (select distinct Rate_id from
                      dbo.Rate_Charge_Amount_Input) and dbo.Rate_Vehicle_Class.Termination_Date>getdate()
      and Vehicle_Class_Code in (select distinct Vehicle_Class_Code from dbo.Rate_Charge_Amount_Input)

---
Insert into Rate_Vehicle_Class (Rate_ID, Effective_Date, Termination_Date, Vehicle_Class_Code, Per_KM_Charge)
SELECT DISTINCT Rate_ID, GETDATE() AS Effective_Date, '2078-12-31 23:59:00.000 ' AS Termination_Date, Vehicle_Class_Code, Per_KM_Charge
FROM         dbo.Rate_Charge_Amount_Input
--



-- insert new
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
 --AND (dbo.Rate_Charge_Amount_Input.Rate_Level <> 'A')
GO
