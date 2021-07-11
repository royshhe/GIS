USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_9_Interbranch_Stat_Rev]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE view [dbo].[RP_Con_9_Interbranch_Stat_Rev]

as


select 	r1.Contract_Number, 
	r1.foreign_contract_number,
	r1.rbr_date,           
	--r1.transaction_description,
	r1.Customer_name,
	r1.Pick_up_Location,
	r1.PULocOCID,
	r1.Drop_off_Location,
	r1.DOLocOCID,	
	--r1.Unit_number,	
	r1.Vehicle_Owning_company,
	r1.VehOCID,
	r1.Date_out,
	r1.Date_in,
	r1.km_out,
	r1.km_in,
	r1.Rental_Length,
	Upgrade = Sum(case	when r1.charge_type = 20
			then (r1.Amount)
			else 0
			end),
	TnM = SUM( CASE 	WHEN r1.Charge_Type IN (10, 11,50, 51, 52)
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
			End)
	
	
from
RP_Con_9_Interbranch_Stat r1

group by r1.contract_number,
	r1.foreign_contract_number,
	r1.rbr_date,	
	r1.Customer_name,
	r1.Pick_up_Location,
	r1.PULocOCID,
	r1.Drop_off_Location,
	r1.DOLocOCID,
	r1.Rental_Length,	
	r1.Vehicle_Owning_company,
	r1.VehOCID,
	r1.Date_out,
	r1.Date_in,
	r1.km_out,
	r1.km_in
	







GO
