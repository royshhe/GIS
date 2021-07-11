USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTrackingRptForCorporateCustomer]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------------
--  Programmer:     Vivian Leung	
--  Date:           01 Apr 2002
--  Details:        Create tracker report for BC Rail
-----------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetTrackingRptForCorporateCustomer]

       @CustomerName varchar(30),
       @MonStartDate varchar(30)='Jan 01 2000',
       @MonEndDate varchar(30)='Dec 31 2000'

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate ) + 1

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

--Specify the date

insert into #tmp_contract
	select distinct voc.contract_number
	from vehicle_on_contract voc 
	inner join contract con
	on con.contract_number = voc.contract_number 
	and con.company_name like '%'+@CustomerName+'%'
	and con.status = 'CI'
	group by voc.contract_number 
	having max(voc.Actual_Check_In) between @StartDate  and @EndDate

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

select tcon.contract_number,con.pick_up_on,loc.location,con.last_name,
con.first_name, vc.Model_Name, kd.actualdays,tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
inner join contract con
on tcon.contract_number = con.contract_number
left join location loc
on loc.location_id =con.pick_up_location_id
left join RP__Last_Vehicle_On_Contract rlvoc
on rlvoc.contract_number = tcon.contract_number
left join vehicle v
on v.unit_number = rlvoc.unit_number
left join vehicle_model_year vc
on v.Vehicle_Model_ID = vc.Vehicle_Model_ID
left join #tmp_kmcharge kmc
on kmc.contract_number=con.contract_number
left join #tmp_timecharge tc
on tc.contract_number=con.contract_number
left join #tmp_kmdriven kd
on kd.contract_number=con.contract_number
order by con.pick_up_on,loc.location




GO
