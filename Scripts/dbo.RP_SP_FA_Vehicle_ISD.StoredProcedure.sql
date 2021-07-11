USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Vehicle_ISD]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[RP_SP_FA_Vehicle_ISD]   -- '2018-03-01', '2018-03-31'

	@sBeginning Varchar(24)='2009-05-01',
	@sEnd Varchar(24)='2009-05-31'
	
As

Declare @startDate Datetime
Declare @endDate Datetime

SELECT	@startDate = Convert(Datetime, NULLIF(@sBeginning,''))
SELECT	@endDate = Convert(Datetime, NULLIF(@sEnd,''))


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

Order by  Model_Name,  Model_Year
   


----select * from vehicle where unit_number=192912

----select unit_number, max(PFDto) LastPFDto from  Vehicle_PullForDisposal_Periods_vw  where unit_number=188006 group by unit_number
--select * from Vehicle_PullForDisposal_Periods_vw where unit_number=193381
--Select dbo.UpdatedVehicleISD(193381)
--select * from Vehicle_PullForDisposal_Periods_vw where unit_number=177454


----Select * from lookup_table where category like '%status%'


--select * from Vehicle_PullForDisposal_Periods_vw where unit_number=193333


--select * from vehicle where unit_number=130135

GO
