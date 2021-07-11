USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RateAnalysisReservationRpt]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Apr 11 2002
-- Purpose: 	Report for analyzing rates in reservations made
--		Issue #: 1885
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RateAnalysisReservationRpt]

	@paramStartDate varchar(30)='24 Apr 2002',
	@paramEndDate varchar(30) ='24 Apr 2002',
	@paramLocationID varchar(10) = '16'

as


DECLARE 	@StartDate datetime, 
		@EndDate datetime
		
select  	@StartDate = CONVERT(DATETIME, '00:00' +  @paramStartDate ),
	@EndDate = CONVERT(DATETIME,  '23:59' + @paramEndDate )

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



select	rez.Confirmation_Number,
	rez.Foreign_Confirm_Number,
	rez.source_code,
	rez.status,
	a.Changed_on as 'Booked_on',
	rez.Pick_Up_On,
	l1.location	as Pick_up_location,
	Rental_day = case 	when round(datediff(hh, rez.Pick_Up_On, rez.Drop_Off_On), 1) < 24
				then 1
				else ceiling(datediff(hh, rez.Pick_Up_On, rez.Drop_Off_On) / 24) end,
	vc1.Vehicle_Class_Name,
	r.Rate_name,
	rez.Rate_level,
	rez.guarantee_deposit_amount,
	sum(r.Daily_rate)	as Daily_Rate,
	sum(r.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(r.Weekly_rate)	as Weekly_Rate,
	sum(r.Hourly_rate)	as Hourly_Rate,
	sum(r.Monthly_rate)	as Monthly_Rate
from 
reservation rez
inner join 
	(select distinct Confirmation_Number, Reservation_Change_History.Changed_On
	from Reservation_Change_History 
	where(Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
      						FROM Reservation_Change_History AS rc2
      						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
	)a
	on rez.Confirmation_Number = a.Confirmation_Number
left join
Location l1
	on l1.location_id = rez.Pick_Up_Location_ID
left join 
Vehicle_Class vc1
	on vc1.Vehicle_Class_Code = rez.Vehicle_Class_Code
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
	And RCA.Type = 'Regular'
	And RCA.Termination_Date = 'Dec 31 2078 11:59PM'
	And RTP.Termination_Date = 'Dec 31 2078 11:59PM'
	And RVC.Termination_Date = 'Dec 31 2078 11:59PM')r
	on r.Rate_ID = rez.Rate_id 
	and r.Rate_Level = rez.Rate_level
	and r.Vehicle_Class_Code = rez.Vehicle_Class_Code
	and rez.Date_Rate_Assigned between r.Effective_Date and r.Termination_Date
where	(@paramLocationID = "*" or CONVERT(INT, @tmpLocID) = rez.Pick_Up_Location_ID)
	and rez.Pick_up_on between @StartDate and @EndDate
	and rez.status != 'N'
	and rez.quoted_rate_id is null
group by rez.Confirmation_Number,
	rez.Foreign_Confirm_Number,
	rez.source_code,
	rez.status,
	a.Changed_on,
	rez.Pick_Up_On,
	rez.Drop_Off_On,
	l1.location,
	rez.Pick_Up_On,
	vc1.Vehicle_Class_Name,
	r.Rate_name,
	rez.Rate_level,
	rez.guarantee_deposit_amount
/*order by l1.location, vc1.vehicle_class_name, t.pick_up_on, t.contract_number
COMPUTE COUNT(t.contract_number) by l1.location*/

union

select	rez.Confirmation_Number,
	rez.Foreign_Confirm_Number,
	rez.source_code,
	rez.status,
	a.Changed_on as 'Booked_on',
	rez.Pick_Up_On,
	l1.location	as Pick_up_location,
	Rental_day = case 	when round(datediff(hh, rez.Pick_Up_On, rez.Drop_Off_On), 1) < 24
				then 1
				else ceiling(datediff(hh, rez.Pick_Up_On, rez.Drop_Off_On) / 24) end,
	vc1.Vehicle_Class_Name,
	q.Rate_name,
	Rate_level = null,
	rez.guarantee_deposit_amount,
	sum(q.Daily_rate)	as Daily_rate,
	sum(q.Addnl_Daily_rate)	as Addnl_Daily_Rate,
	sum(q.Weekly_rate)	as Weekly_rate,
	sum(q.Hourly_rate)	as Hourly_rate,
	sum(q.Monthly_rate)	as Monthly_rate
from 
reservation rez
inner join 
	(select distinct Confirmation_Number, Reservation_Change_History.Changed_On
	from Reservation_Change_History 
	where(Reservation_Change_History.Changed_On =  (SELECT MIN(rc2.Changed_On)
      						FROM Reservation_Change_History AS rc2
      						WHERE Reservation_Change_History.Confirmation_Number = rc2.Confirmation_Number))
	)a
	on rez.Confirmation_Number = a.Confirmation_Number
left join
Location l1
	on l1.location_id = rez.Pick_Up_Location_ID
left join 
Vehicle_Class vc1
	on vc1.Vehicle_Class_Code = rez.Vehicle_Class_Code
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
	on q.Quoted_Rate_id = rez.Quoted_Rate_id
where	(@paramLocationID = "*" or CONVERT(INT, @tmpLocID) = rez.Pick_Up_Location_ID)
	and rez.Pick_up_on between @StartDate and @EndDate
	and rez.status != 'N'
	and rez.quoted_rate_id is not null
group by rez.Confirmation_Number,
	rez.Foreign_Confirm_Number,
	rez.source_code,
	rez.status,
	a.Changed_on,
	rez.Pick_Up_On,
	rez.Drop_Off_On,
	l1.location,
	rez.Pick_Up_On,
	vc1.Vehicle_Class_Name,
	q.Rate_name,
	rez.Rate_level,
	rez.guarantee_deposit_amount
order by rez.source_code, r.rate_name, vc1.Vehicle_Class_Name

--COMPUTE COUNT(t.contract_number) by r.rate_name
GO
