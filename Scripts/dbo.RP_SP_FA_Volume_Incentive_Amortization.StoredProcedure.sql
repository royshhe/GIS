USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Volume_Incentive_Amortization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[RP_SP_FA_Volume_Incentive_Amortization]-- '2012-01-01','0'

	@AMOMonth VarChar(24) = '2008-10-01',
	@FullyAmortized Varchar(1)='0'

As

DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime
Declare @bFullyAmortized Bit


SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1
SELECT @FullyAmortized=NULLIF(@FullyAmortized,'')
SELECT @bFullyAmortized=Convert(bit, @FullyAmortized)


If 	 @bFullyAmortized=1
		SELECT       
							VMO.AMO_Month,
							V.Unit_Number, 
							V.Serial_Number, 
							VMY.Model_Name, 
							Convert(Varchar(4),VMY.Model_Year) Model_Year, 
							VC.FA_Vehicle_Type_ID, 
							(Case When V.Lessee_id Is Not NULL Then 'Lease'
									 Else 'Rental'
							End) VehicleUse,	
							dbo.VehicleISD(V.Unit_Number) as ISD,
							Convert(Varchar(4), Year(dbo.VehicleISD(V.Unit_Number)))+'-'+ 
							(Case When Month(dbo.VehicleISD(V.Unit_Number))<10 Then '0'+convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
											When Month(dbo.VehicleISD(V.Unit_Number))>=10 Then  convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
							End) InService_Month,					
							VMO.InService_Months,		
							V.Planned_Days_In_Service,				
							V.Program, 
							V.Vehicle_Cost, 
							V.Volume_Incentive,
							VMO.Dep_Credit,
							ACCAMO.AccAMO,	
							V.Volume_Incentive-ACCAMO.AccAMO as Balance, 		-- Un Amotiz
										
							(Case   When V.Sold_Date<=@dMonthEnd Then  'Yes' -- Vehicle Sold With the Month
										Else ''
							End ) As Sold,
							VDH.ISD as Started_ISD

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
				 left JOIN
				 (Select Unit_Number,  
							Min(Depreciation_Start_Date) ISD
					from dbo.FA_Vehicle_Depreciation_History 
						Group By Unit_Number
					) VDH 
					 ON v.Unit_Number = VDH.Unit_Number
				  
			
			    		
			WHERE     (VMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)
			And V.Owning_Company_ID=(select Code from lookup_table where category = 'BudgetBC Company')    
			And  V.Volume_Incentive is not Null and V.Volume_Incentive<>0     And V.Volume_Incentive-ACCAMO.AccAMO=0 and VMO.Dep_Credit=0


			order by sold desc,V.unit_number
Else
			SELECT       
							VMO.AMO_Month,
							V.Unit_Number, 
							V.Serial_Number, 
							VMY.Model_Name, 
							Convert(Varchar(4),VMY.Model_Year) Model_Year, 
							VC.FA_Vehicle_Type_ID, 
							(Case When V.Lessee_id Is Not NULL Then 'Lease'
									 Else 'Rental'
							End) VehicleUse,	
							dbo.VehicleISD(V.Unit_Number) as ISD,
							Convert(Varchar(4), Year(dbo.VehicleISD(V.Unit_Number)))+'-'+ 
							(Case When Month(dbo.VehicleISD(V.Unit_Number))<10 Then '0'+convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
											When Month(dbo.VehicleISD(V.Unit_Number))>=10 Then  convert(varchar(2),Month(dbo.VehicleISD(V.Unit_Number)))
							End) InService_Month,					
							VMO.InService_Months,		
							V.Planned_Days_In_Service,				
							V.Program, 
							V.Vehicle_Cost, 
							V.Volume_Incentive,
							VMO.Dep_Credit,
							ACCAMO.AccAMO,	
							V.Volume_Incentive-ACCAMO.AccAMO as Balance, 		-- Un Amotiz
										
							(Case   When V.Sold_Date<=@dMonthEnd Then  'Yes' -- Vehicle Sold With the Month
										Else ''
							End ) As Sold,
							VDH.ISD as Started_ISD

 			    FROM          FA_Vehicle_Amortization as VMO 
				INNER JOIN
				(
						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
											SUM(Dep_Credit) as AccAMO
						FROM         dbo.FA_Vehicle_Amortization
						Where AMO_Month<=@dMonthBeginning --Accumulated AMO Including current Month
									Group By Unit_Number
					
				 ) ACCAMO
 				On VMO.Unit_Number =ACCAMO.Unit_Number
				INNER JOIN
				  dbo.Vehicle V ON VMO.Unit_Number = V.Unit_Number 
				INNER JOIN
				  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
				 INNER JOIN
				  dbo.Vehicle_Class VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
				 left JOIN
				 (Select Unit_Number,  
							Min(Depreciation_Start_Date) ISD
					from dbo.FA_Vehicle_Depreciation_History 
						Group By Unit_Number
					) VDH 
					 ON v.Unit_Number = VDH.Unit_Number
				  
			
			    		
			WHERE     (VMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)
			And V.Owning_Company_ID=(select Code from lookup_table where category = 'BudgetBC Company')    
			And  V.Volume_Incentive is not Null and V.Volume_Incentive<>0     And (V.Volume_Incentive-ACCAMO.AccAMO<>0 or VMO.Dep_Credit<>0)


			order by sold desc,V.unit_number

GO
