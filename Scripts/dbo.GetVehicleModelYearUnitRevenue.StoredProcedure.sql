USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelYearUnitRevenue]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVehicleModelYearUnitRevenue]
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
	@endBusDate	= CONVERT(datetime, '00:00:00 ' + @paramEndBusDate)	

  
	select hub_id,
	Vehicle_Type_ID, 
	Vehicle_Class_Name,
	model_name,
	model_year,
	unit_number,
             Inservice as InserverviceDate,

	DATEDIFF(mi, @startBusDate,@endBusDate) / 1440.0 as InserviceDays,

	sum (Contract_Rental_Days) as RentalDays,
	sum(KmDriven) as KilometerDriven,
	SUM(CASE WHEN Charge_Type IN (10, 11, 20, 50, 51, 52)
		THEN Amount
		ELSE 0
		END)	as Contract_Revenue,
	SUM(Case
		When (Optional_Extra_ID in (8, 9, 10, 11, 12, 13, 14, 15, 16, 22, 27, 28, 29, 30, 31, 32, 33, 34, 36,  37, 38, 39, 40,41,42,43,44)
			OR (Charge_Type = 61 AND Charge_Item_Type = 'a')) -- adjustment charge for LDW
		Then Amount
		ELSE 0
		END)	as LDW,
	SUM(Case	When Optional_Extra_ID = 20
			OR (Charge_Type = 62 AND Charge_Item_Type = 'a') -- adjustment charge for PAI
		Then Amount
		ELSE 0
		END)	as PAI,
	SUM(Case	When Optional_Extra_ID = 21
			OR (Charge_Type = 63  AND Charge_Item_Type = 'a') -- adjustment charge for PEC
		Then Amount
		ELSE 0
		END)	as PEC

FROM ViewVehicletUnitRevenueAll
where rbr_date between @startBusDate and @endBusDate+1

GROUP BY unit_number,
	Vehicle_Type_ID, 
	Vehicle_Class_Name,
	model_name,
	model_year,
	hub_id,
             Inservice

order by  
	
	
	hub_id,
Vehicle_Type_ID, 
	Vehicle_Class_Name,
model_name,
	model_year,
unit_number,
Inservice
GO
