USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Weather_Report]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[RP_SP_Acc_15_Sunny_Cloudy_Weather_Report] --'01 sep 2011','29 sep 2011'
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


SELECT	 distinct convert(datetime,convert(varchar,ut.Rp_Date,111)) as Rp_Date,
		case when ut.Rp_Date=CONVERT(datetime, '1900-01-01 00:00:00.000')
				then convert(Varchar(10),datediff(dd,@startDate,@endDate)+1)
				else sc.type
		end as type 

from
		(SELECT	convert(varchar,Rp_Date,111) as Rp_date,
				Section,
				Location_Name,
				Vehicle_Type_ID,
				sunnycloudycode,
				FleetNumber

		FROM RP_SP_Acc_15_Sunny_Cloudy_vw
		WHERE	 rp_date BETWEEN  @startDate AND @endDate

		union 
		--Average 
		select	convert(varchar,rp_date,111) as Rp_date,
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

left join rp_sunny_cloudy sc on 	convert(varchar,ut.Rp_Date,111)=convert(varchar,sc.rp_date,111)



GO
