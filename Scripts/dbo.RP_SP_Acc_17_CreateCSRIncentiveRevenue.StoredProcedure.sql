USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CreateCSRIncentiveRevenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

Per Kevin required, From Sep 2013, all location will apply the same Terms & Condition as YVR/DT /peter 2013/09/18
*/





CREATE PROCEDURE [dbo].[RP_SP_Acc_17_CreateCSRIncentiveRevenue] -- '2015-07-01', '2015-07-30'
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

delete RP_ACC_17_CSR_Incremental_Incentive_Revenue where (RBR_Date BETWEEN @startBusDate and @endBusDate)


--select * from RP_Acc_17_CSR_Incentive_Report_L2 where rbr_date='2013-10-01'
insert INTO RP_ACC_17_CSR_Incremental_Incentive_Revenue
(RBR_date,
EmployeeID, 
EmployeeStatus, 
Location_ID, 
Location,
Vehicle_Type_ID, 
CSR_Name,                  
Contract_In, 
Walk_Up,     
Rental_Days, 
Upgrade,     
Up_Sell,     
All_Level_LDW, 
Buydown,
PAI,         
PEC,         
ELI,         
GPS,         
FPO,  --new plan from Jan 2012
Additional_Driver_Charge, 
All_Seats,   
Driver_Under_Age, 
Ski_Rack,    
Seat_Storage, 
Our_Of_Area, 
All_Dolly,   
All_Gates,   
Blanket,  
Snow_Tire,
KPO_Package,   
Walkup_Rental_Days, 
Walkup_TnM,  
Upgrade_Count,
All_Seats_Count,
All_LDW_Count,
Buydown_Count,
PAI_Count,
PEC_Count,
ELI_Count,
Additional_Driver_Count,
Other_Extra_Count,
Snow_Tire_Count,
Walkup_Count, 
FPO_Contract_Count, 
FPOCount
)    

SELECT 	
	CONVERT(datetime,@paramEndBusDate),
        csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id as Location_ID,
	l.Location,
	r1.Vehicle_Type_ID,
-- Combine Monthly Rental with Non-Monthly Rental
--  'Car' Vehicle_Type_ID,
   	case when csr.active = 0
		then r1.CSR_Name + ' (T)'
		else r1.CSR_Name
		end 					as CSR_Name,
   	Count(r1.Contract_number) 			as Contract_In,
	Sum(r1.Walk_up)					as Walk_Up,

/*	
	Sum(case when( 
							   (
									(
									 	 (Rate_Purpose<>'Tour Pkg' or Rate_Purpose is null) 
										 and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') 
									     and (rate_name Not Like '%Month%')                                            
--										and (Customer_Program_Number is null) 
--										and (Applicant_Status_Indicator=0)

									)
									or 
									(r1.All_Level_LDW<>0 or r1.PAI<>0 or r1.PEC<>0 or r1.ELI<>0 or r1.Upgrade<>0)
--									or (r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0)
--									or r1.Additional_Driver_Charge+ r1.All_Seats+Driver_Under_Age+ r1.Ski_Rack+r1.Seat_Storage+r1.All_Gates+r1.Blanket<>0
								)
--								Or 
--                               ( 
--										(Customer_Program_Number is not null)  
--										And
--										 (
--												r1.All_Level_LDW<>0 or r1.PAI<>0 or r1.PEC<>0 or r1.ELI<>0  or 
--                                                (r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0)
--											   or 
--                                               r1.Upgrade<>0
--											   Or
--											    r1.Additional_Driver_Charge+ r1.All_Seats+Driver_Under_Age+ r1.Ski_Rack+r1.Seat_Storage+r1.All_Gates+r1.Blanket<>0
--											)
--                                 )
						)				
						then Contract_Rental_Days
						else 0
	 		end
	     ) 	as Rental_Days, -- not including Tour Rate Rental Days, Not Include Fast Break Rental Days	
*/

	Sum(case when( 	((Rate_Purpose<>'Tour Pkg' or Rate_Purpose is null) 
											and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
										 and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') 
									     and (rate_name Not Like '%Month%')	)
									or 
									(r1.All_Level_LDW<>0 or r1.Buydown<>0 or r1.PAI<>0 or r1.RSN<>0 or r1.ELI<>0 or r1.Upgrade<>0)
						)	--and  r1.pick_up_location_id in ('16','20')  			
						then Contract_Rental_Days
--				when(((bcd_number<>'A162000' and bcd_number<>'A044300')or (bcd_number is null))
--							and  rate_name not like 'PBC%' 
--							and  rate_name not like 'GOC%'
--							and  rate_name not in ('14i','RCM','RCMP')
--							and rate_name<>'01i'
--							and (Applicant_Status_Indicator<>1 or Applicant_Status_Indicator is null)
--						) 	and  pick_up_location_id not in ('16','20')  		
--						then Contract_Rental_Days

						else 0
	 		end
	     ) 	as Rental_Days,

	
	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%')  then r1.Upgrade
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Upgrade
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'Budget Monthly Rate') then r1.Upgrade --And  (rate_name Not Like '%Month%')    'GAI','FMI', --removed required by Kevin.
			Else 0
        	End
	)  as Upgrade,

--select * from Vehicle_rate where Rate_Name like '%Month%'

	sum( case when  r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0
			and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%') 
		 then  r1.Contract_Revenue -  r1.Reservation_Revenue
		else 0 
	     end
            ) as Up_Sell, 

  	sum(r1.All_Level_LDW)				as All_Level_LDW,
  	sum(R1.Buydown)				as Buydown,
	sum(r1.PAI)					as PAI,
	sum(r1.RSN) 				as PEC,     
        sum(r1.ELI) 			        as ELI,
        sum(r1.GPS)                             as GPS,
	sum(r1.FPO) as FPO,
	
	sum(	Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Additional_Driver_Charge
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Additional_Driver_Charge
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Additional_Driver_Charge
			Else 0
        	End) 		as Additional_Driver_Charge,

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Seats
--			when  r1.pick_up_location_id not in ('16','20')  then r1.All_Seats
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Seats
			Else 0
	     	End
	 ) 	

	 as All_Seats,


	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then Driver_Under_Age
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Driver_Under_Age
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then Driver_Under_Age
			Else 0
	     	End
	 ) 	
	as Driver_Under_Age,	
--	sum(r1.Driver_Under_Age)			
				
	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Ski_Rack
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Ski_Rack
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Ski_Rack
			Else 0
	     	End
	 ) 	
	as Ski_Rack,

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Seat_Storage
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Seat_Storage
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Seat_Storage
			Else 0
	     	End
	 ) 	
	
	as Seat_Storage,
	
	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Our_Of_Area
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Our_Of_Area
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.Our_Of_Area
			Else 0
	     	End
	 ) 	

	as Our_Of_Area,


	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Dolly
--			when  r1.pick_up_location_id not in ('16','20')  then r1.All_Dolly
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Dolly
			Else 0
	     	End
	 ) 	

	as All_Dolly,
	
	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Gates
--				when  r1.pick_up_location_id not in ('16','20')  then r1.All_Gates
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  then r1.All_Gates
		Else 0
	     	End
	 ) 	
	
	as All_Gates,

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Blanket
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Blanket
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  then r1.Blanket
			Else 0
	     	End
	 ) 	
	
	as Blanket,

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Snow_Tire
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Snow_Tire
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.Snow_Tire
			Else 0
	     	End
	 ) 	
	as Snow_Tire,

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.KPO_Package
--			when  r1.pick_up_location_id not in ('16','20')  then r1.KPO_Package
			when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   then r1.KPO_Package
			Else 0
	     	End
	 ) 	
	as KPO_Package,
	
	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate','MiniL','MiniL WK')  then r1.Walkup_Rental_Days -- and (rate_name Not Like '%Month%')  per Nora/20110729
--			when  r1.pick_up_location_id not in ('16','20')  then r1.Walkup_Rental_Days
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate','MiniL','MiniL WK')  then r1.Walkup_Rental_Days -- and (rate_name Not Like '%Month%')  per Nora/20110729
			Else 0
	     	End
	 ) 	


	as Walkup_Rental_Days,
	
	--sum(Walkup_Rental_Time_Revenue)	


	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')   then Walkup_Rental_Time_Revenue --and (rate_name Not Like '%Month%')  
--			when  r1.pick_up_location_id not in ('16','20')  then Walkup_Rental_Time_Revenue
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')   then Walkup_Rental_Time_Revenue --and (rate_name Not Like '%Month%')  
			Else 0
	     	End
	 ) 	

	+

	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')   then Walkup_Rental_KM_Charge-- and (rate_name Not Like '%Month%') 
--			when  r1.pick_up_location_id not in ('16','20')  then Walkup_Rental_KM_Charge
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')   then Walkup_Rental_KM_Charge-- and (rate_name Not Like '%Month%') 
			Else 0
	     	End
	 )
 	
	--sum(Walkup_Rental_KM_Charge)			

	as Walkup_TnM,


sum(
		Case 
--			when  (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%') And r1.Upgrade <>0 Then 1
--			when  r1.pick_up_location_id not in ('16','20') And r1.Upgrade <>0   then 1
			when   rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%') And r1.Upgrade <>0 Then 1
			Else 0
        	End
	) 
-- +
--sum( case when   rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%')  And r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0			
--			when  r1.pick_up_location_id not in ('16','20') And r1.Contract_Revenue >  r1.Reservation_Revenue and  r1.Walk_up = 0 and  r1.upgrade=0	  then 1
--		 then  1
--		else 0 
--	     end
--            ) 
as UpGradeCount,


sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.All_Seats<>0 then 1
--			when  r1.pick_up_location_id not in ('16','20') And r1.All_Seats<>0  then 1
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.All_Seats<>0 then 1
			Else 0
	     	End
	 ) 	

	as All_Seats_Count,

	sum(Case When r1.All_Level_LDW>0 Then 1 Else 0 End)				as All_Level_LDW_Count,
	sum(Case When r1.Buydown>0 Then 1 Else 0 End)				as Buydown_Count,
	sum(Case When r1.PAI>0 Then 1 Else 0 End)				as PAI_Count,
	sum(Case When r1.RSN>0 Then 1 Else 0 End)				as PEC_Count,
	sum(Case When r1.ELI>0 Then 1 Else 0 End)				as ELI_Count,


	sum(	Case 
--				when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And  r1.Additional_Driver_Charge<>0 Then 1
--				when  r1.pick_up_location_id not in ('16','20') And  r1.Additional_Driver_Charge<>0    then 1
				when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And  r1.Additional_Driver_Charge<>0 Then 1
			Else 0
    			End) 		as Additional_Driver_Charge_Count,
	SUM(
		 Case When
		 (
					(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and Driver_Under_Age>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20') and Driver_Under_Age>0  then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and Driver_Under_Age>0 Then 1
							Else 0
	     						End
						 ) 	
						+	
					(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   And r1.Ski_Rack>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20') And r1.Ski_Rack>0   then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   And r1.Ski_Rack>0 Then 1
							Else 0
	     						End
						 ) 	
						+

					(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and  r1.Seat_Storage>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20') and  r1.Seat_Storage>0   then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and  r1.Seat_Storage>0 Then 1
								Else 0
	     						End
						 ) 	+

					(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.Our_Of_Area>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20')  And r1.Our_Of_Area>0   then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.Our_Of_Area>0 Then 1
								Else 0
	     						End
						 ) 	
	    				+
						(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Dolly>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20')  And  r1.All_Dolly>0  then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Dolly>0 Then 1
								Else 0
	     						End
						 ) 	

						+
						(
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Gates>0 then 1
--									when  r1.pick_up_location_id not in ('16','20') And  r1.All_Gates>0   then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Gates>0 then 1
							Else 0
	     						End
						 ) 	
					  +
					 (
							Case 
--								when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Blanket>0 Then 1
--								when  r1.pick_up_location_id not in ('16','20') And r1.Blanket>0   then 1
								when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Blanket>0 Then 1
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

	SUM(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Blanket>0 Then 1
--			when  r1.pick_up_location_id not in ('16','20') And r1.Blanket>0   then 1
			when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Snow_Tire>0 Then 1
			Else 0
			End
		 )   as Snow_Tire_Count,


	sum(
		Case 
--			when (r1.pick_up_location_id in ('16','20')) and rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')  then Walkup_Count --  and (rate_name Not Like '%Month%') 
--			when  r1.pick_up_location_id not in ('16','20')  then Walkup_Count
			when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate','MiniL','MiniL WK')  then Walkup_Count --  and (rate_name Not Like '%Month%') 
			Else 0
	     	End
	 ) 	
     as Walkup_Count,
	
	sum(FPO_Contract_Count) 			as FPO_Contract_Count,
	sum(case when r1.FPOCount=1 and r1.FPO > .00
		 then 1
	    	 when r1.FPOCount=-1 and r1.FPO < .00
		 then -1	
		 else 0 
		 end)					as FPOCount	        	
--select *	
FROM 	RP_Acc_17_CSR_Incentive_Report_L2 r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select distinct u.user_id, left(ltrim(u.user_name),20) as User_name, u.active, u.employeeID
from GISUsers u
) csr
	on csr.user_name = r1.CSR_Name
WHERE	(r1.RBR_Date BETWEEN  @startBusDate and @endBusDate ) --and  (r1.CSR_Name like 'Brahim Jounh')

GROUP BY 	csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id,
		l.Location,
   		r1.CSR_Name,
		r1.Vehicle_Type_ID



GO
