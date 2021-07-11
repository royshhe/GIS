USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_11_Reservation_Rate_Performance_L1_Base_Cont_Misc]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME:  	 RP_Res_11_Reservation_Rate_Performance_L1_Base_Cont_Misc
PURPOSE:           Get all information related to contracts

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	 RP_Res_11_Reservation_Rate_Performance_L2_Base_Cont_Misc
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_11_Reservation_Rate_Performance_L1_Base_Cont_Misc]
AS
-- Calculate total number of Rental Days for all contracts checked in 
SELECT
	Contract.Contract_Number, 
	DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS Rental_Days, 
  	0 AS Km_Driven,
	0 AS TimeKm_Charge,
	0 AS LDW_Charge,
	0 AS PAI_Charge,
	0 AS PEC_Charge,
	0 AS Cargo_Charge
FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND Contract.Status = 'CI' 
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
		AND Vehicle_On_Contract.Actual_Check_In IS NOT NULL
     		AND Vehicle_On_Contract.Actual_Check_In =
    			(SELECT MAX(actual_check_in)
      				FROM vehicle_On_Contract
      					WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)

UNION ALL

-- Calculate Kms Driven for all contracts checked in 
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
    	SUM(ABS(Vehicle_On_Contract.Km_In - Vehicle_On_Contract.Km_Out)) AS Km_Driven,
	0 AS TimeKm_Charge,
	0 AS LDW_Charge,
	0 AS PAI_Charge,
	0 AS PEC_Charge,
	0 AS Cargo_Charge
FROM 	Contract 
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
		AND Contract.Status = 'CI'
GROUP BY 
	Contract.Contract_Number

UNION ALL

-- Calculate Time and Km Charge for all contracts, including upgrade revenue
-- less any discounts
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
	0 AS Km_Driven,	
	SUM(Contract_Charge_Item.Amount) 
    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS TimeKM_Charge,
	0 AS LDW_Charge,
	0 AS PAI_Charge,
	0 AS PEC_Charge,
	0 AS Cargo_Charge
FROM 	Contract 
	INNER 
	JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
		AND Contract.Status = 'CI'
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
		AND Contract_Charge_Item.Charge_Type IN (10, 11,50, 51, 52)
	
/* 	
	10  = Time Charge
	11 = KM Charge
*/
GROUP BY Contract.Contract_Number

UNION ALL

-- Calculate LDW Charge for all BRAC contracts
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
	0 AS Km_Driven, 
    	0 AS TimeKm_Charge, 
	SUM(Contract_Charge_Item.Amount) 
    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS LDW_Charge, 
	0 AS PAI_Charge, 
	0 AS PEC_Charge, 
    	0 AS Cargo_Charge
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
		AND Contract.Status = 'CI' 
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER 
	JOIN
    	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
		AND (Optional_Extra.Type = 'LDW' OR Optional_Extra.Type = 'Buydown')

GROUP BY 
	Contract.Contract_Number

UNION ALL

-- Calculate PAI Charge for all BRAC contracts
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
	0 AS Km_Driven, 
    	0 AS TimeKm_Charge, 
	0 AS LDW_Charge, 
	SUM(Contract_Charge_Item.Amount) 
    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS PAI_Charge, 
	0 AS PEC_Charge, 
    	0 AS Cargo_Charge
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
		AND Contract.Status = 'CI' 
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER 
	JOIN
    	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
		AND Optional_Extra.Type IN ( 'PAI','PAE')

GROUP BY 
	Contract.Contract_Number


UNION ALL

-- Calculate PEC Charge for all BRAC contracts
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
	0 AS Km_Driven, 
    	0 AS TimeKm_Charge, 
	0 AS LDW_Charge, 
	0 AS PAI_Charge, 
	SUM(Contract_Charge_Item.Amount) 
    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS PEC_Charge, 
    	0 AS Cargo_Charge
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
		AND Contract.Status = 'CI' 
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER 
	JOIN
    	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
		AND Optional_Extra.Type = 'PEC' 

GROUP BY 
	Contract.Contract_Number


UNION ALL

-- Calculate Cargo Charge for all BRAC contracts
SELECT 	
	Contract.Contract_Number, 
	0 AS Rental_Days,
	0 AS Km_Driven, 
    	0 AS TimeKm_Charge, 

	0 AS LDW_Charge, 
	0 AS PAI_Charge, 
    	0 AS PEC_Charge, 
	SUM(Contract_Charge_Item.Amount) 
    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS Cargo_Charge
FROM 	Location 
	INNER 
	JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID 
		AND Contract.Status = 'CI' 
		AND Contract.Confirmation_Number IS NOT NULL -- not a walk-up contract
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
     	INNER 
	JOIN
    	Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
		AND Optional_Extra.Type = 'Cargo' 
GROUP BY 
	Contract.Contract_Number
GO
