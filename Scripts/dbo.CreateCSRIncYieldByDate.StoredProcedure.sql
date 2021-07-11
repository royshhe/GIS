USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCSRIncYieldByDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Feb 2002
--	Details		Sum all items, seperate in different columns and put results into table CSRIncYield
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[CreateCSRIncYieldByDate]
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


-- only when it exist we drop it
--if exists (select * from sysobjects where id = object_id(N'[dbo].[CSRIncYield]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[CSRIncYield]


--EXEC sp_dboption 'GISDATA', 'select into/bulkcopy', 'TRUE'

delete  [dbo].[CSRIncYield]

insert INTO	dbo.CSRIncYield
SELECT 	
	Pick_Up_Location_ID,
	Vehicle_Type_ID,
   	CSR_Name,
   	Count(Contract_number) 	as Contract_In,
	Sum(Contract_Rental_Days) 	as Rental_Days,
	Sum(Walk_up)*WalkupRate			as Walk_Up,
	sum(case when FPOCount=1 and FPO > .00
		then 1
		 else 0 
		 end)*FPORate			as FPO,
	
	--Sum(Walk_up)			as Walk_up,
	--sum(FPO) 		as FPO ,

        -- We don't know why this logic is here
        -- we have to reverse back to the old logic

	--sum( case when Contract_Revenue > Reservation_Revenue and Walk_up = 0
	--	 then Contract_Revenue - Reservation_Revenue
	--	else 0 
	--	end)	+ 
	--sum(case when Contract_Revenue <=  Reservation_Revenue and upgrade > 0
	--	then upgrade
	--	else 0
	--	end)		as Up_sell,

         -- fix the problem of discrepency of upgrade and upsell, when there is upgrade, don't use upsell.

        sum( case when Contract_Revenue > Reservation_Revenue and Walk_up = 0 and upgrade=0
		 then Contract_Revenue - Reservation_Revenue
		else 0 
		end)	+ sum(upgrade)		as Up_sell,

	sum(Additional_Driver_Charge) 	as Additional_Driver_Charge,
	sum(All_Seats) 			as All_Seats,
	sum(Driver_Under_Age) 		as Driver_Under_Age,
	sum(All_Level_LDW) 		as All_Level_LDW,
	sum(PAI) 			as PAI,
	sum(PEC) 			as PEC,
	sum(Ski_Rack) 			as Ski_Rack,
	sum(All_Dolly)			as All_Dolly,
	sum(All_Gates)			as All_Gates,
	sum(Blanket)			as Blanket,
	Sum(Walk_up)                    as WalkUPCount,
        sum(case when FPOCount=1 and FPO > .00
		then 1
		 else 0 
		 end) 			as FPOCount ,
	sum(case when AdditionalDriverChargeCount>0
		then 1
		 else 0 
		 end) 	as AdditionalDriverChargeCount,
             sum(case when Contract_Revenue > Reservation_Revenue 
		 then 1
		 else 0 
		 end )                                               as UpsellCount,	
	sum(case when AllSeatsCount>0
		then 1
		 else 0 
		 end) 			as AllSeatsCount,
	sum(case when DriverUnderAgeCount>0
		then 1
		 else 0 
		 end) 		as DriverUnderAgeCount,
	sum(case when AllLevelLDWCount>0
		then 1
		 else 0 
		 end) 		as AllLevelLDWCount,
	sum(case when PAICount>0
		then 1
		 else 0 
		 end) 			as PAICount,
	sum(case when PECCount>0
		then 1
		 else 0 
		 end) 			as PECCount,
	sum(case when SkiRackCount>0
		then 1
		 else 0 
		 end) 			as SkiRackCount,
	sum(case when AllDollyCount>0
		then 1
		 else 0 
		 end)			as AllDollyCount,
	sum(case when AllGatesCount>0
		then 1
		 else 0 
		 end)			as AllGatesCount,
	sum(case when BlanketCount>0
		then 1
		 else 0 
		 end)			as BlanketCount

FROM 	RP_Acc_12_CSR_Incremental_Yield_L2


WHERE	RBR_Date BETWEEN @startBusDate and @endBusDate
		and CSR_Name not like 'Fast%Break%'
GROUP BY 	Pick_Up_Location_ID,
   		CSR_Name,
		Vehicle_Type_ID,
                FPORate,
       		WalkUpRate

--EXEC sp_dboption 'GISDATA', 'select into/bulkcopy', 'FALSE'


GO
