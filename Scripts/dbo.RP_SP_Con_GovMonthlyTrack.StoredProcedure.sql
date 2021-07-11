USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_GovMonthlyTrack]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[RP_SP_Con_GovMonthlyTrack]  --'01 Mar 2007','31 Mar 2007'
(
@StartDateInput varchar(20) = '01 Mar 2007',
@EndDateInput varchar(20) = '31 Mar 2007'
)
AS 
SET NOCOUNT ON

Declare @qryMonStartDate datetime
Declare @qryMonEndDate datetime

SELECT @qryMonStartDate=CONVERT(DATETIME,@StartDateInput)
SELECT @qryMonEndDate=dateadd(dd,1,CONVERT(DATETIME,@EndDateInput))


-- Drop all temp tables
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_contract]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmp_contract]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_timecharge]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmp_timecharge]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_kmcharge]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmp_kmcharge]
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_kmdriven]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tmp_kmdriven]

--drop table #tmp_contract
--drop table #tmp_timecharge
--drop table #tmp_kmcharge
--drop table #tmp_kmdriven

-- Caubo tracking

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



INSERT INTO #tmp_contract
SELECT distinct VOC.CONTRACT_NUMBER, MAX(VOC.ACTUAL_CHECK_IN)
FROM VEHICLE_ON_CONTRACT VOC
INNER JOIN CONTRACT CON
ON CON.CONTRACT_NUMBER=VOC.CONTRACT_NUMBER
left join Organization ORG on CON.BCD_Rate_Organization_ID = ORG.Organization_ID
left JOIN vehicle_rate vr ON vr.rate_id =con.rate_id
and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join quoted_vehicle_rate qr on qr.quoted_rate_id = con.quoted_rate_id
where 
    ORG.BCD_Number = 'A162000' --BC Provincial Government BCD
OR  vr.rate_name like 'pbc%' or vr.rate_name like 'bc%'	-- Elegable local rates
-- Maestro rates
OR  (qr.rate_name = '01i')
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
tc.tamount,kmc.kamount,kd.kmdriven, dbo.Vehicle_Class.Vehicle_Class_Name
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is not null
and con.status = 'CI'
INNER JOIN
dbo.Vehicle_Class ON con.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
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
tc.tamount,kmc.kamount,kd.kmdriven,dbo.Vehicle_Class.Vehicle_Class_Name
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is null
and con.status = 'CI'
INNER JOIN
dbo.Vehicle_Class ON con.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
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

--compute count(con.contract_number), sum(kd.actualdays), sum(tc.tamount), sum(kmc.kamount), sum(kd.kmdriven)by loc.location
SET NOCOUNT OFF
GO
