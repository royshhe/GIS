USE [GISData]
GO
/****** Object:  View [dbo].[RP_FLT_17_Vehicle_Revenue_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
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
CREATE VIEW [dbo].[RP_FLT_17_Vehicle_Revenue_Main]
AS
SELECT		Pick_up_on,
			Check_in,
			(DATEDIFF(mi,  Pick_Up_On,Check_in) / 1440.00) as  Rental_Days,
			Contract_Number, 
			Company_name,
			Renter_Name,
			unit_number, 
			Vehicle_Type_ID, 
			-- Modified on Aug 03, 2016 Per Syd's request, before the trip -- Moved to [RP_FLT_17_Vehicle_Revenue_L1]
			--(Case When Vehicle_Class_Code in ('1', '3', '4', 'c', 'l') then '1'
			--     When Vehicle_Class_Code in ('-', 'd', 'e', 'f') then 'e'
			--     When Vehicle_Class_Code in ('0','o',  'v', '5') then 'v'
			--     When Vehicle_Class_Code in ('+', '=') then '+'
			--     When Vehicle_Class_Code in ('9', '}', '-','{' ) then '9'
			--     Else  Vehicle_Class_Code
			--End)  Vehicle_Class_Code,
			Vehicle_Class_Code,
			Vehicle_Class_Name,
			DisplayOrder, 
			model_name, 
			model_year, 
			hub_id, 
			Hub_Name, 
			Location_id, 
            Location_Name, 
            Rate_Name,
			--DaysInService,

				-- Not only consider walkup here --- roy he

			SUM(CASE WHEN charge_type = 'Upgrade Charge' 
						THEN amount 
						ELSE 0 END) AS Upgrade, 
			SUM(CASE WHEN Charge_Type IN ('Time Charge','Flex Discount', 'Member Discount', 'Contract Discount')--, 'Upgrade Charge') 
						THEN Amount 
						ELSE 0 END) AS TimeCharge, 
            SUM(CASE WHEN charge_type = 'KM Charge' 
						THEN amount 
						ELSE 0 END) AS KMs, 
			SUM(CASE WHEN OptionalExtraType IN ('LDW') OR (Charge_Type = 'LDW' AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS LDW, 
			SUM(CASE WHEN OptionalExtraType IN ('PAI','PAE','PEC', 'CARGO') OR (Charge_Type IN ( 'PAI','PAE','PEC/Cargo') AND Charge_Item_Type = 'a') 
						THEN Amount 
						ELSE 0 END) AS PAI, 
			SUM(CASE WHEN OptionalExtraType IN ('RSN') OR (Charge_Type IN  ('RSN') AND Charge_Item_Type = 'a') 
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
			SUM(CASE WHEN OptionalExtraType IN ('GPS')  or Charge_Type='GPS'
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
			SUM(CASE WHEN Optional_Extra LIKE '%Winter Tire%'  or Charge_Type='Winter Tire'
						THEN Amount ELSE 0 END) AS SnowTires, 
            SUM(CASE WHEN Charge_Type LIKE 'out of %' or  OptionalExtraType IN ('OA')  
						THEN Amount 
						ELSE 0 END) AS CrossBoardSurcharge
FROM         dbo.RP_FLT_17_Vehicle_Revenue_L1
GROUP BY Pick_up_on, Check_in, unit_number, Contract_Number, Vehicle_Type_ID, Vehicle_Class_Code, Vehicle_Class_Name,DisplayOrder, model_name, model_year, hub_id, Hub_Name, 
                      Location_id, Location_Name,Company_name,	Renter_Name,Rate_Name


GO
