USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_12_CSR_Incentive_Pay]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		15 Jun 2003
--	Modification:
--	Vivian Leung	15 Jul 2003	Include Walkup upsell incentive
---------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[RP_SP_Acc_12_CSR_Incentive_Pay]
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

-- delete  [dbo].[CSRIncYield]

--  AdditionalDriverRate, ChildSeatRate, UnderAgeRate, UpSellRate, LDWRate, PAIRate, PECRate


-- insert INTO	dbo.CSRIncYield
SELECT 	
	l.Location,
	r1.Vehicle_Type_ID,
   	r1.CSR_Name,
   	Count(r1.Contract_number) 	as Contract_In,
	Sum(r1.Contract_Rental_Days) 	as Rental_Days,
	Sum(Walk_up)*WalkupRate			as Walk_Up,
	sum(case  when FPOCount=1 and FPO > .00
		then 1
		 else 0 
		 end)*FPORate			as FPO,
	

	(sum( case when r1.Contract_Revenue > r1.Reservation_Revenue and Walk_up = 0
		 then r1.Contract_Revenue - r1.Reservation_Revenue
		else 0 
		end)	+ sum(upgrade)
			+ sum(r2.Upsell_Difference))*UpSellRate		as Up_sell,
	sum(Additional_Driver_Charge)*AdditionalDriverRate 	as Additional_Driver_Charge,
	sum(All_Seats)*ChildSeatRate 			as All_Seats,
	sum(Driver_Under_Age)*UnderAgeRate 		as Driver_Under_Age,
	sum(All_Level_LDW)* LDWRate		as All_Level_LDW,
	sum(PAI)*PAIRate 			as PAI,
	sum(PEC)*PECRate 			as PEC
	
	--sum(Ski_Rack) 			as Ski_Rack,
	--sum(All_Dolly)			as All_Dolly,
	--sum(All_Gates)			as All_Gates,
	--sum(Blanket)			as Blanket,
	--Sum(Walk_up)                    as WalkUPCount,
        
FROM 	RP_Acc_12_CSR_Incentive_Report_L2 r1
inner join 
location l
	on l.location_id = r1.pick_up_location_id
left join 
RP_Acc_12_CSR_Walkup_Incentive_L2 r2
on r1.contract_number = r2.contract_number


WHERE	r1.RBR_Date BETWEEN @startBusDate and @endBusDate
GROUP BY 	l.Location,
		r1.pick_up_location_id,
   		r1.CSR_Name,
		r1.Vehicle_Type_ID,
               	 r1.FPORate,
       		r1.WalkUpRate,
		r1.AdditionalDriverRate, 
		r1.ChildSeatRate, 
		r1.UnderAgeRate, 
		r1.UpSellRate, 
		r1.LDWRate, 
		r1.PAIRate, 
		r1.PECRate
order by r1.Pick_Up_Location_ID, r1.Vehicle_Type_ID
GO
