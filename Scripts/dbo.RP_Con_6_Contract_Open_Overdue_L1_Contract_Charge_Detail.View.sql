USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L1_Contract_Charge_Detail]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_Base_Contract_Charge
PURPOSE: Calculate Time & Km charges (including location fee), LDW charges for contracts 

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L1_Contract_Charge_Detail]
AS
-- Calculate Time and Km Charge for all contracts, including location fee
SELECT 	
	Contract.Contract_Number, 

	SUM( CASE 	WHEN Charge_Type IN ('10', '11')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as "Time&KM",
	SUM( CASE 	WHEN Charge_Type IN ('12') and Optional_Extra.type not in ('LDW','PAI','PEC','ELI','CARGO','BUYDOWN','PAE','RSN')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as OptionalExtra,
	
	SUM( CASE 	WHEN Charge_Type IN ('12') and Optional_Extra.type in ('LDW','PAI','PEC','ELI','CARGO','BUYDOWN','PAE','RSN')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as Coverage,

	SUM( CASE 	WHEN Charge_Type IN ('13')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as SalesAccs,

	SUM( CASE 	WHEN Charge_Type IN ('20')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as Upsell,

	SUM( CASE 	WHEN Charge_Type IN ('31','33','34','39','46','96','97')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as OtherCharges,

	SUM( CASE 	WHEN Charge_Type IN ('50','51','52')
			THEN Contract_Charge_Item.Amount
					- Contract_Charge_Item.GST_Amount_Included
					- Contract_Charge_Item.PST_Amount_Included
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE 0
			END)  						as Discount

FROM 	Contract 
	INNER JOIN    	Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
		AND Contract_Charge_Item.Charge_Type IN ('10', '11','12','13','20',
												  '31','33','34','39','46',
												  '50','51','52','96','97')
     	left JOIN Optional_Extra 
		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
/* 	
	10  = Time Charge
	11 = KM Charge
	30 = Location fee   'Remove 
	12	Optional Extra
	13	Sales Accessory
	20	Upgrade Charge

	31	Location Surcharge
	33	Drop Charge
	34	Additional Driver Charge
	39	Customer Facility Charge
	46	Energy Recovery Fee

	50	Flex Discount
	51	Member Discount
	52	Contract Discount

	96  VLF/AC Tax Recovery
	97  VLF/AC Tax Recovery
*/
GROUP BY Contract.Contract_Number

--UNION ALL
--
---- Calculate LDW Charge for all contracts
--SELECT 	
--	Contract.Contract_Number, 
--	SUM(Contract_Charge_Item.Amount) 
--    	- SUM(Contract_Charge_Item.GST_Amount_Included) 
--    	- SUM(Contract_Charge_Item.PST_Amount_Included) 
--    	- SUM(Contract_Charge_Item.PVRT_Amount_Included) AS Contract_Charge
--FROM 	Contract 
--	INNER 
--	JOIN
--	Contract_Charge_Item 
--		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
--     	INNER 
--	JOIN
--    	Optional_Extra 
--		ON Contract_Charge_Item.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
--		AND (Optional_Extra.Type = 'LDW' OR Optional_Extra.Type = 'Buydown')
--
--GROUP BY 
--	Contract.Contract_Number
GO
