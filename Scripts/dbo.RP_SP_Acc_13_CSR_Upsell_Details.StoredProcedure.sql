USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_13_CSR_Upsell_Details]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_Acc_13_CSR_Upsell_Details]
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



SELECT 	csr.EmployeeID,
	csr.active,
	r1.pick_up_location_id as Location_ID,
	l.Location,
	r1.Vehicle_Type_ID,
   	case when csr.active = 0
		then r1.CSR_Name + ' (T)'
		else r1.CSR_Name
		end 					as CSR_Name,
        r1.contract_number,      
	r1.Rental_Time_Revenue,
	r2.BaseAmount,
	r1.Contract_TnKm_Revenue,
	r1.Rental_KM_Charge,
	r1.Reservation_Revenue,
	    
        (case when  (r1.Contract_TnKm_Revenue)>  (r1.Reservation_Revenue) and  r1.Walk_up = 0 and  r1.upgrade=0 and Res.Confirmation_number is not null
		 then  (Contract_TnKm_Revenue)-  (r1.Reservation_Revenue)
		else 0 
		end)	 ReservatioinUpSell,	
	
	r1.upgrade,

	(case when (r1.Rental_Time_Revenue > r2.BaseAmount) and (r2.BaseAmount>0)
				then r1.Rental_Time_Revenue - r2.BaseAmount
				else 0
				end) as Up_sell_Walkup,
       dbo.GetRentalDays(RentalHours)as Rental_Days,r2.Rate_Name as ContractRateName, 
       r2.Rate_Level as ContractRateLevel, 
       DailyBaseAmount, WeeklyBaeRateAmount--,DailyBaseRateName, WeeklyBaseRateName

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
RP_Acc_12_CSR_Incentive_Walkup_BaseAmount r2
	on r1.contract_number = r2.contract_number
left join 
(SELECT     dbo.Reservation.Confirmation_Number,
	    dbo.Vehicle_Rate.Rate_Purpose_ID as GIS_Rate_Purpose_ID, 
	    dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID as Maestro_Rate_Purpose_ID
	FROM         dbo.Reservation LEFT OUTER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID LEFT OUTER JOIN
                      dbo.Vehicle_Rate ON dbo.Reservation.Rate_ID = dbo.Vehicle_Rate.Rate_ID
WHERE     (dbo.Vehicle_Rate.Rate_Purpose_ID = 13 and  (Date_Rate_Assigned between dbo.Vehicle_Rate.Effective_Date and dbo.Vehicle_Rate.Termination_Date)) or
                      (dbo.Quoted_Vehicle_Rate.Rate_Purpose_ID = 13 and dbo.Vehicle_Rate.Rate_id is null )
)
Res 
	on r1.Confirmation_number=Res.Confirmation_number
WHERE	(r1.RBR_Date BETWEEN @startBusDate and @endBusDate) 
        /*and 
	(

	 	       (case when  (r1.Contract_TnKm_Revenue)>  (r1.Reservation_Revenue) and  r1.Walk_up = 0 and  r1.upgrade=0 and Res.Confirmation_number is not null
			 then  (Contract_TnKm_Revenue)-  (r1.Reservation_Revenue)
			else 0 
			end)<>0 
		      	or upgrade<>0 
			or 
		        (case when (r1.Rental_Time_Revenue > r2.BaseAmount) and (r2.BaseAmount>0)
					then r1.Rental_Time_Revenue - r2.BaseAmount
					else 0
					end)<>0
	)

       */




GO
