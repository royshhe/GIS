USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Revenue_Fed_Tracking_sum_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
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
CREATE VIEW [dbo].[Contract_Revenue_Fed_Tracking_sum_vw]
AS
--no Buydown include in LDW --Peter/30 aug 2010 req by Deborah

SELECT     RBR_Date, Contract_Number, Confirmation_Number, First_Name, Last_Name, PU_Location, DO_Location, Owning_Company_ID, Company_Name, 
                      Organization_Name, PULoc_OID, DOLoc_OID, Vehicle_Type_ID, REPLACE(Vehicle_Class_Name, '''', '') AS Vehicle_Class_Name, Model_Name, 
                      Model_Year, Pick_Up_On, Contract_Rental_Days, KmDriven, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, 
                      SUM(CASE WHEN Charge_Type IN (10, 50, 51, 52) THEN Amount ELSE 0 END) AS TimeCharge, SUM(CASE WHEN Charge_Type IN (20) 
                      THEN Amount ELSE 0 END) AS Upgrade, SUM(CASE WHEN Charge_Type IN (11) THEN Amount ELSE 0 END) AS KMCharge, 
                      SUM(CASE WHEN Charge_Type IN (33) THEN (Amount) ELSE 0 END) AS DropOff_Charge, 
                      SUM(CASE WHEN Charge_Type = 14 THEN Amount ELSE 0 END) AS FPO, SUM(CASE WHEN Charge_Type = 34 THEN Amount ELSE 0 END) 
                      AS Additional_Driver_Charge, SUM(CASE WHEN Optional_Extra_ID IN (1, 2, 3) THEN Amount ELSE 0 END) AS All_Seats, 
                      SUM(CASE WHEN Optional_Extra_ID IN (23, 25) THEN Amount ELSE 0 END) AS Driver_Under_Age, SUM(CASE WHEN type='LDW' or
                      (Charge_Type = 61 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS All_Level_LDW, SUM(CASE WHEN Optional_Extra_ID = 20 OR
                      (Charge_Type = 62 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS PAI, SUM(CASE WHEN Optional_Extra_ID = 21 OR
                      (Charge_Type = 63 AND Charge_Item_Type = 'a') THEN Amount ELSE 0 END) AS PEC, SUM(CASE WHEN Optional_Extra_ID IN (4, 26) 
                      THEN Amount ELSE 0 END) AS Ski_Rack, SUM(CASE WHEN Optional_Extra_id IN (5, 6, 35) THEN Amount ELSE 0 END) AS All_Dolly, 
                      SUM(CASE WHEN Optional_Extra_id IN (17, 18) THEN Amount ELSE 0 END) AS All_Gates, 
                      SUM(CASE WHEN Optional_Extra_id = 7 THEN Amount ELSE 0 END) AS Blanket
FROM         dbo.Contract_Revenue_Fed_Tracking_Detail_vw
WHERE     (BCD_number IS NULL) OR
                      (BCD_number NOT IN ( 'A159600', 'A162100', 'Z464400',  'T788300', 'A136100', 'A529200', 'A411700', 'A376100', 'Y492100'))
GROUP BY RBR_Date, Contract_Number, Confirmation_Number, Last_Name, First_Name, PU_Location, DO_Location, Vehicle_Type_ID, Vehicle_Class_Name, 
                      Model_Name, Model_Year, Contract_Rental_Days, Walk_Up, Rate_Name, Rate_Purpose_ID, Org_Type, BCD_number, Owning_Company_ID, 
                      Company_Name, Organization_Name, PULoc_OID, DOLoc_OID, Pick_Up_On, KmDriven
GO
