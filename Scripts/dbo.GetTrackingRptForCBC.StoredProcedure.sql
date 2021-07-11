USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTrackingRptForCBC]    Script Date: 2021-07-10 1:50:49 PM ******/
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


CREATE PROCEDURE [dbo].[GetTrackingRptForCBC] --'2004-06-01', '2004-10-23'

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
Inner Join Business_transaction BusTrans on
BusTrans.Contract_number = con.Contract_number
Left JOIN vehicle_rate vr
 ON vr.rate_id =con.rate_id
 and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
 LEFT OUTER JOIN
 dbo.Reservation ON con.Confirmation_Number = dbo.Reservation.Confirmation_Number
where  con.status='CI'
and BusTrans.rbr_date >= @StartDate
and BusTrans.rbr_date < @EndDate
and
(BusTrans.Transaction_Type = 'con') 
AND 
(BusTrans.Transaction_Description = 'check in') 
AND 
con.Status not in ('vd', 'ca')
and 
(
--Con.BCD_Rate_Organization_ID in (134,342)
--or  
(Con.Company_Name like 'CBC%')
or (dbo.Reservation.BCD_Number='A159600')
)
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

select distinct con.contract_number,

/*CompanyName =(case
 when Org.Organization is null then con.company_name
 else Org.Organization
End)
,*/
con.company_name, Org.Organization,
loc.location,kd.actualdays,tcon.rate_name,
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
left join Organization Org 
on Org.Organization_id = Con.BCD_Rate_Organization_ID
order by loc.location, con.company_name

GO
