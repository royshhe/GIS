USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Get3MRpt]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Mar 04 2002
-- Purpose: 	To create a report for all contracts of 3M Canada Inc.
--------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[Get3MRpt]

       @MonStartDate varchar(30)='Jan 01 2000',
       @MonEndDate varchar(30)='Dec 31 2000'

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate ) 

-- create report tables 
create table #tmp_contract
( contract_number int
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

create table #tmp_optionalextra
( contract_number int,
  All_Level_LDW decimal(9,2),
  PAI decimal(9,2),
  PEC decimal(9,2)  
)

--Specify the date

insert into #tmp_contract
select con.contract_number
from contract con
where (con.company_name like '3M%' 
	or con.BCD_Rate_Organization_ID = 
		(select Organization_ID from organization where organization like '3M%'))
and con.status='CI'
and con.pick_up_on between @StartDate and @EndDate
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

/*get all optional extra items*/
insert into #tmp_optionalextra
	select contract_number, 
	sum(case	when Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40)
		then Amount	else 0		end)			as All_Level_LDW,
	sum(case 	when Optional_Extra_ID = 20	
		then Amount	else 0		end)			as PAI,
	sum(case 	when Optional_Extra_ID = 21 	
		then Amount	else 0		end)			as PEC
from 	contract_charge_item
where contract_number in (select contract_number from #tmp_contract ) 
group by	Contract_number

select 	con.pick_up_on, 
	con.contract_number,
	con.company_name,
	loc.location,
	kd.actualdays,
	rate_name = case when vr.rate_name is null
			then qr.rate_name
			else vr.rate_name
			end,
	tc.tamount,
	kmc.kamount,
	kd.kmdriven,
All_Level_LDW, PAI, PEC
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
left join #tmp_optionalextra op
on op.contract_number = con.contract_number
left JOIN vehicle_rate vr
 ON vr.rate_id =con.rate_id
 and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join quoted_vehicle_rate qr
on qr.quoted_rate_id = con.quoted_rate_id
order by con.Pick_up_on, loc.location
GO
