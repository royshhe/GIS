USE [GISData]
GO
/****** Object:  View [dbo].[RT_Rate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RT_Rate_Amount]
AS

Select Distinct
        VR.Rate_ID,
	VR.Rate_Name,
	RCA.Rate_Level,
	VR.Rate_purpose_id, 
	RVC.Vehicle_Class_Code,
	VR.Effective_date VREffectiveDate,
	VR.Termination_date VRTerminationDate,
        RCA.Effective_date RCAEffectiveDate,
        RCA.Termination_Date RCATerminationDate,
	RTP.Effective_date RTPEffectiveDate,
	RTP.Termination_Date RTPTerminationDate,
	RVC.Termination_Date RVCTerminationDate,
	RVC.Effective_date RVCEffectiveDate,
        RCA.Amount,
        RTP.Time_Period,
	RTP.Time_Period_Start,
	RTP.Time_Period_End,
	RTP.KM_Cap

	/*Daily_rate = sum(case when (RTP.Time_Period = 'Day' and RTP.Time_Period_Start = 1)
			then RCA.Amount  
			else 0.0
	end),
	Addnl_Daily_rate = sum(case when (RTP.Time_Period = 'Day' and RTP.Time_Period_Start != 1) --or RTP.Time_Period = 'Day'
			then RCA.Amount  
			else 0.0
	end),
	Weekly_rate = sum(case RTP.Time_Period
			when 'Week'
			then RCA.Amount
			else 0.0
	end),
	Hourly_rate = sum(case RTP.Time_Period
			when 'Hour'
			then RCA.Amount
			else 0.0
	end),
	Monthly_rate = sum(case RTP.Time_Period 
			when 'Month'
			then RCA.Amount
			else 0.0
	end)*/
From
	Vehicle_Rate VR,
	Rate_Time_Period RTP,
	Rate_Vehicle_Class RVC,
	Rate_Charge_Amount RCA
Where	VR.Rate_ID = RCA.Rate_ID
	And RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID
	And RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID
	and RTP.Type = RCA.Type
	And RCA.Rate_ID = RVC.Rate_ID
	And RCA.Rate_ID = RTP.Rate_ID
	And RCA.Type = 'Regular'
/*group by VR.Rate_ID,
	VR.Rate_Name,
	RCA.Rate_Level,
	VR.Rate_purpose_id, 
	RVC.Vehicle_Class_Code,
	VR.Effective_date ,
	VR.Termination_date ,
        RCA.Effective_date ,
        RCA.Termination_Date ,
	RTP.Effective_date ,
	RTP.Termination_Date ,
	RVC.Termination_Date ,
	RVC.Effective_date ,
	RTP.Time_Period
*/
GO
