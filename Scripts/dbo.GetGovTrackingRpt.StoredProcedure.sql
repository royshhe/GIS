USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGovTrackingRpt]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Create Govement tracking report for AR
CREATE Procedure [dbo].[GetGovTrackingRpt]
       @MonStartDate varchar(30)='Apr 01 2000',
       @MonEnddate varchar(30)='Jun 30 2000'
     
AS
-- Drop all temp tables
drop table #tmp_contract
drop table #tmp_timecharge
drop table #tmp_kmcharge
drop table #tmp_kmdriven

-- Caubo tracking
DECLARE @qryMonStartDate datetime, @qryMonEnddate datetime

create table #tmp_contract
( contract_number int,
  actual_check_in datetime
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




SELECT @qryMonStartDate=CONVERT(DATETIME,@MonStartDate)
SELECT @qryMonEndDate=dateadd(dd,1,CONVERT(DATETIME,@MonEnddate))

INSERT INTO #tmp_contract
SELECT distinct VOC.CONTRACT_NUMBER, MAX(VOC.ACTUAL_CHECK_IN)
FROM VEHICLE_ON_CONTRACT VOC
INNER JOIN CONTRACT CON
ON CON.CONTRACT_NUMBER=VOC.CONTRACT_NUMBER
left JOIN vehicle_rate vr
ON vr.rate_id =con.rate_id
and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join quoted_vehicle_rate qr
on qr.quoted_rate_id = con.quoted_rate_id
/* and vr.rate_name in 
('01i', '02i', 'p9a','p9d','pbc00','pbc00a','pbc00b','pbc00c','pbc00d','pbc00e','pbc00f','pbc00g','pbc00h','pbc00i','pbc001','pbc01A','pbc01C','pbc01H','pbcm01','pbcm01A')*/
where (vr.rate_purpose_id = 7
and vr.rate_name not in ('FED02', 'FED02A', 'Fed03AP', 'FEd03Local')  
and vr.rate_name not like '%FED%Gov' and vr.rate_name not like '%FED03%' and vr.rate_name not like '%FED04%')
or (CON.COMPANY_NAME like '%BCIT%' or
    CON.COMPANY_NAME like '%VCC%' or 
    CON.COMPANY_NAME like '%Vancouver Community college%' or 
    CON.COMPANY_NAME like '%TWU%' or 
    CON.COMPANY_NAME like '%Trinity Western university%' or
    CON.COMPANY_NAME like '%SFU%' or 
    CON.COMPANY_NAME like '%Simon Fraser university%' or
    CON.COMPANY_NAME like '%Simon Fraser%' or
    CON.COMPANY_NAME like '%UBC%' or
    CON.COMPANY_NAME like '%University of BC%' or 
    CON.COMPANY_NAME like '%University of B%C%' or 
    CON.COMPANY_NAME like '%UNBC%' or
    CON.COMPANY_NAME like '%Univ. of northern B.C.%' or 
    CON.COMPANY_NAME like '%Univ of northern BC%' or
    CON.COMPANY_NAME like '%U%of nor%BC%' or	
    CON.COMPANY_NAME like '%Uvic%' or
    CON.COMPANY_NAME like '%Univ% of %Vic%' or
    CON.COMPANY_NAME like '%University of Vic%' or
    CON.COMPANY_NAME like '%University of Victoria%' or
    CON.COMPANY_NAME like '%Douglas college%' or 
    CON.COMPANY_NAME like '%Kwantlen%' or
    CON.COMPANY_NAME like '%Camosun college%' or
    CON.COMPANY_NAME like '%Okanagan u%' or 
    CON.COMPANY_NAME like '%Okanagan university college%' or
    CON.COMPANY_NAME like '%Okanagan college%' or 
    Con.Company_name like 'O% univ coll%' or
    CON.COMPANY_NAME like '%Open learning agency%' or
    --BC Hydro
    Con.Company_name like '%BC%Hydro%' or
    con.BCD_Rate_Organization_ID in 
		(select Organization_ID from organization where organization like 'BC%hy%') or
    --BC Rail
    Con.Company_name like '%BC%Rail%' or
    con.BCD_Rate_Organization_ID in 
		(select Organization_ID from organization where organization like 'BC%Ra%') or
    -- Provincial Gov
    con.company_name like '%BC%prov%' or
    con.company_name like 'Prov%BC%' or
    con.company_name like 'BC%Gov%' or
    con.BCD_Rate_Organization_ID in 
		(select Organization_ID from organization where organization like 'BC%Gov%') or
    con.BCD_Rate_Organization_ID in 
		(select Organization_ID from organization where organization like '%BC%prov%') or
    -- icbc
    con.company_name like 'icbc%' /*or
     con.BCD_Rate_Organization_ID in
		(select Organization_ID from organization where organization like 'icbc%')*/)

-- for Maestro rates
or  (qr.Rate_Purpose_ID = 5 and qr.rate_name = '01i')
AND CON.STATUS='CI'
GROUP BY VOC.CONTRACT_NUMBER
HAVING MAX(VOC.ACTUAL_CHECK_IN) BETWEEN @qryMonStartDate AND @qryMonEndDate
ORDER BY voc.contract_number

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
       select contract_number,
		kmdriven=case when (sum(km_in)-sum(km_out)) < 5
			 then 50
			 else (sum(km_in)-sum(km_out))
			 end,
       days=ceiling((DATEDIFF(mi, min(checked_out),max(actual_check_in)) / 1440.0))
       from vehicle_on_contract
       where contract_number in (select contract_number from #tmp_contract )
       group by contract_number
       order by contract_number 
 
--output
--PRINT '--------------------- Tracking Report For CAUBO ----------------------'
--PRINT '*** Reporting Period From: Oct 01 2001 To: Oct 31 2001                           ***' 
--PRINT '*** Generated At: ' + CONVERT(VARCHAR(30), GETDATE())+'                                            ***'
--PRINT ''

 select con.contract_number,con.company_name,loc.location,kd.actualdays,vr.rate_name,
tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is not null
and con.status = 'CI'
INNER join location loc
ON  
loc.location_id =con.pick_up_location_id
INNER JOIN vehicle_rate vr
ON  vr.rate_id=con.rate_id
AND con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join #tmp_kmcharge kmc
on kmc.contract_number=con.contract_number
left join #tmp_timecharge tc
on tc.contract_number=con.contract_number
left join #tmp_kmdriven kd
on kd.contract_number=con.contract_number
 
 

UNION

select con.contract_number,con.company_name,loc.location,kd.actualdays,qvr.rate_name,
tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is null
and con.status = 'CI'
INNER join location loc
ON  
loc.location_id =con.pick_up_location_id
INNER JOIN quoted_vehicle_rate qvr
ON  qvr.quoted_rate_id=con.quoted_rate_id
--AND con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join #tmp_kmcharge kmc
on kmc.contract_number=con.contract_number
left join #tmp_timecharge tc
on tc.contract_number=con.contract_number
left join #tmp_kmdriven kd
on kd.contract_number=con.contract_number

order by loc.location, con.company_name, con.contract_number

compute count(con.contract_number), sum(kd.actualdays), sum(tc.tamount), sum(kmc.kamount), sum(kd.kmdriven)by loc.location
SET NOCOUNT OFF 
GO
