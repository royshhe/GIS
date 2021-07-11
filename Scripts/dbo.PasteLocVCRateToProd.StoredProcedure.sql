USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PasteLocVCRateToProd]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




















CREATE Procedure [dbo].[PasteLocVCRateToProd]
as


--delete the existing ones using the name matching, right now is hardcoded
delete dbo.Location_Vehicle_Rate_Level
--SELECT    dbo.Location_Vehicle_Rate_Level .*, vr1.Rate_Name AS Expr1, vr2.Rate_Name AS Expr2
--select *
FROM         dbo.Location_Vehicle_Rate_Level_vw INNER JOIN
                      dbo.Location_Vehicle_Rate_Level ON 
                      dbo.Location_Vehicle_Rate_Level_vw.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID  AND 
                      ltrim(rtrim(dbo.Location_Vehicle_Rate_Level_vw.Location_Vehicle_Rate_Type)) = ltrim(rtrim(dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type))  AND 
                      dbo.Location_Vehicle_Rate_Level_vw.Valid_From = dbo.Location_Vehicle_Rate_Level.Valid_From 
AND      dbo.Location_Vehicle_Rate_Level_vw.Rate_Selection_Type = dbo.Location_Vehicle_Rate_Level.Rate_Selection_Type 
INNER JOIN
                      dbo.Vehicle_Rate vr1 ON dbo.Location_Vehicle_Rate_Level_vw.Rate_ID = vr1.Rate_ID INNER JOIN
                      dbo.Vehicle_Rate vr2 ON dbo.Location_Vehicle_Rate_Level.Rate_ID = vr2.Rate_ID
WHERE     (vr1.Termination_Date = 'Dec 31 2078 11:59PM') AND (vr2.Termination_Date = 'Dec 31 2078 11:59PM') AND 
(
		      ((vr1.Rate_Name LIKE '%daily%' or vr1.Rate_Name LIKE  'KM%PROMO%') AND (vr2.Rate_Name LIKE '%daily%' or vr2.Rate_Name LIKE 'KM%PROMO%')) 
                   or ((vr1.Rate_Name LIKE '%weekly%') AND (vr2.Rate_Name LIKE '%weekly%'))
                   OR ((vr1.Rate_Name LIKE 'OW WHISTLER%') AND (vr2.Rate_Name LIKE 'OW WHISTLER%'))
		   OR ((vr1.Rate_Name LIKE 'OW SEATTLE%' or vr1.Rate_Name LIKE 'One Way Seattle%') AND (vr2.Rate_Name LIKE 'OW SEATTLE%' or vr2.Rate_Name LIKE 'One Way Seattle%'))
                   OR ((vr1.Rate_Name LIKE '3d%') AND (vr2.Rate_Name LIKE '3d%'))
 		   OR ((vr1.Rate_Name LIKE 'OW Vanc Island%') AND (vr2.Rate_Name LIKE 'OW Vanc Island%'))
		   OR ((vr1.Rate_Name LIKE 'OW VICTORIA%') AND (vr2.Rate_Name LIKE 'OW VICTORIA%'))
		   OR ((vr1.Rate_Name LIKE 'OW CALGARY%') AND (vr2.Rate_Name LIKE 'OW CALGARY%'))
		   OR ((vr1.Rate_Name LIKE 'OW BC%') AND (vr2.Rate_Name LIKE 'OW BC%'))
		   OR ((vr1.Rate_Name LIKE 'OW ABBOTSFORD%') AND (vr2.Rate_Name LIKE 'OW ABBOTSFORD%'))
		   OR ((vr1.Rate_Name LIKE 'WHS OW%') AND (vr2.Rate_Name LIKE 'WHS OW%'))
		   OR ((vr1.Rate_Name LIKE 'KM%') AND (vr2.Rate_Name LIKE 'KM%'))
		   OR ((vr1.Rate_Name LIKE 'KM%') AND (vr2.Rate_Name LIKE '%Daily%'))
		   OR ((vr1.Rate_Name LIKE '%STD%') AND (vr2.Rate_Name LIKE '%STD%'))
		   OR ((vr1.Rate_Name LIKE '%STD%') AND (vr2.Rate_Name LIKE '%Daily%'))	
		   OR ((vr1.Rate_Name LIKE 'Daily%') AND (vr2.Rate_Name LIKE '%STD%'))	

		   OR ((vr1.Rate_Name LIKE 'MiniL%') AND (vr2.Rate_Name LIKE 'MiniL%'))
		   OR ((vr1.Rate_Name LIKE 'MiniH%') AND (vr2.Rate_Name LIKE 'MiniH%'))	

		   OR ((vr1.Rate_Name LIKE 'Cargo Van KM%') AND (vr2.Rate_Name LIKE 'Cargo Van KM%'))
		   OR ((vr1.Rate_Name LIKE 'Cargo Van KM%') AND (vr2.Rate_Name LIKE '%Daily%'))	
		   OR ((vr1.Rate_Name LIKE 'Daily%') AND (vr2.Rate_Name LIKE '%Cargo Van KM%'))
	
                   or (vr1.Rate_Name =vr2.Rate_Name and dbo.Location_Vehicle_Rate_Level.Rate_Level=dbo.Location_Vehicle_Rate_Level_vw.Rate_Level)  -- nor sure about the level


		   OR ((vr1.Rate_Name LIKE 'Daily%') AND (vr2.Rate_Name LIKE '%May%'))	
		   OR ((vr1.Rate_Name LIKE '2Day%') AND (vr2.Rate_Name LIKE '2Day%'))		
		   OR ((vr1.Rate_Name LIKE 'MONTHLY RATE PROMO%') AND (vr2.Rate_Name LIKE 'MONTHLY RATE PROMO%'))
                   or ((vr1.Rate_Name LIKE '%season rate%' or vr1.Rate_Name LIKE '%AP%') AND (vr2.Rate_Name LIKE '%weekly%' or vr2.Rate_Name LIKE '%season rate%'))
		   --or ((vr1.Rate_Name LIKE '%season rate%') AND (vr2.Rate_Name LIKE '%season rate%'))			  
		   OR ((vr1.Rate_Name LIKE 'Daily%') AND (vr2.Rate_Name LIKE 'X%'))
		   OR ((vr1.Rate_Name LIKE 'AHI%') AND (vr2.Rate_Name LIKE 'AHI%'))
		   OR ((vr1.Rate_Name LIKE 'AFI%') AND (vr2.Rate_Name LIKE 'AFI%'))
		   OR ((vr1.Rate_Name LIKE 'AEI%') AND (vr2.Rate_Name LIKE 'AEI')))


		   or ((vr1.Rate_Name LIKE '50Truck%') AND (vr2.Rate_Name LIKE '50Truck%'))	
		   or ((vr1.Rate_Name LIKE 'SSS%') AND (vr2.Rate_Name LIKE '50Truck%'))			  
		   or ((vr1.Rate_Name LIKE '50Truck%') AND (vr2.Rate_Name LIKE 'SSS%'))		

		   or ((vr1.Rate_Name LIKE 'KM Truck%') AND (vr2.Rate_Name LIKE 'KM Truck%'))	
		   or ((vr1.Rate_Name LIKE 'KM Truck%') AND (vr2.Rate_Name LIKE '50Truck%'))			  
		   or ((vr1.Rate_Name LIKE '50Truck%') AND (vr2.Rate_Name LIKE 'KM Truck%'))		

		   or ((vr1.Rate_Name LIKE '50 Truck%') AND (vr2.Rate_Name LIKE '50 Truck%'))	
		   or ((vr1.Rate_Name LIKE '100 Truck%') AND (vr2.Rate_Name LIKE '100 Truck%'))	
		   or ((vr1.Rate_Name LIKE '50 Truck%') AND (vr2.Rate_Name LIKE '100 Truck%'))	
		   or ((vr1.Rate_Name LIKE '100 Truck%') AND (vr2.Rate_Name LIKE '50 Truck%'))	
		   or ((vr1.Rate_Name LIKE 'KM Truck%') AND (vr2.Rate_Name LIKE '50 Truck%'))	
		   or ((vr1.Rate_Name LIKE '50 Truck%') AND (vr2.Rate_Name LIKE 'KM Truck%'))	
		   or ((vr1.Rate_Name LIKE 'KM Truck%') AND (vr2.Rate_Name LIKE '100 Truck%'))	
		   or ((vr1.Rate_Name LIKE '100 Truck%') AND (vr2.Rate_Name LIKE 'KM Truck%'))	

		   or ((vr1.Rate_Name LIKE 'Block%') AND (vr2.Rate_Name LIKE 'Block%'))	
		   or ((vr1.Rate_Name LIKE 'Block%') AND (vr2.Rate_Name LIKE '%Daily%'))	
		   or ((vr1.Rate_Name LIKE '%Daily%') AND (vr2.Rate_Name LIKE 'Block%'))	

Insert into Location_Vehicle_Rate_Level
SELECT   DISTINCT  dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID, dbo.LocationVehicleRateLevel.Rate_ID, dbo.LocationVehicleRateLevel.Rate_Level, 
                      dbo.LocationVehicleRateLevel.Location_Vehicle_Rate_Type, dbo.LocationVehicleRateLevel.Valid_From, dbo.LocationVehicleRateLevel.Valid_To, 
                      dbo.LocationVehicleRateLevel.Rate_Selection_Type
FROM         dbo.LocationVehicleRateLevel INNER JOIN
                      dbo.Location_Vehicle_Class ON dbo.LocationVehicleRateLevel.Location_ID = dbo.Location_Vehicle_Class.Location_ID AND 
                      dbo.LocationVehicleRateLevel.Vehicle_Class_Code = dbo.Location_Vehicle_Class.Vehicle_Class_Code
where    (dbo.Location_Vehicle_Class.Valid_to>getdate() or dbo.Location_Vehicle_Class.Valid_to is null)
--and (dbo.LocationVehicleRateLevel.Location_ID<>156)








GO
