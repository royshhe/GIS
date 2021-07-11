USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_17_Revenue_By_Vehicle_Model]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [dbo].[RP_SP_Flt_17_Revenue_By_Vehicle_Model]     --'*','*', '01 Dec 2014', '31 Dec 2014'
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',	 
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000'
)
AS




DECLARE 	@startDate datetime,
		@endDate datetime,
		@NumOfDays as int


-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '00:00:00 ' + @paramEndDate) 	
select @NumOfDays=datediff(dd,@startDate,@endDate)+1

print @NumOfDays
  


 Select Revenue.*, 
		 
		(TimeCharge+Upgrade+
		KMs+  
		LDW+ 
		PAI+ 
		PEC+
		MovingAids+
		MovingSupply+
		VLF+
		--LRF+
		DropCharge+
		AddDriver+  
		YoungDriver+
		BuyDown +
		GPS+ 
		--FPO +
		ELI+
		CrossBoardSurcharge+
		SnowTires+
		ERF+
		BabySeats) as RevenueTotal
		
	 from  

-- new REvenue
	(SELECT 
		Vehicle_Type_ID, 
		--Vehicle_Class_Code, 		
		--Vehicle_Class_Name,
		model_name, 
		model_year, 
		sum(DailyTime*DaysCounter) as TimeCharge, 
		sum(DailyUpgrade*DaysCounter) as Upgrade, 
		sum(DailyKms*DaysCounter) as KMs,  
		sum(DailyLDW*DaysCounter) as LDW , 
		sum(DailyPAI*DaysCounter) as PAI, 
		sum(DailyPEC*DaysCounter) as PEC, 
		sum(DailyMovingAids*DaysCounter) as MovingAids, 
		sum(DailyMovingSupply*DaysCounter) as MovingSupply,
		Sum(DailyVLF*DaysCounter) as VLF, 
		--sum(DailyLRF*DaysCounter) as LRF,
		sum(DailyDropCharge*DaysCounter) as DropCharge,
		sum(DailyAddDriver*DaysCounter) as AddDriver,  
		sum(DailyYoungDriver*DaysCounter) as YoungDriver,
		sum(DailyBuyDown*DaysCounter) as BuyDown ,
		sum(Dailygps*DaysCounter) as GPS, 
		--sum(Dailyfpo*DaysCounter) as FPO ,
		sum(DailyELI*DaysCounter) as ELI, 
		sum(DailyCrossBoardSurcharge*DaysCounter) as CrossBoardSurcharge,
		sum(DailySnowTires*DaysCounter) as SnowTires, 
		sum(DailyERF*DaysCounter) as ERF,
		sum(DailyBabySeats) as BabySeats 
	FROM  
	 (
			SELECT
			contract_number, 
			Pick_Up_On,
			Check_In,
			Rental_Days, 
			Vehicle_Type_ID, 
			--Vehicle_Class_Code, 
			model_name, 
			model_year, 
			
			(Case 
				When Pick_Up_On >= @startDate and Check_In < @endDate+1	
				Then datediff(mi,Pick_Up_On,Check_In)/ 1440.00
			--2		MB	CO	ME	CI
				When Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In
				Then datediff(mi,Pick_Up_On,@endDate+1)/ 1440.00
			--3		CO	MB	CI	ME		 
				When @startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1
						 
				Then datediff(mi,@startDate,Check_In)/ 1440.00
			--4		CO	MB	ME	CI
				When @startDate>=Pick_Up_On and @endDate+1<=Check_In 
				Then  datediff(mi,@startDate,@endDate+1)/ 1440.00
			End) DaysCounter,	
			--RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 				
			Case when Rental_Days>0 
					then TimeCharge/Rental_Days 
					else 0 
				end as DailyTime, 
			Case when Rental_Days>0 
					then Upgrade/Rental_Days 
					else 0 
				end as DailyUpgrade, 
			Case when Rental_Days>0 
					then Kms/Rental_Days 
					else 0
				end as DailyKMs,  
			Case when Rental_Days>0 
					then LDW/Rental_Days 
					else 0
				end as DailyLDW , 
			Case when Rental_Days>0 
					then PAI/Rental_Days 
					else 0
				end as DailyPAI, 
			Case when Rental_Days>0 
					then PEC/Rental_Days 
					else 0
				end	as DailyPEC, 
			Case when Rental_Days>0 
					then MovingAids/Rental_Days 
					else 0
				end	as DailyMovingAids, 
			Case when Rental_Days>0 
					then MovingSupply/Rental_Days 
					else 0
				end as DailyMovingSupply,
			Case when Rental_Days>0 
					then VLF/Rental_Days 
					else 0
				end	as DailyVLF, 
			Case when Rental_Days>0 
					then LRF/Rental_Days 
					else 0
				end	as DailyLRF,
			Case when Rental_Days>0 
					then DropCharge/Rental_Days 
					else 0
				end	as DailyDropCharge,
			Case when Rental_Days>0 
					then Additional_Driver_Charge/Rental_Days 
					else 0
				end	as DailyAddDriver,  
			Case when Rental_Days>0 
					then Driver_Under_Age/Rental_Days 
					else 0
				end	as DailyYoungDriver,
			Case when Rental_Days>0 
					then BuyDown/Rental_Days 
					else 0
				end	as DailyBuyDown ,
			Case when Rental_Days>0 
					then gps/Rental_Days 
					else 0
				end	as DailyGPS, 
			Case when Rental_Days>0 
					then fpo/Rental_Days 
					else 0
				end	as DailyFPO ,
			Case when Rental_Days>0 
					then ELI/Rental_Days 
					else 0
				end	as DailyELI, 
			Case when Rental_Days>0 
					then CrossBoardSurcharge/Rental_Days 
					else 0
				end	as DailyCrossBoardSurcharge,
			Case when Rental_Days>0 
					then SnowTires/Rental_Days 
					else 0
				end	as DailySnowTires, 
			Case when Rental_Days>0 
					then ERF/Rental_Days 
					else 0
				end	as DailyERF,
			Case when Rental_Days>0 
					then BabySeats/Rental_Days 
					else 0
				end	as DailyBabySeats,
			--,
			
			--TimeCharge, 
			--Kms, 
			--LDW, 
			--PAI, 
			--PEC , 
			--MovingAids , 
			--MovingSupply ,
			--VLF , 
			--LRF ,
			--DropCharge ,
			--Additional_Driver_Charge ,  
			--Driver_Under_Age ,
			--BuyDown ,
			--gps , 
			--fpo  ,
			--ELI , 
			--CrossBoardSurcharge ,
			--SnowTires , 
			--ERF ,
			--BabySeats ,
			
			DisplayOrder
--select *
		FROM      svbvm007.gisdata.dbo.RP_FLT_17_Vehicle_Revenue_Main

	 

		WHERE   ( @paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
			AND
 			(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID) 	
			AND
			(
				(Pick_Up_On >= @startDate and Check_In < @endDate+1	)  
				Or
				(Pick_Up_On> = @startDate  And Pick_Up_On < @endDate+1 and @endDate+1<=Check_In)
				Or
				(@startDate>=Pick_Up_On and @startDate<=Check_In  And Check_In <@endDate +1)
				Or
				(@startDate>=Pick_Up_On and @endDate+1<=Check_In)
			)
			--and unit_number='184989'
			--and  Model_Name in  ('BMW 328XI',
			--							'BMW 750LI',
			--							'BMW 750I',
			--							'BMW 528XI',
			--							'BMW X5'
			--							)
	 )	RADetail
	 Group by  Vehicle_Type_ID,   model_name,model_year 
 ) Revenue

Order by    Revenue.Vehicle_Type_ID--,Revenue.Vehicle_Class_Code




--select * from VEhicle_model_Year where model_name like '%bmw%'
GO
