USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTrackingRpt]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* 
Purpose: This is only a temporary solution for tracking report 
	Once the requirement is finialized, 
	a more friendly interface would be introduced to generate this report
Author: LQ 
*/
--drop procedure GetTrackingRpt
CREATE Procedure [dbo].[GetTrackingRpt]
       @MonStartDate varchar(30)='Apr 01 2000',
       @MonEndDate varchar(30)='Jun 30 2000',
       @CompanyName varchar(30) ='Jim Pattison Group'
AS
set nocount on 
execute CreateTrackingRptTbl

/* get the contract info */
/*,con.company_name,con.pick_up_location_id,con.pick_up_on,con.drop_off_on*/
 
DECLARE @qryMonStartDate datetime, @qryMonEnddate datetime
 
/*
SELECT @MonStartDate ='Apr 01 2000'
SELECT @MonEndDate ='Jun 30 2000'
SELECT @CompanyName='ubc'  --specify the name here
*/

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
SELECT @qryMonEndDate=dateadd(dd,1,CONVERT(DATETIME,@MonEndDate))

INSERT INTO #tmp_contract
SELECT VOC.CONTRACT_NUMBER, MAX(VOC.ACTUAL_CHECK_IN)
FROM VEHICLE_ON_CONTRACT VOC
INNER JOIN CONTRACT CON
ON CON.CONTRACT_NUMBER=VOC.CONTRACT_NUMBER
AND (CON.COMPANY_NAME  like @CompanyName 
or con.BCD_Rate_Organization_ID in 
		--(select Organization_ID from organization where organization like '%' + @CompanyName + '%')
		(select Organization_ID from organization where organization like @CompanyName )
)
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
       select contract_number,kmdriven=(sum(km_in)-sum(km_out)),
       days=ceiling((DATEDIFF(mi, min(checked_out),max(actual_check_in)) / 1440.0))
       from vehicle_on_contract
       where contract_number in (select contract_number from #tmp_contract )
       group by contract_number
       order by contract_number 
 
--output
--PRINT '--------------------- Tracking Report For '+@CompanyName+'  ----------------------'
--PRINT '*** Reporting Period From: '+@MonStartDate +' To: '+@MonEndDate +'                           ***' 
--PRINT '*** Generated At: ' + CONVERT(VARCHAR(30), GETDATE())+'                                            ***'
--PRINT ''

 select con.contract_number,con.company_name,  --con.vehicle_class_code,
loc.location,kd.actualdays,vr.rate_name,
tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is not null
INNER join location loc
ON  
loc.location_id =con.pick_up_location_id
left JOIN vehicle_rate vr
ON  vr.rate_id=con.rate_id
AND con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
left join #tmp_kmcharge kmc
on kmc.contract_number=con.contract_number
left join #tmp_timecharge tc
on tc.contract_number=con.contract_number
left join #tmp_kmdriven kd
on kd.contract_number=con.contract_number
/*where con.vehicle_class_code in (
select Vehicle_Class_Code from vehicle_class
where Vehicle_Type_ID = 'Truck')*/
 
 

UNION

select con.contract_number,con.company_name, --con.vehicle_class_code,
loc.location,kd.actualdays,qvr.rate_name,
tc.tamount,kmc.kamount,kd.kmdriven
from #tmp_contract tcon
INNER JOIN 
contract con
ON con.contract_number=tcon.contract_number
and con.rate_id is null
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
/*where con.vehicle_class_code in (
select Vehicle_Class_Code from vehicle_class
where Vehicle_Type_ID = 'Truck')*/		
 
set nocount off

return
GO
