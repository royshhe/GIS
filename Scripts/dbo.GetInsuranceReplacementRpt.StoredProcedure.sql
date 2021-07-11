USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInsuranceReplacementRpt]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Mar 04 2002
-- Purpose: 	To create a report for all contracts with insurance replacement rates
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetInsuranceReplacementRpt]

       @MonStartDate varchar(30)='Jan 01 2000',
       @MonEndDate varchar(30)='Dec 31 2000'

as


DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @MonStartDate )
SELECT @EndDate=CONVERT(DATETIME, @MonEndDate )

-- create report tables 
create table #tmp_contract
( contract_number int,
  rate_name varchar(25),
  location varchar(25),
  Reservation_revenue decimal(9,2)
)

create table #tmp_billingparty
( contract_number int,
  Billed_To  varchar(50),
  Billing_Method varchar(25),
  Billing_Type varchar(20)
)

/*create table #tmp_billingparty
( contract_number int,
  Primary_Billed_To varchar(50),
  alternate_billed_to varchar(50),
  Primary_Billing_Method varchar(25),
  Alternate_billing_method varchar(25)
)*/

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

create table #tmp_firstmodel
( contract_number int,
  vehicle_model varchar(25),
  vehicle_year int
)

create table #tmp_lastmodel
( contract_number int,
  vehicle_model varchar(25),
  vehicle_year int
)

create table #tmp_optionalextra
( contract_number int,
  contract_revenue decimal(9,2),
  FPO_and_Fuel decimal(9,2),
  Buy_down decimal(9,2),
  All_Level_LDW decimal(9,2),
  PAI decimal(9,2),
  PEC decimal(9,2)  
)


--Specify the date

insert into #tmp_contract
	select distinct con.contract_number, vr.rate_name,  loc.location, con.Reservation_revenue
	from contract con
	inner join vehicle_rate vr
	on vr.rate_id =con.rate_id
	and con.Rate_Assigned_Date between vr.effective_date and vr.termination_date
	and vr.Rate_Purpose_ID = 14
	inner join business_transaction bt
	on con.contract_number = bt.contract_number
	and bt.Transaction_Description='check in'
	and bt.RBR_Date between @StartDate and @EndDate
	left join location loc
		on loc.location_id = con.pick_up_location_id
	order by con.contract_number

/* get payment billing parties */
insert into #tmp_billingparty
	SELECT	tcon.contract_number,
			Billed_To = CASE
			WHEN CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Direct Bill'
				THEN ARM.Address_Name
			WHEN CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Renter'
				THEN 'Renter'
			ELSE	-- alternate billing
				ARM.Address_Name
		END,
		CBP.Billing_Method, 
		Billing_Type =  (case when CBP.Billing_Type = 'p'
			then 'Primary'	
			else 'Alternate'	end)
	FROM	#tmp_contract tcon
		left join
		Contract_Billing_Party CBP
		on  tcon.contract_number = CBP.contract_number
		LEFT JOIN armaster ARM
		  ON CBP.Customer_Code = ARM.Customer_Code
		 AND ARM.Address_Type = 0	
	order by tcon.contract_number
	/*select 	distinct tcon.contract_number,
		Primary_Billed_To = CASE 
			WHEN CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Direct Bill'
				THEN ARM.Address_Name
			when CBP.Billing_Type = 'p'
				AND CBP.Billing_Method = 'Renter'
				THEN 'Renter'
			else null
		end,
		alternate_billed_to = case
			WHEN CBP.Billing_Type = 'a'
			then ARM.Address_Name
			else null
		END,
		Primary_Billing_Method = case when CBP.Billing_Type = 'p'
			then CBP.Billing_Method 
			else null end,
		Alternate_billing_method = case when CBP.Billing_Type = 'a'
			then CBP.Billing_Method 
			else null end
	FROM	#tmp_contract tcon
		left join
		Contract_Billing_Party CBP
		on  tcon.contract_number = CBP.contract_number
		LEFT JOIN armaster ARM
		  ON CBP.Customer_Code = ARM.Customer_Code
		 AND ARM.Address_Type = 0
	order by tcon.contract_number*/



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
	days=round((DATEDIFF(mi, min(checked_out),max(actual_check_in)) / 1440.0),1)
	from vehicle_on_contract
	where contract_number in (select contract_number from #tmp_contract )
	group by contract_number
	order by contract_number

/*get frist vehicle model and year*/
insert into #tmp_firstmodel
	select tcon.contract_number, Model_name, Model_year
	from #tmp_contract tcon
	inner join RP__First_Vehicle_On_Contract rf
		on tcon.contract_number = rf.contract_number
	inner join vehicle v
		on rf.unit_number = v.unit_number
	left join vehicle_model_year vmy
		on v.Vehicle_Model_ID = vmy.Vehicle_Model_ID
	order by tcon.contract_number
	
/* get last vehicle model and year*/
insert into #tmp_lastmodel
	select tcon.contract_number, Model_name, Model_year
	from #tmp_contract tcon
	inner join RP__Last_Vehicle_On_Contract rl
		on tcon.contract_number = rl.contract_number
	inner join vehicle v
		on rl.unit_number = v.unit_number
	left join vehicle_model_year vmy
		on v.Vehicle_Model_ID = vmy.Vehicle_Model_ID
	order by tcon.contract_number

/*get all optional extra items*/
insert into #tmp_optionalextra
	select contract_number, 
	sum( case 	when Charge_Type IN (10, 11, 20,50, 51, 52)	
		then Amount	else 0		end ) 			as Contract_Revenue,
	sum(case	when Charge_Type = 14 or Charge_Type = 18	
		then Amount	else 0		end)			as FPO_and_Fuel,
	sum(case	when optional_extra_id = 16	
		then Amount	else 0		end)			as Buy_down,
	sum(case	when Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40)
		then Amount	else 0		end)			as All_Level_LDW,
	sum(case 	when Optional_Extra_ID = 20	
		then Amount	else 0		end)			as PAI,
	sum(case 	when Optional_Extra_ID = 21 	
		then Amount	else 0		end)			as PEC
from 	contract_charge_item
where contract_number in (select contract_number from #tmp_contract ) 
group by	Contract_number

/* get data for report*/
select	distinct con.contract_number		as Contract_number,
	tcon.location,
	/*bp.Primary_Billing_Method,
	bp.Primary_Billed_to,
	bp.Alternate_billing_method,
	bp.Alternate_Billed_to,*/
	bp.Billing_Type,
	bp.Billing_Method,
	bp.Billed_To,
	kd.actualdays			as Rental_days,
	vc1.vehicle_class_name		as Vehicle_class,
	fm.vehicle_model		as Vehicle_model,
	fm.vehicle_year			as Vehicle_year,
	vc2.vehicle_class_name		as Sub_Vehicle_class,
	(case when vc2.vehicle_class_name is null 
		then Null	else lm.vehicle_model
		end) 			as Sub_Vehicle_model,
	(case when vc2.vehicle_class_name is null 
		then Null	else lm.vehicle_year
		end) 			as Sub_Vehicle_year,
	tcon.rate_name			as Rate_name,
	tc.tamount			as Time_charge,
	kmc.kamount			as Km_charge,
	kd.kmdriven			as Km_driven,
	(case when op.Contract_Revenue > tcon.Reservation_Revenue 
		 then op.Contract_Revenue - tcon.Reservation_Revenue
		else 0 
		end)			as Up_grade,
	op.FPO_and_Fuel,
	op.Buy_down,
	op.All_Level_LDW,
	op.PAI,
	op.PEC
	
from #tmp_contract tcon
inner join contract con
	ON con.contract_number=tcon.contract_number
left join #tmp_billingparty bp
	on tcon.contract_number = bp.contract_number
left join	vehicle_class vc1 
	on con.vehicle_class_code = vc1.vehicle_class_code 
left join 	vehicle_class vc2
	on con.Sub_Vehicle_Class_Code = vc2.vehicle_class_code 
left join 	#tmp_kmcharge kmc
	on kmc.contract_number=con.contract_number
left join 	#tmp_timecharge tc
	on tc.contract_number=con.contract_number
left join 	#tmp_kmdriven kd
	on kd.contract_number=con.contract_number
left join 	#tmp_firstmodel fm
	on fm.contract_number = con.contract_number
left join 	#tmp_lastmodel lm
	on lm.contract_number = con.contract_number
left join 	#tmp_optionalextra op
	on op.contract_number = tcon.contract_number
order by tcon.location,
	con.contract_number


COMPUTE COUNT(con.Contract_Number)  BY tcon.location



















GO
