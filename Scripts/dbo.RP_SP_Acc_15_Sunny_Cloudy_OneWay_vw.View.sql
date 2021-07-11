USE [GISData]
GO
/****** Object:  View [dbo].[RP_SP_Acc_15_Sunny_Cloudy_OneWay_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PROCEDURE NAME: [RP_SP_Flt_15_Sunny_Cloudy_Report]
PURPOSE: Select all information needed for Reservation Build Up On Rent Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY:  Reservation Build Up On Rent Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 4 1999	add filtering to improve performance
*/

CREATE view [dbo].[RP_SP_Acc_15_Sunny_Cloudy_OneWay_vw]

AS
SELECT 	
	dateadd(dd,-1,Rp_Date) as Rp_Date,
	'88_One Way' as Location_Name,
    Vehicle_Type_ID,
	--l.rental_location,
	l.sunnycloudycode,
	sum(Rentable)+ sum(not_Rentable) as Available,
	sum(Rented) as Rented
--select *	
FROM 	RP_Acc_15_Vehicle_Utilization VU 
			inner join location l on vu.current_location_id=l.location_id

where  l.owning_company_ID<>(select code from lookup_Table where category='BudgetBC Company' )
 --and rp_date >='2011-08-02' and rp_date <'2011-08-03'
group by Rp_Date,Vehicle_Type_ID,l.sunnycloudycode
GO
