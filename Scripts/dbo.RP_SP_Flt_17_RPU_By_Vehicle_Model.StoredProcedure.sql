USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_17_RPU_By_Vehicle_Model]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/*
PROCEDURE NAME: RP_SP_Flt_17_RPU_By_Vehicle_Model
PURPOSE: Select all information needed for Revenue By Model Year
AUTHOR:	Roy He
DATE CREATED: 2018-04-1
USED BY:  Revenue By Vehicle Model Year
MOD HISTORY:
Name 		Date		Comments
Roy He		2018-04-11  Acrrued

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_17_RPU_By_Vehicle_Model]     --'*','*', '01 Mar 2018', '31 Mar 2018'
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',	 
	@paramStartDate varchar(20) = '01 May 2000',
	@paramEndDate varchar(20) = '07 May 2000'
)
AS




DECLARE @startDate datetime,
		@endDate datetime,
		@NumOfDays as int


-- convert strings to datetime
SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '00:00:00 ' + @paramEndDate) 	
select @NumOfDays=datediff(dd,@startDate,@endDate)+1

print @NumOfDays
  


 Select Distinct Revenue.*, 
		case when VU.NumberOfUnit is null 
				then 0
				else VU.NumberOfUnit 
			end as NumberOfUnit,
		--=VU.TotalUnit,	
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
		BabySeats) as RevenueTotal,
		case when VU.NumberOfUnit is null or @NumOfDays<=0
				then 0
				else ((TimeCharge+Upgrade+
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
						BabySeats)/VU.NumberOfUnit)--/@NumOfDays*365/12
			end as RPU --Monthly RPU
		
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
		--DisplayOrder
	FROM  
	 (
			SELECT
			contract_number, 
			Pick_Up_On,
			Check_In,
			Rental_Days, 
			Vehicle_Type_ID, 
			Vehicle_Class_Code, 
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
			RIGHT(CONVERT(varchar, DisplayOrder + 100), 2)	+ ' - ' + Vehicle_Class_Name Vehicle_Class_Name, 				
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
			
			
			DisplayOrder
--select *
		FROM      svbvm007.gisdata.dbo.RP_FLT_17_Vehicle_Revenue_Main

	 --select top 10 * from svbvm007.gisdata.dbo.RP_FLT_17_Vehicle_Revenue_Main

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
	 )	RADetail
	 Group by  Vehicle_Type_ID,   model_name,model_year 
 ) Revenue
 
 --select * from vehicle_class where Vehicle_Class_Code in ('d', 'e', 'f')
Left Join 
(
	
	Select Model_Name, 
	   Model_Year,
	   sum(DaysInService) TotalInserviceDays,
	   Round(Convert(decimal(9,2), sum(DaysInService))/Convert(decimal(9,2),DATEDIFF(Day,@startDate,@endDate+1)),2) as NumberOfUnit	
	From 
	(
		SELECT  	
								
								V.Unit_Number, 
								(Case When V.Program =1 Then 'Program' Else RiskType.Value End) As OrderType , 
								V.Serial_Number, 
								VC.Vehicle_Type_ID, 
								VMY.Model_Name, 
								VMY.Model_Year,							
								(Case When VTP.PFDDays is not Null then VTP.PFDDays Else 0 End) PullForDisposalDays,													
								(Case When dbo.UpdatedVehicleISD(V.Unit_Number)<@startDate Then @startDate Else  dbo.UpdatedVehicleISD(V.Unit_Number) End) ISD,
								V.sold_date as SoldDate,
								
								(Case When VPP.PFDTo<@endDate+1 and VPP.StatusAfterPFD not in ('c','d') Then VPP.PFDFrom 
									  When VPP.PFDTo<@endDate+1 and VPP.StatusAfterPFD in ('c','d') Then  @endDate
									  When VPP.PFDTo>=@endDate+1  Then VPP.PFDFrom
									  When VPP.PFDTo is Null Then @endDate
								 End
								) EndDate,
										  
								DATEDIFF(Day, 
										 (Case When dbo.UpdatedVehicleISD(V.Unit_Number)<@startDate Then @startDate Else  dbo.UpdatedVehicleISD(V.Unit_Number) End),							  
										 (Case When VPP.PFDTo<@endDate+1 and VPP.StatusAfterPFD not in ('c','d') Then VPP.PFDFrom 
												  When VPP.PFDTo<@endDate+1 and VPP.StatusAfterPFD in ('c','d') Then  @endDate+1	
												  When VPP.PFDTo>=@endDate+1  Then VPP.PFDFrom
												  When VPP.PFDTo is Null Then @endDate+1
										  End
										  )
								 ) 
								 -(Case When VTP.PFDDays is not Null then VTP.PFDDays Else 0 End)
								 AS DaysInService

								
			FROM 	Vehicle V
				INNER JOIN
    				Vehicle_Model_Year VMY
					ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
     				INNER JOIN
    				Vehicle_Class VC
					ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
				INNER JOIN
				Location 
					ON V.Current_Location_ID = Location.Location_ID 	
				INNER 
				JOIN
    				Lookup_Table 
					ON V.Owning_Company_ID = Lookup_Table.Code 
					AND Lookup_Table.Category = 'BudgetBC Company' 
				INNER JOIN
				Owning_Company 
					ON V.Owning_Company_ID = Owning_Company.Owning_Company_ID
								 
				
					
				Left Join 
					(
						SELECT     Unit_Number, SUM(
																DATEDIFF(d, 
																
																(Case When  PFDFrom<@startDate  Then @startDate
																		Else PFDFrom
																End),
																 
																(Case When PFDTo is not Null and PFDTo<@endDate+1 and   StatusAfterPFD in ('c','d')  Then PFDTo
																	  When PFDTo is not Null and PFDTo<@endDate+1 and   StatusAfterPFD not in ('c','d')  Then PFDFrom
																	  When PFDTo is not Null and PFDTo>=@endDate+1 and   StatusAfterPFD not in ('c','d')  Then PFDFrom
																	  When PFDTo is not Null and PFDTo>=@endDate+1 and   StatusAfterPFD  in ('c','d')  Then @endDate+1				
																		Else @endDate+1
																End)
																)
													) AS PFDDays, max(PFDFrom) LastPFDDate
						FROM         dbo.Vehicle_Pulled_Periods_vw
						WHERE     
						(
							PFDFrom >= @startDate and PFDFrom<@endDate+1
							And
							 
							DATEDIFF(	d, 
										PFDFrom, 
										(Case When PFDTo is not Null and PFDTo<@endDate+1 and   StatusAfterPFD in ('c','d')  Then PFDTo
											  When PFDTo is not Null and PFDTo<@endDate+1 and   StatusAfterPFD not in ('c','d')  Then PFDFrom
											  When PFDTo is not Null and PFDTo>=@endDate+1 and   StatusAfterPFD not in ('c','d')  Then PFDFrom
											  When PFDTo is not Null and PFDTo>=@endDate+1 and   StatusAfterPFD  in ('c','d')  Then @endDate+1				
												Else @endDate+1
										End)
							) >= 0
						) 
						or 
						(
							PFDTo >= @startDate and PFDTo<@endDate+1 
							and
							StatusAfterPFD in ('c','d') 
						) 
					    
					     
						GROUP BY Unit_Number
					)VTP 
					On V.Unit_Number=VTP.Unit_Number
					
				Left Join Vehicle_Pulled_Periods_vw VPP
					On V.Unit_Number=VPP.Unit_Number and VPP.PFDFrom=VTP.LastPFDDate
					
				Left Join (Select * from lookup_table where Category='Risk Type') RiskType
					On V.Risk_Type=RiskType.Code
				Left Join FA_Buyer Buyer on V.Sell_To= Buyer.Customer_Code			
			   -- Last Pull For Disposal
				LEFT OUTER JOIN
						  (Select Unit_number, Vehicle_Status, max(Effective_On) Effective_On from Vehicle_History 
								Group by Unit_number, Vehicle_Status)  FAOSD 
						ON V.Unit_Number = FAOSD.Unit_Number AND (V.Program = 0 AND FAOSD.Vehicle_Status = 'f' OR
								  V.Program = 1 AND FAOSD.Vehicle_Status = 'g')
			  Left JOIN
							 (Select Unit_Number,  
										Min(Depreciation_Start_Date) ISD, 
										Max(Depreciation_End_Date)  OSD
								from dbo.FA_Vehicle_Depreciation_History 
									Group By Unit_Number
								) VDH
				ON
				  V.Unit_Number = VDH.Unit_Number 
			    

				LEFT OUTER JOIN
    				Lookup_Table lt2
					ON V.Current_Rental_Status = lt2.Code 	
					AND (lt2.Category = 'vehicle rental status') 
				LEFT OUTER JOIN
    				Lookup_Table lt3
					ON V.Current_Condition_Status = lt3.Code
					AND (lt3.Category = 'vehicle condition status') 

							
			WHERE
			(
				(
				   dbo.UpdatedVehicleISD(V.Unit_Number)>= @startDate and  dbo.UpdatedVehicleISD(V.Unit_Number)<@endDate+1
				 )
				 or 
				 (  
					 dbo.UpdatedVehicleISD(V.Unit_Number)< @startDate and 
					 (	v.Unit_number not in (Select Unit_number from Vehicle_PullForDisposal_Periods_vw )
						or VPP.PFDFrom >=@startDate
					 )
				  ) 
				 or 
				 (  
					 dbo.UpdatedVehicleISD(V.Unit_Number)< @startDate and 
					 (	v.Unit_number in (Select Unit_number from Vehicle_PullForDisposal_Periods_vw where PFDFrom>=@endDate+1)
						
					 )
				 ) 
				 
				 
				 
				 or
				 (  
					 dbo.UpdatedVehicleISD(V.Unit_Number)< @startDate and 
					 (	
						v.Unit_number in 
						(
							Select Unit_number from Vehicle_PullForDisposal_Periods_vw where PFDTo>=@startDate and StatusAfterPFD in ('c','d')  
						)
						
					  )
				   ) 
				 			  
				 or
				 (  
					 --dbo.UpdatedVehicleISD(V.Unit_Number)< @startDate and 
					 (	v.Unit_number in 
						 (Select VPPA.Unit_number from 
							Vehicle_PullForDisposal_Periods_vw VPPA
							Inner Join 
							(select vv.unit_number, 
									max(PFDFrom) LastPFDFrom 
								   from  Vehicle_PullForDisposal_Periods_vw vv  
							 where vv.unit_number=v.Unit_number group by vv.unit_number
							 ) LastPFD
							 On VPPA.Unit_number=LastPFD.Unit_number and VPPA.PFDFrom=LastPFD.LastPFDFrom						
							where VPPA.PFDTo is not null and VPPA.StatusAfterPFD in ('c','d') --and VPPA.PFDTo<@startDate 
							
						 )
					) 
				 
				 )
			)
			And 
			(v.current_vehicle_status<>'e')
			and 
			(v.deleted=0)
				 
	)Fleet
	Group by  Model_Name,  Model_Year

)  VU

On   Revenue.Model_Name =  VU.Model_Name and Revenue.Model_Year =  VU.Model_Year
Order by   Revenue.Vehicle_Type_ID,Revenue.Model_Name,Revenue.Model_Year


GO
