USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelYearRevenueSummary]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVehicleModelYearRevenueSummary] --'2003-06-01', '2003-06-01'
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

SELECT 	

        Vehicle_Type_ID,
        Vehicle_Class_Name,
        model_name,
	model_year,
	sum(Contract_Rental_Days) as RentalDays,
        sum(KmDriven) as KmDriven,	
   	Count(Contract_number) 	as Contract_In,
	sum(TimeKmCharge) as TimeKmCharge,
	sum(All_Level_LDW) as AllLDW
	
FROM 	ViewContractRevenueAllSum

WHERE	RBR_Date BETWEEN @startBusDate and @endBusDate+1
		GROUP BY 	Vehicle_Type_ID,
        Vehicle_Class_Name,
        model_name,
	model_year



GO
