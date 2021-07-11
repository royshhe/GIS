USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_2_Contract_Statistic_2_Year_Comparison]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*----------------------------------------------------------------------------------------------------------------------
	Developed By:	Roy he
	Date:		15 Jan 2002
	Details		Get all data for Vehicle Revenue
	Modification:		Name:		Date:		Detail:

---------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[RP_Con_2_Contract_Statistic_2_Year_Comparison]
AS
SELECT		Pick_up_on,
			Check_in,
			(DATEDIFF(mi,  Pick_Up_On,Check_in) / 1440.00) as  Rental_Days,
			Contract_Number, 
			unit_number, 
			Vehicle_Type_ID, 			
			Vehicle_Class_Code,
			Vehicle_Class_Name,
			DisplayOrder, 
			model_name, 
			model_year, 
			hub_id, 
			Hub_Name, 
			Location_id, 
            Location_Name, 
			--DaysInService,

				-- Not only consider walkup here --- roy he

			SUM(CASE WHEN Charge_Type IN ('Time Charge')  			
						THEN Amount 
						ELSE 0 END) AS TimeCharge, 
            
            SUM(CASE WHEN charge_type = 'KM Charge' 
						THEN amount 
						ELSE 0 END) AS KMs,
			
			SUM(CASE WHEN charge_type = 'Upgrade Charge' 
						THEN amount 
						ELSE 0 END) AS Upgrade, 
									
			SUM(CASE WHEN Charge_Type IN ('Flex Discount', 'Member Discount', 'Contract Discount')--, 'Upgrade Charge')  			
						THEN Amount 
						ELSE 0 END) AS ContractDiscount,
			
			SUM(CASE WHEN OptionalExtraType IN ('LDW') OR (Charge_Type = 'LDW' AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS LDW, 
			SUM(CASE WHEN OptionalExtraType IN ('PAI','PAE','PEC','CARGO') OR (Charge_Type IN ( 'PAI','PAE','PEC/Cargo' )AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS PAI, 
			SUM(CASE WHEN OptionalExtraType IN ( 'RSN') OR (Charge_Type  IN ( 'RSN' ) AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS PEC, 
			SUM(CASE WHEN Optional_Extra IN ('Ski Rack','Snow Board Rack') OR
							Optional_Extra LIKE '%Dolly%' OR
							Optional_Extra LIKE '%Gate%' OR
							Optional_Extra = ' %Blanket%' 
						THEN Amount 
						ELSE 0 END) AS MovingAids, 
			SUM(CASE WHEN Optional_Extra IN ('Child Seat', 'Booster Seat', 'Infant Seat') 
						THEN Amount 
						ELSE 0 END) AS BabySeats, 
			SUM(CASE WHEN charge_type IN ('Sales Accessory','Truck Accessory') 
						THEN amount 
						ELSE 0 END) AS MovingSupply, 
			SUM(CASE WHEN Charge_Type IN ('Location Fee') 
						THEN Amount 
						ELSE 0 END) AS LRF, 
            SUM(CASE WHEN Charge_Type IN ('VLF/AC Recovery Fee') 
						THEN Amount 
						ELSE 0 END) AS VLF, 
			SUM(CASE WHEN Charge_Type IN ('Drop Charge') 
						THEN Amount 
						ELSE 0 END) AS DropCharge, 
			SUM(CASE WHEN Charge_Type IN ('Additional Driver', 'Additional Driver Charge') 
						THEN Amount 
						ELSE 0 END) AS Additional_Driver_Charge, 
			SUM(CASE WHEN Optional_Extra LIKE 'Driver Age%' OR Charge_Type IN ('Under Age Surcharge') 
						THEN Amount 
						ELSE 0 END) AS Driver_Under_Age, 
			SUM(CASE WHEN OptionalExtraType IN ('BUYDOWN') 
						THEN Amount 
						ELSE 0 END) AS BuyDown, 
			SUM(CASE WHEN OptionalExtraType IN ('GPS') 
						THEN Amount 
						ELSE 0 END) AS GPS, 
            SUM(CASE WHEN Charge_Type IN ('FPO','GSO', ' Fuel Charge') 
						THEN Amount 
						ELSE 0 END) AS FPO, 
			SUM(CASE WHEN  OptionalExtraType IN ('ELI')  or 
							 Charge_Type IN ('ELI') 
						THEN Amount 
						ELSE 0 END) AS ELI, 
			SUM(CASE WHEN Charge_Type IN ('Energy Recovery Fee') 
						THEN Amount 
						ELSE 0 END) AS ERF, 
			SUM(CASE WHEN Optional_Extra LIKE '%Winter Tire%' 
						THEN Amount ELSE 0 END) AS SnowTires, 
            SUM(CASE WHEN Charge_Type LIKE 'out of %' or  OptionalExtraType IN ('OA')  
						THEN Amount 
						ELSE 0 END) AS CrossBoardSurcharge
FROM         dbo.RP_FLT_17_Vehicle_Revenue_L1
GROUP BY Pick_up_on, Check_in, unit_number, Contract_Number, Vehicle_Type_ID, Vehicle_Class_Code, Vehicle_Class_Name,DisplayOrder, model_name, model_year, hub_id, Hub_Name, 
                      Location_id, Location_Name
GO
