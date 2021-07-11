USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Rates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE view [dbo].[Contract_Rates]
as 
select 	con.contract_number,
	rate.rate_name,
	rate.rate_level,
	sum(rate.Daily_rate)		as Daily_Rate,
	sum(rate.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(rate.Weekly_rate)		as Weekly_Rate
from contract con
inner join
(Select Distinct
	VR.Rate_Name,
	RCA.Rate_ID,
	RCA.Rate_Level,
	VR.Rate_purpose_id, 
	RVC.Vehicle_Class_Code,
	VR.Effective_date,
	VR.Termination_date,
	Daily_rate = case when (RTP.Time_Period = 'Day' and RTP.Time_Period_Start = 1)
			then RCA.Amount  
			else 0.0
	end,
	Addnl_Daily_rate = case when (RTP.Time_Period = 'Day' and RTP.Time_Period_Start != 1) --or RTP.Time_Period = 'Day'
			then RCA.Amount  
			else 0.0
	end,
	Weekly_rate = case RTP.Time_Period
			when 'Week'
			then RCA.Amount
			else 0.0
	end,
	Hourly_rate = case RTP.Time_Period
			when 'Hour'
			then RCA.Amount
			else 0.0
	end,
	Monthly_rate = case RTP.Time_Period 
			when 'Month'
			then RCA.Amount
			else 0.0
	end
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
	And RCA.Termination_Date = '2078-12-31 23:59'
	And RTP.Termination_Date = '2078-12-31 23:59'
	And RVC.Termination_Date = '2078-12-31 23:59'
)rate
on rate.Rate_ID = con.Rate_id 
and rate.Rate_Level = con.Rate_level
and rate.Vehicle_Class_Code = con.Vehicle_Class_Code
and con.Rate_Assigned_Date between rate.Effective_Date and rate.Termination_Date
where con.status not in ('VD', 'CA')
and 	con.Quoted_Rate_id is null
group by con.contract_number,
	rate.rate_name,
	rate.rate_level

union

select 	con.contract_number,
	q.Rate_name,
	Rate_level = null,
	sum(q.Daily_rate)	as Daily_rate,
	sum(q.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(q.Weekly_rate)	as Weekly_rate
from contract con
left join
(select q1.Quoted_Rate_ID,
	q1.Rate_name,
	Daily_rate = case when (q2.Time_Period = 'Day' and q2.Time_Period_Start = 1)
			then q2.Amount  
			else 0.0
	end,
	Addnl_Daily_rate = case when q2.Time_Period = 'Day' and  q2.Time_Period_Start != 1
			then q2.Amount  
			else 0.0
	end,
	Weekly_rate = case q2.Time_Period
			when 'Week'
			then q2.Amount
			else 0.0
	end,
	Hourly_rate = case q2.Time_Period
			when 'Hour'
			then q2.Amount
			else 0.0
	end,
	Monthly_rate = case q2.Time_Period 
			when 'Month'
			then q2.Amount
			else 0.0
	end
	from Quoted_Vehicle_Rate q1
	left join
	Quoted_Time_Period_Rate q2
		on q1.Quoted_Rate_ID = q2.Quoted_Rate_ID) q
on q.Quoted_Rate_id = con.Quoted_Rate_id
where con.status not in ('VD', 'CA')
and 	con.Quoted_Rate_id is not null
group by con.contract_number,
	q.rate_name



GO
