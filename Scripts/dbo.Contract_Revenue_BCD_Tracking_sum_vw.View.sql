USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_BCD_Tracking_sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*----------------------------------------------------------------------------------------------------------------------
	Programmer:	Roy He
	Date:		06 Aug2005
	Details		Time, Km charges and LDW total for each contract
	Modification:		Name:		Date:		Detail:

----------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[Contract_Revenue_BCD_Tracking_sum_vw]
AS
SELECT     RBR_Date, Contract_Number, Confirmation_Number, First_Name, Last_Name, PU_Location, DO_Location, Owning_Company_ID, Company_Name, 
                      Organization_Name, PULoc_OID, DOLoc_OID, Vehicle_Type_ID, Vehicle_Class_Name, Model_Name, Model_Year, Pick_Up_On, 
                      Contract_Rental_Days, KmDriven, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, SUM(CASE WHEN Charge_Type IN (10, 50, 51, 
                      52) THEN Amount ELSE 0 END) AS TimeCharge, SUM(CASE WHEN Charge_Type IN (20) THEN Amount ELSE 0 END) AS Upgrade, 
                      SUM(CASE WHEN Charge_Type IN (11) THEN Amount ELSE 0 END) AS KMCharge, SUM(CASE WHEN Charge_Type IN (33) THEN (Amount) ELSE 0 END) 
                      AS DropOff_Charge, SUM(CASE WHEN Charge_Type = 14 THEN Amount ELSE 0 END) AS FPO, 
                      SUM(CASE WHEN Charge_Type = 34 THEN Amount ELSE 0 END) AS Additional_Driver_Charge, 
--
--					  SUM(Case	When Optional_Extra_ID in (1, 2, 3)  
--								Then Amount
--								ELSE 0
--								END)						as All_Seats,
--
--
--
--					SUM(Case	When Optional_Extra_ID in (23, 25) 
--						Then Amount
--						ELSE 0
--						END)						as Driver_Under_Age,


					SUM(Case When OptionalExtraType IN ('LDW','BUYDOWN') --and Rate_Purpose<>'Tour Pkg' 
							OR (Charge_Type = 61 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for LDW
							Then Amount
							ELSE 0
							END)						as All_Level_LDW,

                     SUM(Case When OptionalExtraType IN ('PAI','PAE') --and Rate_Purpose<>'Tour Pkg' 
							OR (Charge_Type = 62 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PAI
							Then Amount
							ELSE 0
							END)						as PAI,
					SUM(Case When OptionalExtraType IN ('PEC','RSN') --and Rate_Purpose<>'Tour Pkg' 
								OR (Charge_Type = 63 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
								Then Amount
								ELSE 0
								END)						as PEC,

				 SUM(Case When OptionalExtraType IN ('ELI') --and Rate_Purpose<>'Tour Pkg' 
							OR (Charge_Type = 67 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
							Then Amount
							ELSE 0
							END)						as ELI,

				  SUM(Case When OptionalExtraType IN ('GPS') --and Rate_Purpose<>'Tour Pkg' 
							OR (Charge_Type = 68 AND (Charge_Item_Type = 'a' Or Charge_Item_Type = 'm')) -- adjustment charge for PEC
							Then Amount
							ELSE 0
							END)						as GPS
--
--				   SUM(Case	When Optional_Extra_ID in (4, 26) 
--							Then Amount
--							ELSE 0
--							END)						as Ski_Rack,
--
--					SUM(Case	When Optional_Extra_ID in (47) 
--							Then Amount
--							ELSE 0
--							END)						as Seat_Storage,
--					SUM(Case	When Optional_Extra_ID in (50,51,52,72,73,74,75) 
--							Then Amount
--							ELSE 0
--							END)						as Our_Of_Area,
--
--					
--					SUM(Case	When Optional_Extra_id in (5, 6, 35) 
--							Then Amount
--							Else 0
--							End)		as All_Dolly,
--
--					Sum(Case 	When Optional_Extra_id in (17, 18)  
--							Then Amount
--							Else 0
--							End)						as All_Gates,
--					Sum(Case	When Optional_Extra_id = 7  
--							Then Amount
--							Else 0
--							End)						as Blanket




FROM         Contract_Revenue_BCD_Tracking_Detail_vw
--WHERE     (BCD_number IS Not NULL) 
--OR
--                      (BCD_number NOT IN ('A044300', 'A159600', 'A162100', 'Z464400', 'Y069300', 'T788300', 'A136100', 'A529200', 'A411700', 'A376100', 'Y492100'))
GROUP BY RBR_Date, Contract_Number, Confirmation_Number, Last_Name, First_Name, PU_Location, DO_Location, Vehicle_Type_ID, Vehicle_Class_Name, 
                      Model_Name, Model_Year, Contract_Rental_Days, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, Owning_Company_ID, 
                      Company_Name, Organization_Name, PULoc_OID, DOLoc_OID, Pick_Up_On, KmDriven
GO
