USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractRevenueAllVanSum]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [dbo].[ViewContractRevenueAllVanSum]

AS

SELECT
	RBR_Date, 	
	Contract_number,
	Vehicle_Type_ID,
        Vehicle_Class_Name,
        model_name,
	model_year,
	Contract_Rental_Days,
        KmDriven,
	
	SUM( CASE 	WHEN Charge_Type IN (10, 11, 20,50, 51, 52)
			THEN Amount
			ELSE 0
		END)  
            								as TimeKmCharge,
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
	SUM(Case
		When Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 16, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40,41,42,43,44)
			OR (Charge_Type = 61 AND Charge_Item_Type = 'a') -- adjustment charge for LDW
			Then Amount
			ELSE 0
			END)						as All_Level_LDW,
	SUM(Case	When Optional_Extra_ID = 20
			OR (Charge_Type = 62 AND Charge_Item_Type = 'a') -- adjustment charge for PAI
			Then Amount
			ELSE 0
			END)						as PAI,
	SUM(Case	When Optional_Extra_ID = 21
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
			End)						as Blanket


FROM 	ViewContractRevenueAllVan
GROUP BY 	RBR_Date, 	
		Contract_number,
		Vehicle_Type_ID,
	        Vehicle_Class_Name,
	        model_name,
		model_year,
		Contract_Rental_Days,
	        KmDriven
		
		












GO
