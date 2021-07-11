USE [GISData]
GO
/****** Object:  View [dbo].[PM_Service_Listing_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[PM_Service_Listing_vw]
AS
SELECT PTD.Unit_Number, 
	   SCat.Value AS Service, 
	   SType.Value AS ServiceType, 
	   PTD.Last_Service_Date, 
	   PTD.KM_Reading AS LastKMReading, 
	   PTD.Current_Km, 
       'Date' AS Tracking_Type,  
       PTD.NextServiceDate,
       NULL as NextServiceKM,
       (CASE WHEN PTD.Status = 0 THEN 'Due' 
			 WHEN PTD.Status = - 1 THEN 'Over Due' 
			 WHEN PTD.Status = 1 THEN 'Not Due' 
		END) AS Status,
		Date_Overdue_Restrict Rental_Restriction
FROM  dbo.PM_Tracking_Date_vw AS PTD 
INNER JOIN (Select * from dbo.Lookup_Table where category='PM Service')  AS SCat 
	ON PTD.Service_Code = SCat.Code 
INNER JOIN (Select * from dbo.Lookup_Table where category='PM Service Type') AS SType 
	ON PTD.Type = SType.Code
	
	
union

SELECT PTM.Unit_Number, 
	   SCat.Value AS Service, 
	   SType.Value AS ServiceType, 
	   PTM.Last_Service_Date, 
	   PTM.KM_Reading AS LastKMReading, 
	   PTM.Current_Km, 
       'Mileage' AS Tracking_Type,  
       NULL as NextServiceDate,
       PTM.NextServiceKM as NextServiceKM,
       (CASE WHEN PTM.Status = 0 THEN 'Due' 
			 WHEN PTM.Status = - 1 THEN 'Over Due' 
			 WHEN PTM.Status = 1 THEN 'Not Due' 
		END) AS Status,
		Mileage_Overdue_Restrict Rental_Restriction
FROM  dbo.PM_Tracking_Mileage_vw AS PTM 
INNER JOIN (Select * from dbo.Lookup_Table where category='PM Service')  AS SCat 
	ON PTM.Service_Code = SCat.Code 
INNER JOIN (Select * from dbo.Lookup_Table where category='PM Service Type') AS SType 
	ON PTM.Type = SType.Code
GO
