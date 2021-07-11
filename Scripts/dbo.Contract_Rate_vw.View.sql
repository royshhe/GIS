USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Rate_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Contract_Rate_vw]
AS
SELECT      dbo.Contract.Contract_Number, 
					dbo.Contract.Foreign_Contract_Number,
                    dbo.Contract.First_Name, dbo.Contract.Last_Name,  
                     dbo.Contract.Pick_Up_On, contract.pick_up_location_id,                       
                     dbo.Contract.FF_Member_Number, dbo.Contract.IATA_Number,
                     dbo.RT_Rate_Amount.Rate_Name, 
                     dbo.RT_Rate_Amount.Rate_Level, 
                      SUM(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND RT_Rate_Amount.Time_Period_Start = 1) THEN RT_Rate_Amount.Amount ELSE 0.0 END)
                       AS Daily_rate, MAX(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND RT_Rate_Amount.Time_Period_Start != 1) 
                      THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Addnl_Daily_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Week' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Weekly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Hour' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Hourly_rate, 
                      SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Month' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Monthly_rate, 'GIS' AS Rate_Type
FROM        dbo.Contract INNER JOIN
                   dbo.RT_Rate_Amount ON dbo.Contract.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND 
                   dbo.Contract.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Contract.Rate_Level = dbo.RT_Rate_Amount.Rate_Level 

WHERE     (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.VREffectiveDate AND dbo.RT_Rate_Amount.VRTerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RCAEffectiveDate AND dbo.RT_Rate_Amount.RCATerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RTPEffectiveDate AND dbo.RT_Rate_Amount.RTPTerminationDate) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.RT_Rate_Amount.RVCEffectiveDate AND dbo.RT_Rate_Amount.RVCTerminationDate) AND 
                      (dbo.Contract.Confirmation_Number IS NULL) and Status not in ('vd', 'ca') 
GROUP BY dbo.Contract.Contract_Number, dbo.Contract.Foreign_Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, 
                     dbo.Contract.Pick_Up_On, 
                     dbo.Contract.FF_Member_Number, dbo.Contract.IATA_Number, dbo.RT_Rate_Amount.Rate_Name, 
                     dbo.RT_Rate_Amount.Rate_Level,contract.pick_up_location_id




GO
