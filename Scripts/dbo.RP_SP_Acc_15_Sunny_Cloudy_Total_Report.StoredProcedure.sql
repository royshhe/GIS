USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Total_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Total_Report]-- '01 jun 2011','01 jun 2011'
(
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000'
)
AS
DECLARE 	@startDate datetime,
			@endDate datetime

SELECT
	@startDate	=CONVERT(datetime,  @paramStartDate+' 00:00:00' ),
	@endDate	= CONVERT(datetime,  @paramEndDate+' 23:59:59')	


SELECT	Rp_Date,
		'5' as Section,
		'Utilization' as Location_Name,	
		Vehicle_Type_ID,
		'5' as sunnycloudycode,
		sum(case when section='1' --or section='2'
				then FleetNumber
				else 0
			end)  as Onrent,
		sum (FleetNumber) as Total
from
		(SELECT	Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	 rp_date BETWEEN @startDate AND @endDate

		union 
		--Average 
		select	rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				avg(FleetNumber)
		from 
		(SELECT	CONVERT(datetime,  '1900-01-01 00:00:00' ) as rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	rp_date BETWEEN @startDate AND @endDate) Average
		group by Rp_Date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode
) ut
group by rp_date,Vehicle_Type_ID



GO
