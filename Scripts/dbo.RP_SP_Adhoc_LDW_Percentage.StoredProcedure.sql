USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_LDW_Percentage]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[RP_SP_Adhoc_LDW_Percentage] --'2006-01-01', '2006-12-31'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

SELECT 	
	
	l.Location,
	year(r1.RBR_Date) 		as TransYear,
	month(r1.RBR_Date) 		as TransMonth,	
   	Count(r1.Contract_number) 	as Contract_In,	
	Sum(r1.Contract_Rental_Days) 	as Rental_Days, -- not including Tour Rate Rental Days		
  	sum(r1.AllLevelLDWCount)	as AllLevelLDWCount,
	sum(r1.BuyDownCount)		as BuyDownCount,
	sum(r1.PAICount)		as PAICount,
	sum(r1.PECCount) 		as PECCount
	
FROM 	RP_Adhoc_LDW_Percentage r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id

WHERE	(r1.RBR_Date BETWEEN @startBusDate and @endBusDate) 
GROUP BY 	
		l.Location,   		
		year(r1.RBR_Date),
		month(r1.RBR_Date)

GO
