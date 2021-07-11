USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CSRIncentiveRevenue_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










--select * from gisusers where user_name like '%sm%'


CREATE PROCEDURE [dbo].[RP_SP_Acc_17_CSRIncentiveRevenue_Detail]--  '2016-01-26','2016-02-15'
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
	bcd_number,
	rate_name,	
	Rate_Purpose,	
	Applicant_Status_Indicator,
	Customer_Program_Number,

	 (case when( 	((Rate_Purpose<>'Tour Pkg' or Rate_Purpose is null) 
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
										 and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') 
									     and (rate_name Not Like '%Month%')	)
									or 
									(r1.All_Level_LDW<>0 or r1.PAi<>0 or r1.RSN<>0 or r1.ELI<>0 or r1.Upgrade<>0)
						)	--and  r1.pick_up_location_id in ('16','20')  			
						then Contract_Rental_Days
				--when(((bcd_number<>'A162000' and bcd_number<>'A044300')or (bcd_number is null))
				--			and  rate_name not like 'PBC%' 
				--			and  rate_name not like 'GOC%'
				--			and  rate_name not in ('14i','RCM','RCMP')
				--			and rate_name<>'01i'
				--			and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
				--		) 	and  pick_up_location_id not in ('16','20')  		
				--		then Contract_Rental_Days

						else 0
	 		end
	     ) 	as Rental_Days,

	
	 (
		Case 
			--when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%')  then r1.Upgrade
			--when  r1.pick_up_location_id  in ('16','20') and r1.Contract_number='1636002'  then r1.Upgrade
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate',  'Budget Monthly Rate')   then r1.Upgrade
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Upgrade
			Else 0
        	End
	)  as Upgrade,

--select * from Vehicle_rate where Rate_Name like '%Month%'

	 ( case when  r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0
			and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%') 
		 then  r1.Contract_Revenue -  r1.Reservation_Revenue
		else 0 
	     end
            ) as Up_Sell, 

  	 (r1.All_Level_LDW)				as All_Level_LDW,
	 (r1.PAI)					as PAE,
	 (r1.RSN) 				as RSN,     
         (r1.ELI) 			        as ELI,
         (r1.GPS)                             as GPS,
		r1.FPO	as FPO,
	
	 (	Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Additional_Driver_Charge
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Additional_Driver_Charge
			Else 0
        	End) 		as Additional_Driver_Charge,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Seats
			--when  r1.pick_up_location_id not in ('16','20')  then r1.All_Seats
			Else 0
	     	End
	 ) 	

	 as All_Seats,


	 (
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then Driver_Under_Age
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Driver_Under_Age
			Else 0
	     	End
	 ) 	
	as Driver_Under_Age,	
--	 (r1.Driver_Under_Age)			
				
	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Ski_Rack
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Ski_Rack
			Else 0
	     	End
	 ) 	
	as Ski_Rack,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Seat_Storage
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Seat_Storage
			Else 0
	     	End
	 ) 	
	
	as Seat_Storage,
	
	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Our_Of_Area
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Our_Of_Area
			Else 0
	     	End
	 ) 	

	as Our_Of_Area,


	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Dolly
			--when  r1.pick_up_location_id not in ('16','20')  then r1.All_Dolly
			Else 0
	     	End
	 ) 	

	as All_Dolly,
	
	 (
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Gates
				--when  r1.pick_up_location_id not in ('16','20')  then r1.All_Gates
		Else 0
	     	End
	 ) 	
	
	as All_Gates,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Blanket
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Blanket
			Else 0
	     	End
	 ) 	
	
	as Blanket,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Snow_Tire
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Snow_Tire
			Else 0
	     	End
	 ) 	
	as Snow_Tire,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.KPO_Package
			--when  r1.pick_up_location_id not in ('16','20')  then r1.KPO_Package
			Else 0
	     	End
	 ) 	
	as KPO_Package,
	
	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  then r1.Walkup_Rental_Days -- and (rate_name Not Like '%Month%')  per Nora/20110729
			--when  r1.pick_up_location_id not in ('16','20')  then r1.Walkup_Rental_Days
			Else 0
	     	End
	 ) 	


	as Walkup_Rental_Days,
	
	-- (Walkup_Rental_Time_Revenue)	


	 (
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   then Walkup_Rental_Time_Revenue --and (rate_name Not Like '%Month%')  
			--when  r1.pick_up_location_id not in ('16','20')  then Walkup_Rental_Time_Revenue
			Else 0
	     	End
	 ) 	

	+

	 (
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   then Walkup_Rental_KM_Charge-- and (rate_name Not Like '%Month%') 
			--when  r1.pick_up_location_id not in ('16','20')  then Walkup_Rental_KM_Charge
			Else 0
	     	End
	 )
 	
	-- (Walkup_Rental_KM_Charge)			

	as Walkup_TnM,


 (
		Case 
			when   rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%') And r1.Upgrade <>0 Then 1
			--when  r1.pick_up_location_id not in ('16','20') And r1.Upgrade <>0   then 1
			Else 0
        	End
	) 
-- +
-- ( case when   rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%')  And r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0			
--			when  r1.pick_up_location_id not in ('16','20') And r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0	  then 1
--		 then  1
--		else 0 
--	     end
--            ) 
as UpGradeCount,


 (
		Case 
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.All_Seats<>0 then 1
			--when  r1.pick_up_location_id not in ('16','20') And r1.All_Seats<>0  then 1
			Else 0
	     	End
	 ) 	

	as All_Seats_Count,

	 (Case When r1.All_Level_LDW>0 Then 1 Else 0 End)				as All_Level_LDW_Count,
	 (Case When r1.PAi>0 Then 1 Else 0 End)				as PAi_Count,
	 (Case When r1.RSN>0 Then 1 Else 0 End)				as RSN_Count,
	 (Case When r1.ELI>0 Then 1 Else 0 End)				as ELI_Count,


	 (	Case 
				when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And  r1.Additional_Driver_Charge<>0 Then 1
				--when  r1.pick_up_location_id not in ('16','20') And  r1.Additional_Driver_Charge<>0    then 1
			Else 0
    			End) 		as Additional_Driver_Charge_Count,
	 (
		 Case When
		 (
					(
							Case 
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and Driver_Under_Age>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20') and Driver_Under_Age>0  then 1
							Else 0
	     						End
						 ) 	
						+	
					(
							Case 
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   And r1.Ski_Rack>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20') And r1.Ski_Rack>0   then 1
							Else 0
	     						End
						 ) 	
						+

					(
							Case 
								when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and  r1.Seat_Storage>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20') and  r1.Seat_Storage>0   then 1
								Else 0
	     						End
						 ) 	+

					(
							Case 
								when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.Our_Of_Area>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20')  And r1.Our_Of_Area>0   then 1
								Else 0
	     						End
						 ) 	
	    				+
						(
							Case 
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Dolly>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20')  And  r1.All_Dolly>0  then 1
								Else 0
	     						End
						 ) 	

						+
						(
							Case 
								when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Gates>0 then 1
									--when  r1.pick_up_location_id not in ('16','20') And  r1.All_Gates>0   then 1
							Else 0
	     						End
						 ) 	
					  +
					 (
							Case 
								when rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Blanket>0 Then 1
								--when  r1.pick_up_location_id not in ('16','20') And r1.Blanket>0   then 1
								Else 0
	     						End
						 ) 	
					+
					 (Case When r1.GPS>0 then 1 Else 0 End)  
				 ) >0 
		Then 1 
		Else
			0
		End )   as Other_Extra_Count,

	 (
		Case 
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  then Walkup_Count --  and (rate_name Not Like '%Month%') 
			--when  r1.pick_up_location_id not in ('16','20')  then Walkup_Count
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
	
FROM 	RP_Acc_17_CSR_Incentive_Report_L2 r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select distinct u.user_id, u.user_name, u.active, u.employeeID
from GISUsers u --where user_name like 'maggie%'
) csr
	on csr.user_name = r1.CSR_Name 
WHERE	(r1.RBR_Date BETWEEN @startBusDate and @paramEndBusDate) and  (r1.CSR_Name  in ('Kevin Lam'))








GO
