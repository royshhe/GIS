USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Accounting_Depn_Detail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE Procedure [dbo].[RP_SP_FA_Accounting_Depn_Detail] --'2015-01-01'

	@AMOMonth VarChar(24) = '2008-10-01'
As

DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime
Declare @bFullyAmortized Bit
Declare @Days int


SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1
select @Days=cast((DATEDIFF (d , @dMonthBeginning , @dMonthEnd )) AS int)+1

print @days

		SELECT       
							V.Unit_Number, 
							vc.vehicle_class_name,
							V.Serial_Number, 
							VMY.Model_Name, 
							Convert(Varchar(4),VMY.Model_Year) Model_Year, 
							case when vc.vehicle_class_code in ('I')
									then vc.FA_Vehicle_Type_ID
									else VC.Vehicle_Type_ID
							end Vehicle_type_ID,
							--FA_Vehicle_Type_ID Vehicle_type_ID, 
							(Case When V.Lessee_id Is Not NULL Then 'Lease'
									 Else 'Rental'
							End) VehicleUse,	
							dbo.VehicleISD(V.Unit_Number) as ISD,
							Convert(Varchar(4), Year(dbo.VehicleISD(V.Unit_Number)))+'-'+ 
							(Case When Month(dbo.VehicleISD(V.Unit_Number))<10 Then '0'+convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
											When Month(dbo.VehicleISD(V.Unit_Number))>=10 Then  convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
							End) InService_Month,					
							DATEDIFF (d , dbo.VehicleISD(V.Unit_Number) , @dMonthEnd )+1 as Total_InService_days,
							V.Program, 
							V.Vehicle_Cost, 
							(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
									 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
									 Else 0
							End) FixedAMO,
							VMO.AMO_Amount as CurrAMO,	

							V.Volume_Incentive,
							V.Planned_Days_In_Service,
							convert(decimal(9,2),V.Volume_Incentive/V.Planned_Days_In_Service) as AMO_Daily_Rate,	
							VMO.Dep_Credit as Current_Month_AMO, 
							ACCAMO.AccAMO,	
							V.Volume_Incentive-ACCAMO.AccAMO as Balance, 		-- Un Amotiz
							(Case   When V.Sold_Date<=@dMonthEnd Then  'Sold' -- Vehicle Sold With the Month
										Else ''
							End ) as Status	,	
							 V.sold_date,
							 
							-- --add pull for disposal days to exclude only for Risk in the calculation by pni 2015.03.03
							--case when V.sold_date<=	@dMonthEnd and V.Program=0
							--		then (cast((DATEDIFF (d ,  @dMonthBeginning,V.sold_date  )) AS decimal(9,2))
							--				- dbo.VehiclePFDDays(V.Unit_Number,@dMonthBeginning,@dMonthEnd))*12/365
							--	 when V.sold_date<=	@dMonthEnd and V.Program<>0
							--		then cast((DATEDIFF (d ,  @dMonthBeginning,V.sold_date  )) AS decimal(9,2))*12/365			
							--	 when dbo.VehicleISD(V.Unit_Number)>=@dMonthBeginning and dbo.VehicleISD(V.Unit_Number)<=@dMonthEnd and V.Program=0
							--		then (cast((DATEDIFF (d , dbo.VehicleISD(V.Unit_Number) , @dMonthEnd )) AS decimal(9,2))
							--				- dbo.VehiclePFDDays(V.Unit_Number,@dMonthBeginning,@dMonthEnd))*12/365
							--	 when dbo.VehicleISD(V.Unit_Number)>=@dMonthBeginning and dbo.VehicleISD(V.Unit_Number)<=@dMonthEnd and V.Program<>0
							--		then cast((DATEDIFF (d , dbo.VehicleISD(V.Unit_Number) , @dMonthEnd )) AS decimal(9,2))*12/365
							--	 when dbo.VehiclePFDDays(V.Unit_Number,@dMonthBeginning,@dMonthEnd)>0 and V.Program=0
							--		then  (cast((DATEDIFF (d , @dMonthBeginning , @dMonthEnd )) AS decimal(9,2))
							--				- dbo.VehiclePFDDays(V.Unit_Number,@dMonthBeginning,@dMonthEnd))*12/365		
							--	 when 	dbo.VehicleISD(V.Unit_Number)>@dMonthEnd
							--		then 0
							--	else 1
							--end  as UnitNum
							case when(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
											 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
											 Else 0
									End)<>0
								then
									Round(((VMO.AMO_Amount/(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
											 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
											 Else 0
											End))*365/12)/ @days,2)
							    else 0
							 end   as UnitNum
							 --@Days as NumOfDays
--select *
 			    FROM          FA_Vehicle_Amortization as VMO 
				INNER JOIN
				(
						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
											SUM(Dep_Credit) as AccAMO
						FROM         dbo.FA_Vehicle_Amortization
						Where AMO_Month<=@dMonthBeginning  --Accumulated AMO Including current Month
									Group By Unit_Number
					
				 ) ACCAMO
 				On VMO.Unit_Number =ACCAMO.Unit_Number
				INNER JOIN
				  dbo.Vehicle V ON VMO.Unit_Number = V.Unit_Number 
				INNER JOIN
				  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
				 INNER JOIN
				  dbo.Vehicle_Class VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
				Left JOIN
				 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
					from dbo.FA_Vehicle_Depreciation_History  
							Inner Join 
							(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
								FROM         FA_Vehicle_Depreciation_History
									where (
											(Depreciation_Start_Date>=@dMonthBeginning  and Depreciation_Start_Date <=@dMonthEnd )
										OR   
											(isnull(Depreciation_End_Date,convert(datetime,'2078-12-31 23:59'))-1>=@dMonthBeginning  AND isnull(Depreciation_End_Date,convert(datetime,'2078-12-31 23:59'))-1<=@dMonthEnd )
										OR 
											(Depreciation_Start_Date<=@dMonthBeginning  and isnull(Depreciation_End_Date,convert(datetime,'2078-12-31 23:59'))-1 >=@dMonthEnd )
									  )	
									Group By Unit_Number									
						) LastDep
						On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
					
					) LastVDH
					On  VMO.Unit_Number =LastVDH.Unit_Number
			    		
			WHERE     (VMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)
			And V.Owning_Company_ID=(select Code from lookup_table where category = 'BudgetBC Company')    
			and not  (v.current_vehicle_status='i' and V.Sold_Date is null)
			--And  V.Volume_Incentive is not Null and V.Volume_Incentive<>0     And (V.Volume_Incentive-ACCAMO.AccAMO=0 and VMO.Dep_Credit=0 or  (V.Volume_Incentive-ACCAMO.AccAMO<>0 or VMO.Dep_Credit<>0))
			and V.Lessee_id is null
			and v.current_vehicle_status<>'e'
			--and v.unit_number   in ('181717','182025','184078')
			order by VC.Vehicle_Type_ID,Vehicle_Class_Name,ISD







GO
