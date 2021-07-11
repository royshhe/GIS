USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_9_Interbranch_Trx_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE procedure [dbo].[RP_SP_Con_9_Interbranch_Trx_Main]
(
	@paramStartDate varchar(20) = '01 jun 2003',
	@paramEndDate varchar(20) = '23 jun 2003',
	@paramOwningCompany_id varchar(10)
)
AS
-- convert strings to datetime

DECLARE 	@startDate datetime,
		@endDate datetime,
		@owningCompanyID int

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)
	

if @paramOwningCompany_id = '*'
	BEGIN
		SELECT @owningCompanyID='0'
        END
else
	BEGIN
		SELECT @owningCompanyID = convert(int, @paramOwningCompany_id)
	END 


select 	contract_number = case when r1.RateInclusiveFlag = 1  or r1.QuotedInclusiveFlag = 1 
				then convert(varchar(20), r1.contract_number) + '*' --indicate that rates are inclusive
				else convert(varchar(20), r1.contract_number) 
				end,
	r1.foreign_contract_number,
	r1.rbr_date,
	r1.transaction_description,
	r1.Customer_name,
	r1.Pick_up_Location,
	r1.PULocOCID,
	r1.Drop_off_Location,
	r1.DOLocOCID,
	r1.Vehicle_Class_name,
	r1.Unit_number,
	r1.licence_plate,
	r1.Vehicle_Owning_company,
	r1.VehOCID,
	r1.Date_out,
	r1.Date_in,
	r1.km_out,
	r1.km_in,
	Upgrade = Sum(case	when r1.charge_type = 20
			then (r1.Amount)
			else 0
			end),
	contract_revenue = SUM( CASE 	WHEN r1.Charge_Type IN (10, 11,50, 51, 52)
				THEN (r1.Amount)
				ELSE 0
				END),
	Drop_Charge = SUM( CASE 	WHEN r1.Charge_Type IN (33)
			THEN (r1.Amount)
			ELSE 0
			END),
	Fuel = SUM( CASE 	WHEN r1.Charge_Type = 18
			THEN (r1.Amount)
			ELSE 0
			END),
	FPO = SUM(CASE	WHEN r1.Charge_Type = 14
			THEN (r1.Amount)
			ELSE 0
			END),
	Additional_Driver_Charge = SUM(CASE	WHEN r1.Charge_Type = 34
					THEN(r1.Amount)
					ELSE 0
					END),
	All_Seats = SUM(Case	When r1.Optional_Extra_ID in (1, 2, 3) 
			OR (r1.Charge_Type = 23 ) -- adjustment and rentback charge for seats
			Then (r1.Amount)
			ELSE 0
			END),
	Driver_Under_Age = SUM(Case	When r1.Optional_Extra_ID in (23, 25)
					OR (r1.Charge_Type = 36 )  -- adjustment and rentback charge for underage surcharges
				Then (r1.Amount)
				ELSE 0
				END),
	All_Level_LDW = SUM(Case
				When  OptionalExtraType IN ('LDW','BUYDOWN')
				OR (r1.Charge_Type in (61, 91) ) -- adjustment and rentback charge for LDW, include foreign
				Then (r1.Amount)
				ELSE 0
				END),
	PAI = SUM(Case	When r1.Optional_Extra_ID = 20
			OR (r1.Charge_Type in (62, 92) ) -- adjustment and rentback charge for PAI, include foreign
			Then (r1.Amount)
			ELSE 0
			END),
	PEC = SUM(Case	When r1.Optional_Extra_ID = 21
			OR (r1.Charge_Type in (63, 93) ) -- adjustment and rentback charge for PEC, include foreign
			Then (r1.Amount)
			ELSE 0
			END),
	Racks = SUM(Case	When r1.Optional_Extra_ID in (4, 26)
			Then (r1.Amount)
			ELSE 0
			END),
	Miscell = SUM(Case	When r1.Charge_Type in (22, 15, 16, 17, 19, 21, 24, 25, 26, 27, 28, 29, 32, 37, 60, 64, 65, 66, 70, 90, 94, 95) 
							--include misc, damage claim, ticket, key cut, taxi, UAD, others, etc
			Then (r1.Amount)
			Else 0
			End),
	CFC = SUM(CASE	WHEN r1.Charge_Type = 39
			THEN (r1.Amount)
			ELSE 0
			END),
	LocationFee = Sum(Case 	When r1.Charge_Type in (30, 35, 31) -- include location surcharge
			Then (r1.Amount)
			Else 0
			End),
	LicenceFee = Sum(Case	When r1.Charge_Type in (96, 97)
			Then (r1.Amount)
			Else 0
			End),
	GST_Amount = sum(r1.GST_Amount),
	PST_Amount = sum(r1.PST_Amount),
	PVRT_Amount = sum(r1.PVRT_Amount),
	r2.Payment_Type,
	r2.amount,
	CollectedAt = r2.location
	
from
RP_Con_9_Interbranch_Data_L1 r1
left join
RP_Con_5_Interbranch_Deposit_Refund_SB_L1_Base_1 r2
on r1.business_transaction_id = r2.business_transaction_id
where r1.rbr_date between @startDate and @endDate
and (	
	   ( @paramOwningCompany_id = '*' or r1.PULocOCID = @owningCompanyID) 
	or (@paramOwningCompany_id = '*' or r1.DOLocOCID = @owningCompanyID)
	or ( @paramOwningCompany_id = '*' or r1.VehOCID = @owningCompanyID)
 )

group by r1.contract_number,
	r1.foreign_contract_number,
	r1.rbr_date,
	r1.transaction_description,
	r1.Customer_name,
	r1.Pick_up_Location,
	r1.PULocOCID,
	r1.Drop_off_Location,
	r1.DOLocOCID,
	r1.Vehicle_Class_name,
	r1.Unit_number,
	r1.licence_plate,
	r1.Vehicle_Owning_company,
	r1.VehOCID,
	r1.Date_out,
	r1.Date_in,
	r1.km_out,
	r1.km_in,
	--r1.charge_type,
	r2.Payment_Type,
	r2.amount,
	r2.location,
	r1.RateInclusiveFlag,
	r1.QuotedInclusiveFlag
GO
