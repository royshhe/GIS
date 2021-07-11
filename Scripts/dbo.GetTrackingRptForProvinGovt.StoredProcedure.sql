USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTrackingRptForProvinGovt]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Mar 04 2002
-- Purpose: 	To create a report for all contracts with Provincial Gov't Rates
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetTrackingRptForProvinGovt]

       @MonStartDate varchar(30),
       @MonEndDate varchar(30)

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate )

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

-- create report tables 
create table #tmp_GIScontract
( contract_number int,
  RBR_date datetime,
  Rate_name varchar(25),
  location varchar(25),
  company_name varchar(50)
)

create table #tmp_MaestroContract
( contract_number int,
  RBR_date datetime,
  Rate_name varchar(25),
  location varchar(25),
  company_name varchar(50)
)

create table #tmp_contract
( contract_number int,
  RBR_date datetime,
  Rate_name varchar(25),
  location varchar(25),
  company_name varchar(50)
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
  actualdays decimal(9,2)
)

create table #tmp_rate
( rate_id int,
  Rate_name varchar(25),
  Effective_date datetime,
  Termination_date datetime
)


--Specify the date

/* Get all contracts with GIS Provincial Govt rates*/
insert into #tmp_GIScontract
	select distinct con.contract_number, bt.Rbr_date,  vr.rate_name, loc.location, con.company_name
	from contract con
	inner join business_transaction bt
	on con.contract_number = bt.contract_number
	and bt.Transaction_Description='check in'
	and bt.RBR_Date between @StartDate and @MonEndDate --@StartDate and @EndDate
	INNER JOIN vehicle_rate vr
 	ON vr.rate_id =con.rate_id
 	and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
 	and vr.rate_name in /*ike 'pbc%'*/
	('01i', '02i', 'p9a','p9d','pbc00','pbc00a','pbc00b','pbc00c','pbc00d','pbc00e','pbc00f','pbc00g',
	'pbc00h','pbc00i','pbc01','pbc01A','pbc01C','pbc01H','pbcm01','pbcm01A', 'pbc02A', 'pbc02',
	'pbc02C', 'pbc02h', 'pbcm02', 'pbcm02a')
	inner join location loc
		on loc.location_id = con.pick_up_location_id
		and loc.owning_company_id  = @CompanyCode
	order by con.contract_number


/* get all contracts with Quoted provincial rates*/
insert into #tmp_MaestroContract
	select distinct con.contract_number, bt.Rbr_date,  qr.rate_name, loc.location, con.company_name
	from contract con
	inner join business_transaction bt
	on con.contract_number = bt.contract_number
	and bt.Transaction_Description='check in'
	and bt.RBR_Date between @StartDate and @EndDate	
	inner join quoted_vehicle_rate qr
	on con.quoted_rate_id = qr.quoted_rate_id
	and  qr.rate_name = '01i'
	inner join location loc
		on loc.location_id = con.pick_up_location_id
		and loc.owning_company_id  = @CompanyCode
	order by con.contract_number


/* put all contracts with all types of rates into one table*/
insert into #tmp_contract
	select * from #tmp_GIScontract
	union
	select * from #tmp_MaestroContract


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
	days=round((DATEDIFF(mi, min(checked_out),max(actual_check_in)) / 1440.0), 2)
	from vehicle_on_contract
	where contract_number in (select contract_number from #tmp_contract )
	group by contract_number
	order by contract_number
	
/*get Maestro and GIS provincial gov't rates*/
insert into #tmp_rate
	select vr.Rate_ID, vr.Rate_Name, vr.Effective_Date, vr.Termination_Date 
	from vehicle_rate vr
	where  vr.rate_name in 
	('01i', 'p9a','p9d','pbc00','pbc00a','pbc00b','pbc00c','pbc00d','pbc00e','pbc00f',
	'pbc00g','pbc00h','pbc00i','pbc001','pbc01A','pbc01C','pbc01H','pbcm01','pbcm01A',
	'pbc02', 'pbc02a', 'pbc02c', 'pbc02h', 'pbcm02', 'pbcm02a')
	and vr.Rate_Purpose_ID = 7
	union
	select qr.Quoted_Rate_ID, qr.Rate_Name,
		Effective_Date = null,
		Termination_Date = null
	from quoted_vehicle_rate qr where qr.rate_name = '01i'
	order by vr.rate_id
	

/* get data for report*/
select	distinct con.contract_number		as Contract_number,
	tcon.rbr_date,
	tcon.location,
	tcon.company_name,
	kd.actualdays			as Rental_days,
	tcon.Rate_name,
	tc.tamount			as Time_charge,
	kmc.kamount			as Km_charge,
	kd.kmdriven			as Km_driven
	
	
from #tmp_contract tcon
inner join contract con
	ON con.contract_number=tcon.contract_number
left join 	#tmp_kmcharge kmc
	on kmc.contract_number=con.contract_number
left join 	#tmp_timecharge tc
	on tc.contract_number=con.contract_number
left join 	#tmp_kmdriven kd
	on kd.contract_number=con.contract_number
order by tcon.location,
	con.contract_number


COMPUTE COUNT(con.Contract_Number)  BY tcon.location

GO
