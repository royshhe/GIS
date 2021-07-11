USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTrackingRptForGov]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




-----------------------------------------------------------------------------------------
--  Programmer:     Jack Jian
--  Date:                Aug 15, 2001
--  Details:             Create tracker report for gov
--  Tracker Issue:  1866
-----------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetTrackingRptForGov]

       @MonStartDate varchar(30)='Jan 01 2000',
       @MonEndDate varchar(30)='Dec 31 2000'

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate ) + 1

-- create report tables 
create table #tmp_contract
( contract_number int,
  rate_name varchar(25)
)

create table #tmp_timecharge
(
 contract_number int,
 tamount decimal(9,2)
)


create table #tmp_kmcharge
( contract_number int,
  kamount decimal(9,2)
)

create table #tmp_kmdriven
( contract_number int,
  kmdriven int,
  actualdays int
)

--Specify the date

insert into #tmp_contract
select distinct con.contract_number, vr.rate_name
from contract con
INNER JOIN vehicle_rate vr
 ON vr.rate_id =con.rate_id
 and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
/* and vr.rate_name in 
('01i', '02i', 'p9a','p9d','pbc00','pbc00a','pbc00b','pbc00c','pbc00d','pbc00e','pbc00f','pbc00g','pbc00h','pbc00i','pbc001','pbc01A','pbc01C','pbc01H','pbcm01','pbcm01A')*/
and vr.rate_purpose_id = 7
and Not (vr.rate_name like '%Fed%') --('FED01', 'FED01A' , 'FED02', 'FED02A')  
and vr.rate_name not like '%FEDERAL%'
and con.status='CI'
and con.last_update_on >= @StartDate
and con.last_update_on < @EndDate
order by con.contract_number

/*get the Time Charge */
insert into #tmp_timecharge 
	select contract_number,sum(amount)
	from contract_charge_item 
	where contract_number in (select contract_number from #tmp_contract )
        and charge_type='10'
        group by contract_number
        order by contract_number


/*get the Km Charge */
insert into #tmp_kmcharge
	select contract_number,sum(amount)
	from contract_charge_item 
	where contract_number in (select contract_number from #tmp_contract ) 
        and charge_type='11'
        group by contract_number
        order by contract_number

/*get the KM driven */
insert into #tmp_kmdriven
       select contract_number,kmdriven=(sum(km_in)-sum(km_out)),
       days=ceiling((DATEDIFF(mi, min(checked_out),max(actual_check_in)) / 1440.0))
       from vehicle_on_contract
       where contract_number in (select contract_number from #tmp_contract )
       group by contract_number
       order by contract_number

select con.contract_number,con.company_name,loc.location,kd.actualdays,tcon.rate_name,
tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
join location loc
ON  
loc.location_id =con.pick_up_location_id
left join #tmp_kmcharge kmc
on kmc.contract_number=con.contract_number
left join #tmp_timecharge tc
on tc.contract_number=con.contract_number
left join #tmp_kmdriven kd
on kd.contract_number=con.contract_number
order by loc.location, con.company_name
GO
