USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_12_CreateCSRRevenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[RP_SP_Acc_12_CreateCSRRevenue]
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


delete CSRIncentiveRevenue


insert INTO CSRIncentiveRevenue
SELECT 	csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id as Location_ID,
	l.Location,
	r1.Vehicle_Type_ID,
   	case when csr.active = 0
		then r1.CSR_Name + ' (T)'
		else r1.CSR_Name
		end 					as CSR_Name,
   	Count(r1.Contract_number) 			as Contract_In,
	Sum(r1.Contract_Rental_Days) 			as Rental_Days,
	Sum(r1.Walk_up)				as Walk_Up,
	sum(case when r1.FPOCount=1 and r1.FPO > .00
		then 1
		 else 0 
		 end)					as FPO,
	

  -- We don't know why this logic is here
  -- fix the problem of discrepency of upgrade and upsell, when there is upgrade, don't use upsell.

  --	(sum( case when r1.Contract_Revenue > r1.Reservation_Revenue and r1.Walk_up = 0
	--	 then r1.Contract_Revenue - r1.Reservation_Revenue
	--	else 0 
	--	end)	
	--+ sum(case when r1.Contract_Revenue <= r1.Reservation_Revenue and r1.upgrade > 0
	--	then r1.upgrade
	--	else 0
	--	end)
	--+ sum(case when r2.Upsell_Difference is null
	--		then 0
	--		else r2.Upsell_Difference
	--		end)
	--) --*0.5	


        sum( case when  r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0
		 then  r1.Contract_Revenue -  r1.Reservation_Revenue
		else 0 
		end)	
	
	+ sum( r1.upgrade)	                       as Up_sell,

	sum(case when r2.Upsell_Difference is null
			then 0
			else r2.Upsell_Difference
			end)                            as Up_sell_Walkup,
	
	
	sum(r1.Additional_Driver_Charge) 		as Additional_Driver_Charge,
	sum(r1.All_Seats) 				as All_Seats,
	sum(r1.Driver_Under_Age)			as Driver_Under_Age,
	sum(r1.All_Level_LDW)				as All_Level_LDW,
	sum(r1.PAI)					as PAI,
	sum(r1.PEC) 					as PEC,
	sum(r1.Ski_Rack) 				as Ski_Rack,
	sum(r1.All_Dolly)				as All_Dolly,
	sum(r1.All_Gates)				as All_Gates,
	sum(r1.Blanket)					as Blanket,

	
	-- Pay Out Calculations
	sum(r1.Walk_up)*WalkupRate			as Walk_Up_PO,
	sum(case  when r1.FPOCount=1 and r1.FPO > .00
		then 1
		 else 0 
		 end)*FPORate				as FPO_PO,
	(sum( case when r1.Contract_Revenue > r1.Reservation_Revenue and Walk_up = 0
		 then r1.Contract_Revenue - r1.Reservation_Revenue
		else 0 
		end)	
		+ sum(case when r1.Contract_Revenue <= r1.Reservation_Revenue and r1.upgrade > 0
			then r1.upgrade
			else 0
			end)
		+ sum(case when r2.Upsell_Difference is null
			then 0
			else r2.Upsell_Difference
			end)
	)*UpSellRate--*0.5					
								as Up_sell_PO,
	sum(Additional_Driver_Charge)*AdditionalDriverRate 	as Additional_Driver_Charge_PO,
	sum(All_Seats)*ChildSeatRate				as All_Seats_PO,
	sum(Driver_Under_Age)*UnderAgeRate 			as Driver_Under_Age_PO,
	sum(All_Level_LDW)* LDWRate				as All_Level_LDW_PO,
	sum(PAI)*PAIRate 					as PAI_PO,
	sum(PEC)*PECRate 					as PEC_PO,
	sum(r1.Ski_Rack)* SkiRackRate				as Ski_Rack_PO,
	sum(r1.All_Dolly)*DolliesRate				as All_Dolly_PO,
	sum(r1.All_Gates)*GateRate				as All_Gates_PO,
	sum(r1.Blanket)*BlanketRate				as Blanket_PO

FROM 	RP_Acc_12_CSR_Incentive_Report_L2 r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select u.user_id, u.user_name, u.active, u.employeeID, g.group_name
from GISUsers u
inner join
GISusergroup g
on u.user_id = g.user_id
where (group_name like 'Location CSR%' or group_name = 'Location Manager')
 and active = 1 --and u.user_id <>'kbertrand'
) csr
	on csr.user_name = r1.CSR_Name
left join 
RP_Acc_12_CSR_Walkup_Incentive_L2 r2
	on r1.contract_number = r2.contract_number
WHERE	(r1.RBR_Date BETWEEN @startBusDate and @endBusDate) and  (r1.CSR_Name not like 'Fast%Break%')
GROUP BY 	csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id,
		l.Location,
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
		r1.PECRate,
		DolliesRate,
		GateRate,
		BlanketRate,
		SkiRackRate

GO
