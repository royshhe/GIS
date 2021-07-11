USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AnalysisOfLDWforAge]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	May 31 2002
-- Purpose: 	To analyze the renters' and additional drivers' ages for contracts with LDW
--------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[AnalysisOfLDWforAge] 
( 	@BusStartDate varchar(30)='Jan 01 2002',
       	@BusEndDate varchar(30)='Jan 31 2002'
)	
AS

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate=CONVERT(DATETIME, @BusStartDate )
SELECT @EndDate=CONVERT(DATETIME, @BusEndDate )



select 	l.location,
	rwo.User_ID AS CSR_Name,
	contract_number = CASE WHEN c.Foreign_Contract_Number IS NOT NULL
				THEN c.Foreign_Contract_Number
				ELSE CAST(c.Contract_Number AS varchar(20))
				END, 
	vc.Vehicle_Class_name,
	cci.Charge_description	as LDW,
	Driver_19_Surcharge = 	case when cci2.optional_extra_id = 23
				then 1
				else 0
				end,
	Driver_21_Surcharge = case when cci2.optional_extra_id = 25
				then 1
				else 0
				end,
	ld.LDW_Deductible,
	(
	Case When cci.Unit_type='Day' Then cci.Quantity
		When cci.Unit_type='Week' Then cci.Quantity*7
		When cci.Unit_type='Month' Then cci.Quantity*30
		Else cci.Quantity
	End
	)Quantity,
	--cci.Quantity
	cci.Amount,
	datediff(mm, c.Birth_Date, getdate())/12 as original_driver,
	sum(cd.first_additional_driver) as first_addition_driver,
	sum(cd.second_additional_driver) as second_addition_driver,
	sum(cd.third_additional_driver) as third_addition_driver,
	sum(cd.forth_additional_driver) as forth_addition_driver
from contract c
inner join
Business_Transaction bt
		ON bt.Contract_Number = c.Contract_Number
		and bt.Transaction_Description = 'check out'
INNER JOIN
RP__CSR_Who_Opened_The_Contract rwo
		ON c.Contract_Number = rwo.Contract_Number
INNER JOIN
RP__First_Vehicle_On_Contract rfv
		ON c.Contract_Number = rfv.Contract_Number
inner join
location l
	on l.location_id = c.pick_up_location_id
INNER JOIN 
Vehicle_Class vc
	ON rfv.Actual_Vehicle_Class_Code = vc.Vehicle_Class_Code
left join
(select distinct contract_number,
	optional_extra_id,
	charge_description,
	Unit_type,
	Quantity,
	
	Amount
from contract_charge_item
where 	Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39) -- LDW
	--or Optional_Extra_ID in (23, 25) -- Driver underage surcharge
	)cci
	on cci.contract_number = c.contract_number
left join
(select distinct contract_number,
	optional_extra_id,
	charge_description
from contract_charge_item
where 	Optional_Extra_ID in (23, 25) -- Driver underage surcharge
	)cci2
	on cci2.contract_number = c.contract_number
left join
LDW_Deductible ld
	on ld.Optional_Extra_ID = cci.Optional_Extra_ID
	and  rfv.Actual_Vehicle_Class_Code = ld.Vehicle_Class_Code
left join
(select distinct cad.contract_number,
	cad.Addition_Type,
	cad.valid_from,
	cad.valid_to,
	cad.Termination_Date,
	first_additional_driver = case when cad.Additional_Driver_ID = 1
					then datediff(mm, cad.Birth_Date, getdate())/12
					else 0 end,
	second_additional_driver = case when cad.Additional_Driver_ID = 2
					then datediff(mm, cad.Birth_Date, getdate())/12
					else 0 end,
	third_additional_driver = case when cad.Additional_Driver_ID = 3
					then datediff(mm, cad.Birth_Date, getdate())/12
					else 0 end,
	forth_additional_driver = case when cad.Additional_Driver_ID = 4
					then datediff(mm, cad.Birth_Date, getdate())/12
					else 0 end
from Contract_Additional_Driver cad
where Termination_Date = '2078-12-31 23:59:00.000'
and cad.Addition_Type not in ('Spouse', 'Company')) cd
	on c.contract_number = cd.contract_number
	and c.pick_up_on >= cd.valid_from
	and c.pick_up_on <= cd.valid_to
where 	bt.rbr_date between @StartDate and @EndDate
	and (cci.Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39) -- LDW
	or cci2.Optional_Extra_ID in (23, 25) )-- Driver underage surcharge
group by l.location,
	rwo.User_ID,
	c.contract_number,
	c.Foreign_Contract_Number,
	c.Birth_Date,
	vc.Vehicle_Class_name,
	cci.Charge_description,
	cci2.optional_extra_id,
	ld.LDW_Deductible,
	cci.Unit_type,
	cci.Quantity,
	cci.Amount		
order by l.location, c.contract_number

select * from contract_charge_item
GO
