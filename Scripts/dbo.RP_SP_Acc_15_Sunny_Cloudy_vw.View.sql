USE [GISData]
GO
/****** Object:  View [dbo].[RP_SP_Acc_15_Sunny_Cloudy_vw]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PROCEDURE NAME: [RP_SP_Acc_15_Sunny_Cloudy_Report]
PURPOSE: Select all information needed for Reservation Build Up On Rent Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY:  Reservation Build Up On Rent Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 4 1999	add filtering to improve performance
*/

create view [dbo].[RP_SP_Acc_15_Sunny_Cloudy_vw]

AS
--Local
SELECT 	
	Rp_Date,
	'1' as Section,
	Location_Name as location_name,
	Vehicle_Type_ID,
	sunnycloudycode,
	Rented as FleetNumber
FROM 	RP_SP_Acc_15_Sunny_Cloudy_Local_vw
where sunnycloudycode='1'

union

SELECT 	
	Rp_Date,
	'1' as Section,
	Location_Name,
	Vehicle_Type_ID,
	sunnycloudycode,
	Rented as FleetNumber
FROM 	RP_SP_Acc_15_Sunny_Cloudy_OneWay_vw

union
select 
	Rp_Date,
	'2' as Section,
	Location_Name as location_name,
	Vehicle_Type_ID,
	sunnycloudycode,
	available as FleetNumber
from RP_SP_Acc_15_Sunny_Cloudy_Local_vw
where sunnycloudycode in ('1' ,'2')

union

SELECT 	
	Rp_Date,
	'2' as Section,
	'88_OUT OF TOWN P3' as Location_Name,
	Vehicle_Type_ID,
	sunnycloudycode,
	available as FleetNumber
FROM 	RP_SP_Acc_15_Sunny_Cloudy_OneWay_vw

union
select 
	Rp_Date,
	'3' as Section,
	Location_Name,
	Vehicle_Type_ID,
	sunnycloudycode,
	available as FleetNumber
from RP_SP_Acc_15_Sunny_Cloudy_Local_vw
where sunnycloudycode in ('3')
GO
