USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_12_CSR_Walkup_Incentive_L2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[RP_Acc_12_CSR_Walkup_Incentive_L2]

as

select	t.Contract_Number,
	t.Foreign_contract_number,
	t.RBR_date,
	woc.User_id 		as CSR_Name,
	t.Pick_Up_On,
	t.Pick_up_location_id,
	l1.location		as Pick_up_location,
	vbr.rentaldays,
	vc1.Vehicle_Class_Name,
	vbr.BaseRate,
	vbr.BaseAmount,
	r.Rate_name		as Contract_Rate,
	t.Rate_level,
	rr.Rental_Revenue,
	sum(r.Daily_rate)		as Contract_Daily_Rate,
	sum(r.Addnl_Daily_rate)	as Contract_Addnl_Daily_Rate,
	sum(r.Weekly_rate)	as Contract_Weekly_Rate,
	sum(r.Hourly_rate)	as Contract_Hourly_Rate,
	sum(r.Monthly_rate)	as Contract_Monthly_Rate,
	Upsell_Difference = 	case when rr.Rental_Revenue > vbr.BaseAmount
				and r.Rate_purpose_id = 13 -- Standard rates only
				and r.Rate_name not like 'm-%'
				and r.Rate_name not like 'WJ%'
				and r.rate_name not like 'One%Way%'
				and r.rate_name not like 'M-One%Way%'
				then rr.Rental_Revenue - vbr.BaseAmount
				else 0
				end
from 
(select	c.Contract_Number,
	c.Foreign_contract_number,
	bt.RBR_date,
	c.Pick_Up_Location_ID,
	c.Pick_Up_On,
	c.Drop_Off_Location_ID,
	--Rental_day = master.dbo.GetRentalDays(datediff (mi, c.Pick_Up_On, rlv.Actual_Check_In)/60),
	c.Vehicle_Class_Code,
	c.Rate_ID,
	c.Rate_Level,
	c.Quoted_Rate_id,
	c.Rate_Assigned_Date,
	rez.source_code
from 	contract c
inner join
business_transaction bt
on bt.contract_number = c.contract_number
left join
reservation rez
on rez.confirmation_number = c.confirmation_number
where	bt.Transaction_Description = 'Check in'
and 	c.Quoted_Rate_id is null
and 	c.Status not in ('vd', 'ca')
) t
left join
Location l1
	on l1.location_id = t.Pick_Up_Location_ID
left join 
Vehicle_Class vc1
	on vc1.Vehicle_Class_Code = t.Vehicle_Class_Code
left join 
ViewContractRateBaseAmount vbr
	on vbr.contract_number = t.contract_number
left join 
RP__CSR_Who_Opened_The_Contract woc
	on woc.contract_number = t.contract_number
left join
RP_Acc_12_CSR_Incentive_Report_L2 rr
	on rr.contract_number = t.contract_number
left join 
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
	And RVC.Termination_Date = '2078-12-31 23:59')r
	on r.Rate_ID = t.Rate_id 
	and r.Rate_Level = t.Rate_level
	and r.Vehicle_Class_Code = t.Vehicle_Class_Code
	and t.Rate_Assigned_Date between r.Effective_Date and r.Termination_Date
where	--(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = t.Pick_Up_Location_ID)
	--and t.RBR_date >= @StartDate and t.RBR_date < @EndDate
	t.source_code is null
	and vc1.vehicle_type_id = 'Car'
group by t.Contract_Number,
	t.Foreign_contract_number,
	t.RBR_date,
	woc.User_id,
	t.Pick_Up_On,
	t.Pick_up_location_id,
	l1.location,
	vbr.Rentaldays,
	vc1.Vehicle_Class_Name,
	vbr.BaseRate,
	vbr.BaseAmount,
	r.Rate_name,
	t.Rate_level,
	r.Rate_purpose_id,
	rr.Rental_Revenue

--order by l1.location, woc.User_id, vc1.Vehicle_Class_Name, r.rate_name



GO
