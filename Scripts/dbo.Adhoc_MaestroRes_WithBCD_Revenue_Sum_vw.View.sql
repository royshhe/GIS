USE [GISData]
GO
/****** Object:  View [dbo].[Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw]
AS

SELECT      Contract_Number, 
	(case when Foreign_Confirm_Number is Null 
		then  CONVERT(Varchar(12), Confirmation_Number)
		else Foreign_Confirm_Number
	end ) as Confirm_Number,
	Pickup_Location, Drop_Off_Location, Pick_Up_On, Drop_Off_On, 
                      Vehicle_Class_Name, Contract_Rental_Days, KmDriven, Walk_Up, GISRate, MaestroRate, Maestro_BCD,  Status,


	
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
	SUM(CASE	WHEN Charge_Type  in (30, 35)
			THEN Amount
			ELSE 0
			END) 						as Location_Fee,
	SUM(CASE	WHEN Charge_Type  in (96, 97)
			THEN Amount
			ELSE 0
			END) 						as License_Fee,
	SUM(Case	When Optional_Extra_ID in (1, 2, 3) 
			Then Amount
			ELSE 0
			END)						as All_Seats,
	SUM(Case	When Optional_Extra_ID in (23, 25)
			Then Amount
			ELSE 0
			END)						as Driver_Under_Age,
	SUM(Case
		When     (OptionalExtraType in ( 'LDW' , 'Buydown')) 
			OR (Charge_Type = 61 AND Charge_Item_Type = 'a')
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


FROM 	Adhoc_MaestroRes_WithBCD_Revenue_vw
--where Pick_Up_On>='2007-01-01' and Pick_Up_On<'2007-10-01'
GROUP BY 	  Contract_Number, Confirmation_Number, Foreign_Confirm_Number, Pickup_Location, Drop_Off_Location, Pick_Up_On, Drop_Off_On, 
                      Vehicle_Class_Name, Contract_Rental_Days, KmDriven, Walk_Up, GISRate, MaestroRate, Maestro_BCD,Status

GO
