USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_PM_Service_Listing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PROCEDURE NAME: RP_SP_Flt_PM_Service_Listing
PURPOSE: PM_Service_Listing

AUTHOR:	Roy He
DATE CREATED: 2015/10/26
USED BY:  PM Services Listing Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_PM_Service_Listing]

AS
	SELECT Unit_Number, 
	Service, 
	ServiceType, 
	Last_Service_Date, 
	LastKMReading, 
	Current_Km, 
	Tracking_Type, 
	NextServiceDate, 
	NextServiceKM, 
	Status, 
	(Case When Tracking_Type='Date' then datediff(d, getdate(), nextServiceDate)
		 Else NULL
	End) ServiceDueInDay,

	(Case When Tracking_Type='Mileage' then NextServiceKM-Current_Km

		 Else NULL
	End) ServiceDueInKM,

	Rental_Restriction
	               
	FROM  dbo.PM_Service_Listing_vw
	order by Status,Tracking_Type
GO
