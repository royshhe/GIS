USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractRevenueSum]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
------------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		06 Aug2003
--	Details		Time, Km charges and LDW total for each contract
--	Modification:		Name:		Date:		Detail:
--
------------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[ViewContractRevenueSum]
as
SELECT  RBR_Date, 
    	Contract_Number, 
   	Pick_Up_Location_ID, 
    	Vehicle_Type_ID, 
	Vehicle_Class_Name,
	model_name,
	model_year,
	Contract_Rental_Days,
	Walk_Up,
	rate_name,
	Rate_Purpose_ID,
	Org_Type,
             sum(Amount) as TotalRevenue,
	SUM(CASE WHEN Charge_Type IN (10, 11, 20, 50, 51, 52)
		THEN Amount
		ELSE 0
		END)	as Contract_Revenue,
	SUM(Case
		When (Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 16, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40,41,42,43,44)
			OR (Charge_Type = 61 AND Charge_Item_Type = 'a')) -- adjustment charge for LDW
		Then Amount
		ELSE 0
		END)	as LDW,
	SUM(Case	When Optional_Extra_ID = 20
			OR (Charge_Type = 62 AND Charge_Item_Type = 'a') -- adjustment charge for PAI
		Then Amount
		ELSE 0
		END)	as PAI,
	SUM(Case	When Optional_Extra_ID = 21
			OR (Charge_Type = 63  AND Charge_Item_Type = 'a') -- adjustment charge for PEC
		Then Amount
		ELSE 0
		END)	as PEC
FROM ViewContractRevenueAll
GROUP BY RBR_Date,
	contract_number,
	Pick_Up_Location_ID,
	Vehicle_Type_ID,
	Vehicle_Class_Name,
	model_name,
	model_year,
	Contract_Rental_Days,
	Walk_Up,
	RATE_NAME,
	Rate_Purpose_ID,
	ORG_TYPE









GO
