USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
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

CREATE PROCEDURE [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Report]  --'01 oct 2012','31 oct 2012','truck'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000',
    @Vehicle_Type  CHAR(5)  = '*'
)
AS
DECLARE 	@startDate datetime,
			@endDate datetime
--			@startDatePlus1 datetime,
--			@endDatePlus1 datetime

SELECT
	@startDate	=CONVERT(datetime,  @paramStartDate+' 00:00:00' ),
	@endDate	= CONVERT(datetime,  @paramEndDate+' 23:59:59')	
--	@startDatePlus1	=dateadd(dd,1,CONVERT(datetime,  @paramStartDate+' 00:00:00' )),
--	@endDatePlus1	=  dateadd(dd,1,CONVERT(datetime,  @paramEndDate+' 23:59:59'))	

SELECT	Rp_Date,
		Section,
		Location_Name,
		Vehicle_Type_ID,
		sunnycloudycode,
		convert(decimal(9,2),FleetNumber) as FleetNumber
--select *
FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
WHERE	rp_date BETWEEN @startDate AND @endDate
and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

union 
--Average 
select	rp_date,
		Section,
		Location_Name,
		Vehicle_Type_ID,
		sunnycloudycode,
		round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0) as FleetNumber
from 
(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
		Section,
		Location_Name,
		Vehicle_Type_ID,
		sunnycloudycode,
		convert(decimal(9,2),FleetNumber) as FleetNumber

FROM RP_SP_Acc_15_Sunny_Cloudy_vw
WHERE	rp_date BETWEEN @startDate AND @endDate
and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

	) Average
group by Rp_Date,
		Section,
		Location_Name,
		Vehicle_Type_ID,
		sunnycloudycode

union

SELECT	Rp_Date,
		Section,
		(case when Section='1' 
				then '98-Total On Rent' 
			 when Section='2'
				then '98-Total Available' 
			 when Section='3'
				then '98-Total In Service'
		end ) as Location_Name,	
		Vehicle_Type_ID,
		'1' as sunnycloudycode,
		sum(FleetNumber) as FleetNumber
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber
		--select *
		FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

		union 
		--Average 
		select	rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				convert(decimal(9,2),FleetNumber) as FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

			) Average
		group by Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode
) subTotal
group by rp_date,Section,Vehicle_Type_ID

union 

SELECT	Rp_Date,
		'4' as Section,
		'98-Total' as Location_Name,	
		Vehicle_Type_ID,
		'4' as sunnycloudycode,
		sum(FleetNumber) as FleetNumber
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber
		--select *
		FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

		union 
		--Average 
		select	rp_date,
				'4' as Section,
				'98-Total' as Location_Name,
				Vehicle_Type_ID,
				'4' as sunnycloudycode,
				round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				convert(decimal(9,2),FleetNumber) as FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

			) Average
		group by Rp_Date,
--				Section,
--				Location_Name,
				Vehicle_Type_ID--,
--				sunnycloudycode
) Total
group by rp_date,Vehicle_Type_ID

union

SELECT	Rp_Date,
		'1' as Section,
		'99-' as Location_Name,	
		Vehicle_Type_ID,
		'1' as sunnycloudycode,
		0 as FleetNumber
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber
		--select *
		FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

		union 
		--Average 
		select	rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				convert(decimal(9,2),FleetNumber) as FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

			) Average
		group by Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode
) Total
group by rp_date,Vehicle_Type_ID


union

SELECT	Rp_Date,
		'2' as Section,
		'99-' as Location_Name,	
		Vehicle_Type_ID,
		'2' as sunnycloudycode,
		0 as FleetNumber
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber
		--select *
		FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

		union 
		--Average 
		select	rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				convert(decimal(9,2),FleetNumber) as FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

			) Average
		group by Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode
) Total
group by rp_date,Vehicle_Type_ID



union

SELECT	Rp_Date,
		'3' as Section,
		'99-' as Location_Name,	
		Vehicle_Type_ID,
		'3' as sunnycloudycode,
		0 as FleetNumber
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber
		--select *
		FROM RP_SP_Acc_15_Sunny_Cloudy_vw 
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

		union 
		--Average 
		select	rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				round(convert(decimal(9,2),sum(FleetNumber)/(datediff(dd,@startDate,@endDate)+1)),0)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				convert(decimal(9,2),FleetNumber) as FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate
		and (@Vehicle_Type = '*'	 OR	 Vehicle_Type_ID = @Vehicle_Type	)

			) Average
		group by Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode
) Total
group by rp_date,Vehicle_Type_ID




GO
