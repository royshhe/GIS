USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CSRIncentiveRevenue_Detail_CP]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[RP_SP_Acc_17_CSRIncentiveRevenue_Detail_CP] --'2015-01-01', '2015-01-31'
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
	r1.RBR_Date,
        csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id as Location_ID,
	l.Location,
	r1.Vehicle_Type_ID,
   	case when csr.active = 0
		then r1.CSR_Name + ' (T)'
		else r1.CSR_Name
		end 					as CSR_Name,
   	r1.Contract_number,
	r1.Walk_up					as Walk_Up,
	
	(case when ((Rate_Purpose<>'Tour Pkg' 
					and rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate')
--					and (Customer_Program_Number is null) 
--					and (Applicant_Status_Indicator=0)
					)  
				or  r1.All_Level_LDW<>0 or r1.PAI<>0 or r1.PEC<>0 or r1.Upgrade<>0)
		then Contract_Rental_Days
		else 0
	 	end
	) 	as Rental_Days,
	
	(	Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Upgrade
			Else 0
        	End) 		as Upgrade,

	(case when  r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0
			and rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')
		 then  r1.Contract_Revenue -  r1.Reservation_Revenue
		else 0 
	 end) as Up_Sell,


  	(r1.All_Level_LDW)				as All_Level_LDW,
    (Case When r1.All_Level_LDW>0 Then Contract_Rental_Days Else 0 End) LDWContractRentalDays,
   	(r1.PAI)					as PAI,
	(r1.PEC) 					as PEC,        
	
	(	Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Additional_Driver_Charge
			Else 0
        	End) 		as Additional_Driver_Charge,

	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.All_Seats
			Else 0
	     	End
	 ) 	

	 as All_Seats,


	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then Driver_Under_Age
			Else 0
	     	End
	 ) 	
	as Driver_Under_Age,	
--	(r1.Driver_Under_Age)			
				
	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Ski_Rack
			Else 0
	     	End
	 ) 	
	as Ski_Rack,

	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Seat_Storage
			Else 0
	     	End
	 ) 	
	
	as Seat_Storage,
	
	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Our_Of_Area
			Else 0
	     	End
	 ) 	

	as Our_Of_Area,


	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.All_Dolly
			Else 0
	     	End
	 ) 	

	as All_Dolly,
	
	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.All_Gates
			Else 0
	     	End
	 ) 	
	
	as All_Gates,

	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Blanket
			Else 0
	     	End
	 ) 	
	
	as Blanket,
	
	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then r1.Walkup_Rental_Days
			Else 0
	     	End
	 ) 	


	as Walkup_Rental_Days,
	
	--sum(Walkup_Rental_Time_Revenue)	


	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then Walkup_Rental_Time_Revenue
			Else 0
	     	End
	 ) 	

	+

	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then Walkup_Rental_KM_Charge
			Else 0
	     	End
	 )
 	
	--(Walkup_Rental_KM_Charge)			

	as Walkup_TnM,

	(
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'special monthly rate', 'GAI', 'Budget Monthly Rate') then Walkup_Count
			Else 0
	     	End
	 ) 	

        as Walkup_Count,
	
	(FPO_Contract_Count) 			as FPO_Contract_Count,
	(case when r1.FPOCount=1 and r1.FPO > .00
		 then 1
	    	 when r1.FPOCount=-1 and r1.FPO < .00
		 then -1	
		 else 0 
		 end)					as FPOCount	        	
	
FROM 	RP_Acc_17_CSR_Incentive_Report_L2_CP r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select distinct u.user_id, u.user_name, u.active, u.employeeID
from GISUsers u
) csr
	on csr.user_name = r1.CSR_Name
WHERE	(r1.RBR_Date BETWEEN @startBusDate and @paramEndBusDate)-- and  (r1.CSR_Name  like 'Peter Ni')






GO
