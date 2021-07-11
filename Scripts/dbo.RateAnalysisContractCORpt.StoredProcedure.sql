USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RateAnalysisContractCORpt]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Apr 11 2002
-- Purpose: 	Report for analyzing rates in contracts opened
--		Issue #: 1885
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RateAnalysisContractCORpt]

	@paramStartDate varchar(30)='Apr 24 2002',
	@paramEndDate varchar(30) =' Apr 24 2002',
	@paramLocationID varchar(10) = '16'

as


DECLARE 	@StartDate datetime, 
		@EndDate datetime
		
select  	@StartDate = CONVERT(DATETIME,  @paramStartDate ),
	@EndDate = CONVERT(DATETIME,  @paramEndDate)

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

-- end of fixing the problem

--GIS rates
select	t.Contract_Number,
	source_code = case when t.source_code is null
			then 'Walk up'
			else t.source_code
			end,
	woc.User_id as CSR_Name,
	t.Pick_Up_On,
	l1.location	as Pick_up_location,
	--t.Drop_Off_On,
	--l2.location	as Drop_off_location,
	t.Rental_day,
	cci.charge_description,
	cci.unit_amount,
	vc1.Vehicle_Class_Name,
	vc2.Vehicle_Class_Name	as Substitute_Vehicle,
	r.Rate_name,
	t.Rate_level,
	sum(r.Daily_rate)	as Daily_Rate,
	sum(r.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(r.Weekly_rate)	as Weekly_Rate,
	sum(r.Hourly_rate)	as Hourly_Rate,
	sum(r.Monthly_rate)	as Monthly_Rate
from 
(select	c.Contract_Number,
	bt.RBR_date,
	c.Pick_Up_Location_ID,
	c.Pick_Up_On,
	c.Drop_Off_Location_ID,
	c.Drop_Off_On,
	Rental_day = case 	when round(datediff(hh, c.Pick_Up_On, c.Drop_Off_On), 1) < 24
				then 1
				else ceiling(datediff(hh, c.Pick_Up_On, c.Drop_Off_On) / 24)
	end,
	c.Vehicle_Class_Code,
	c.Rate_ID,
	c.Rate_Level,
	c.Quoted_Rate_id,
	c.Sub_Vehicle_Class_Code,
	c.Rate_Assigned_Date,
	rez.source_code
from 	contract c
inner join
business_transaction bt
on bt.contract_number = c.contract_number
left join
reservation rez
on rez.confirmation_number = c.confirmation_number
where	bt.Transaction_Description = 'Check out'
and 	c.Quoted_Rate_id is null
and 	c.status in ('co', 'ci')
) t
left join 
(select * from contract_charge_item
where charge_description like '%upg%' ) cci
on t.contract_number = cci.contract_number
left join
Location l1
	on l1.location_id = t.Pick_Up_Location_ID
left join 
Location l2
	on l2.location_id = t.Drop_Off_Location_ID
left join 
Vehicle_Class vc1
	on vc1.Vehicle_Class_Code = t.Vehicle_Class_Code
left join
Vehicle_Class vc2
	on vc2.Vehicle_Class_Code = t.Sub_Vehicle_Class_Code
left join 
(Select Distinct
	VR.Rate_Name,
	RCA.Rate_ID,
	RCA.Rate_Level, 
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
	And RCA.Type = "Regular"
	And RCA.Termination_Date = "Dec 31 2078 11:59PM"
	And RTP.Termination_Date = "Dec 31 2078 11:59PM"
	And RVC.Termination_Date = "Dec 31 2078 11:59PM")r
	on r.Rate_ID = t.Rate_id 
	and r.Rate_Level = t.Rate_level
	and r.Vehicle_Class_Code = t.Vehicle_Class_Code
	and t.Rate_Assigned_Date between r.Effective_Date and r.Termination_Date
left join 
RP__CSR_Who_Opened_The_Contract woc
on woc.contract_number = t.contract_number
where	(@paramLocationID = "*" or CONVERT(INT, @tmpLocID) = t.Pick_Up_Location_ID)
	and t.RBR_date between @StartDate and @EndDate
group by t.Contract_Number,
	t.source_code,
	woc.User_id,
	t.Pick_Up_On,
	l1.location,
	t.Drop_Off_On,
	l2.location,
	t.Rental_day,
	cci.charge_description,
	cci.unit_amount,
	vc1.Vehicle_Class_Name,
	vc2.Vehicle_Class_Name,
	r.Rate_name,
	t.Rate_level
/*order by l1.location, vc1.vehicle_class_name, t.pick_up_on, t.contract_number
COMPUTE COUNT(t.contract_number) by l1.location*/

union

--Maestro rates
select	t.Contract_Number,
	source_code = case when t.source_code is null
			then 'Walk up'
			else t.source_code
			end,
	woc.User_id as CSR_Name,
	t.Pick_Up_On,
	l1.location	as Pick_up_location,
	--t.Drop_Off_On,
	--l2.location	as Drop_off_location,
	t.Rental_day,
	cci.charge_description,
	cci.unit_amount,
	vc1.Vehicle_Class_Name,
	vc2.Vehicle_Class_Name	as Substitute_Vehicle,
	q.Rate_name,
	Rate_level = null,
	sum(q.Daily_rate)	as Daily_rate,
	sum(q.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(q.Weekly_rate)	as Weekly_rate,
	sum(q.Hourly_rate)	as Hourly_rate,
	sum(q.Monthly_rate)	as Monthly_rate
from 
(select	c.Contract_Number,
	bt.RBR_date,
	c.Pick_Up_Location_ID,
	c.Pick_Up_On,
	c.Drop_Off_Location_ID,
	c.Drop_Off_On,
	Rental_day = case 	when round(datediff(hh, c.Pick_Up_On, c.Drop_Off_On), 1) < 24
				then 1
				else ceiling(datediff(hh, c.Pick_Up_On, c.Drop_Off_On) / 24)
	end,
	c.Vehicle_Class_Code,
	c.Rate_ID,
	c.Rate_Level,
	c.Quoted_Rate_id,
	c.Sub_Vehicle_Class_Code,
	rez.source_code
from 	contract c
inner join
business_transaction bt
on bt.contract_number = c.contract_number
left join 
reservation rez
on rez.confirmation_number = c.confirmation_number
where	bt.Transaction_Description = 'Check out'
and 	c.Quoted_Rate_id is not null
and 	c.status in ('co', 'ci')
) t
left join 
(select * from contract_charge_item
where charge_description like '%upg%' ) cci
on t.contract_number = cci.contract_number
left join
Location l1
	on l1.location_id = t.Pick_Up_Location_ID
left join 
Location l2
	on l2.location_id = t.Drop_Off_Location_ID
left join 
Vehicle_Class vc1
	on vc1.Vehicle_Class_Code = t.Vehicle_Class_Code
left join
Vehicle_Class vc2
	on vc2.Vehicle_Class_Code = t.Sub_Vehicle_Class_Code
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
	on q.Quoted_Rate_id = t.Quoted_Rate_id
left join 
RP__CSR_Who_Opened_The_Contract woc
on woc.contract_number = t.contract_number
where	(@paramLocationID = "*" or CONVERT(INT, @tmpLocID) = t.Pick_Up_Location_ID)
	and t.RBR_date between @StartDate and @EndDate
group by t.Contract_Number,
	t.source_code,
	woc.User_id,
	t.Pick_Up_On,
	l1.location,
	t.Drop_Off_On,
	l2.location,
	t.Rental_day,
	cci.charge_description,
	cci.unit_amount,
	vc1.Vehicle_Class_Name,
	vc2.Vehicle_Class_Name,
	q.Rate_name,
	t.Rate_level
order by t.source_code, r.rate_name, vc1.Vehicle_Class_Name

--COMPUTE COUNT(t.contract_number) by r.rate_name
GO
