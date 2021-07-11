USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_15_Vehicle_Utilization]    Script Date: 2021-07-10 1:50:50 PM ******/
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

create PROCEDURE [dbo].[RP_SP_Flt_15_Vehicle_Utilization] -- '01 sep 2011','21 sep 2011','Car'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
    @Vehicle_Type  CHAR(5)  = '*'
)
AS
DECLARE 	@startDate datetime,
			@endDate datetime

SELECT
	@startDate	=CONVERT(datetime,  @paramStartDate+' 00:00:00' ),
	@endDate	= CONVERT(datetime,  @paramEndDate+' 23:59:59')	

select rp_date,current_location_name as Location,
		sum(rentable) as Rentable,
		sum(not_rentable) as Not_Rentable,
		sum(Rented) as Rented
from RP_Flt_15_Vehicle_Utilization
WHERE	rp_date BETWEEN @startDate AND @endDate
and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)
group by rp_date,current_location_name
order by rp_date



GO
