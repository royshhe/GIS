USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_12_CSR_Incremental_Yield_L2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		27 Feb 2002
--	Details		Sum all items, seperate in different columns (Summary)
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[RP_Acc_12_CSR_Incremental_Yield_L2]

AS
SELECT
	RBR_Date, 	
	Pick_Up_Location_ID,
   	CSR_Name,
   	Contract_number,
	Vehicle_Type_ID,
	Walk_up,
	Contract_Rental_Days,
           	FPORate,
	WalkUPRate,
        AdditionalDriverRate, 
	ChildSeatRate, 
	UnderAgeRate, 
	UpSellRate, 
	LDWRate, 
	PAIRate, 
	PECRate,
        -- Not only consider walkup here --- roy he
	Sum(case	when charge_type = 20 --and Walk_up=1
			then amount
			else 0
		end)						  as Upgrade,
              Sum(case	when charge_type = 20 --and Walk_up=1
			then Quantity
			else 0
		end)						  as UpgradeQuantity,
	SUM( CASE 	WHEN Charge_Type IN (10, 11, 20,50, 51, 52)
			THEN Amount
			ELSE 0
		END)  
            								as Contract_Revenue,
	SUM(CASE	WHEN Charge_Type = 14
			THEN Amount
			ELSE 0
		END) 							as FPO,
	SUM(CASE	WHEN Charge_Type = 34
			THEN Amount
			ELSE 0
			END) 						as Additional_Driver_Charge,
	SUM(Case	When Optional_Extra_ID in (1, 2, 3) 
			Then Amount
			ELSE 0
			END)						as All_Seats,
	SUM(Case	When Optional_Extra_ID in (23, 25)
			Then Amount
			ELSE 0
			END)						as Driver_Under_Age,
	SUM(Case When OptionalExtraType IN ('LDW','BUYDOWN')
--When Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 16,22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40,41,42,43,44)
			OR (Charge_Type = 61 AND Charge_Item_Type = 'a') -- adjustment charge for LDW
			Then Amount
			ELSE 0
			END)						as All_Level_LDW,
	SUM(Case When OptionalExtraType IN ('PAI','PAE')
--When Optional_Extra_ID = 20
			OR (Charge_Type = 62 AND Charge_Item_Type = 'a') -- adjustment charge for PAI
			Then Amount
			ELSE 0
			END)						as PAI,
	SUM(Case When OptionalExtraType IN ('PEC','RSN')	
--When Optional_Extra_ID = 21
			OR (Charge_Type = 63 AND Charge_Item_Type = 'a') -- adjustment charge for PEC
			Then Amount
			ELSE 0
			END)						as PEC,
	SUM(Case	When Optional_Extra_ID in (4, 26)
			Then Amount
			ELSE 0
			END)						as Ski_Rack,
	SUM(Case	When Optional_Extra_id in (5, 6, 35)
			Then Amount
			Else 0
			End)						as All_Dolly,
	Sum(Case 	When Optional_Extra_id in (17, 18)
			Then Amount
			Else 0
			End)						as All_Gates,
	Sum(Case	When Optional_Extra_id = 7
			Then Amount
			Else 0
			End)						as Blanket,


-- counting start here

	
	SUM(CASE	WHEN Charge_Type = 14 --and Charge_Item_Type = 'c' and amount > .00
			THEN 1
			ELSE 0
		END) 							as FPOCount,
	SUM(CASE	WHEN Charge_Type = 34
			THEN 1
			ELSE 0
			END) 						as AdditionalDriverChargeCount,

	SUM(Case	When Optional_Extra_ID in (1, 2, 3) 
			Then 1
			ELSE 0
			END)						as AllSeatsCount,
	SUM(Case	When Optional_Extra_ID in (23, 25)
			Then 1
			ELSE 0
			END)						as DriverUnderAgeCount,

            
	SUM(Case When OptionalExtraType IN ('LDW','BUYDOWN')		
--When Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 16, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40)
			Then 1
			ELSE 0
			END)						as AllLevelLDWCount,
	SUM(Case When OptionalExtraType IN ('PAI','PAE')	
--When Optional_Extra_ID = 20
			Then 1
			ELSE 0
			END)						as PAICount,
	SUM(Case When OptionalExtraType IN ('PEC','RSN')	
--When Optional_Extra_ID = 21
			Then 1
			ELSE 0
			END)						as PECCount,
	SUM(Case	When Optional_Extra_ID in (4, 26)
			Then 1
			ELSE 0
			END)						as SkiRackCount,
	SUM(Case	When Optional_Extra_id in (5, 6, 35)
			Then 1
			Else 0
			End)						as AllDollyCount,
	Sum(Case 	When Optional_Extra_id in (17, 18)
			Then 1
			Else 0
			End)						as AllGatesCount,
	Sum(Case	When Optional_Extra_id = 7
			Then 1
			Else 0
			End)						as BlanketCount

FROM 	RP_Acc_12_CSR_Incremental_Yield_L1 WITH(NOLOCK) inner join IncentiveRates 
on RP_Acc_12_CSR_Incremental_Yield_L1.Pick_Up_Location_ID=IncentiveRates.LocationId 
and (RP_Acc_12_CSR_Incremental_Yield_L1.RBR_Date between IncentiveRates.EffectiveDate and TerminateDate)




GROUP BY 	RBR_Date,
		Pick_Up_Location_ID,
   		CSR_Name,
		Contract_number,
		Vehicle_Type_ID,
		Walk_up,
		Contract_Rental_Days,
		
		FPORate,
		WalkUPRate,
		AdditionalDriverRate, 
		ChildSeatRate, 
		UnderAgeRate, 
		UpSellRate, 
		LDWRate, 
		PAIRate, 
		PECRate
GO
