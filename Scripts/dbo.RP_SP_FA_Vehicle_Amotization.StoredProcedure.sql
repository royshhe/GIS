USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Vehicle_Amotization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[RP_SP_FA_Vehicle_Amotization] -- '2012-02-01'

	@AMOMonth VarChar(24) = '2008-10-01'

As

DECLARE @dAMOMonth  	Datetime
Declare @dMonthBeginning Datetime
Declare @dMonthEnd Datetime

SELECT	@dAMOMonth = Convert(Datetime, NULLIF(@AMOMonth,''))
Select @dMonthBeginning=@dAMOMonth-Day(@dAMOMonth)+1
Select @dMonthEnd=DATEADD(month,1, @dMonthBeginning)-1

		
		SELECT       
							VMO.AMO_Month,
							V.Unit_Number, 
							V.Serial_Number, 
							VMY.Model_Name, 
							VMY.Model_Year, 
							VC.FA_Vehicle_Type_ID, 
							VC.Vehicle_Class_Name,
							(Case When V.Lessee_id Is Not NULL Then 'Lease'
									 Else 'Rental'
							End) VehicleUse,
							VDH.ISD as Start_ISD, 
							
						   (Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  NULL
									  When V.Sold_Date<=@dMonthEnd Then    VDH.OSD -- Vehicle Sold With the Month
							End ) As OSD,
							VTP.LastPFDDAte,
							(Case When VTH.HeldDays is not Null then VTH.HeldDays Else 0 End) HeldDays,
							(Case When VTP.PFDDays is not Null then VTP.PFDDays Else 0 End) PFDDays,							
							convert(bit,V.Program) Program, 
							V.Vehicle_Cost, 
							PrevAMO.Balance as BeginningBalance,
							(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
									 When LastVDH.Depreciation_Rate_Percentage is Not Null Then  Round(V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100,2)
									 Else 0
							End) FixedAMO,
							VMO.AMO_Amount, 
							VMO.Dep_Credit,
							VMO.InService_Months,		

							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  VMO.Balance-dbo.ZeroIfNull(V.Price_Difference) 		
									  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
							End ) as Balance, 		-- BookValue	
			
							
							
						   (Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then   V.Vehicle_Cost-VMO.Balance 
									  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
							End ) As AccuAMO,

							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  V.Vehicle_Cost
									  When V.Sold_Date<=@dMonthEnd Then  0 -- Vehicle Sold With the Month
							End ) As BookCost,
							
							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
									  When V.Sold_Date<=@dMonthEnd Then  V.Vehicle_Cost-- Vehicle Sold With the Month
							End ) As SoldCost,
							
							(Case   When V.Sold_Date<=@dMonthEnd Then  'Yes' -- Vehicle Sold With the Month
										Else ''
							End ) As Sold,

							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
									  When V.Sold_Date<=@dMonthEnd Then  V.Vehicle_Cost-VMO.Balance  -- Vehicle Sold Withinin the Month
							End ) As SoldAMO,
							

							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
									  When V.Sold_Date<=@dMonthEnd Then    V.Selling_Price -- Vehicle Sold With the Month
							End ) As SellingPrice,


							(Case When V.Sold_Date>@dMonthEnd  Or V.Sold_Date is Null Then  0
									-- Vehicle Sold With the Month
									  When V.Sold_Date<=@dMonthEnd Then  
															V.Selling_Price-
																	(V.Vehicle_Cost -
																			(
																					  (V.Vehicle_Cost-VMO.Balance)
--																					+dbo.ZeroIfNull(Damage_Amount)
--																					+dbo.ZeroIfNull(Price_Difference)
																			
                                                                            ) 
																	)
							End ) As GainLoss,
--,
--dbo.ZeroIfNull(Damage_Amount),
--dbo.ZeroIfNull(Price_Difference)
							dbo.VehicleISD(V.Unit_Number) as ISD,
							V.FA_Remarks

			FROM          FA_Vehicle_Amortization VMO 
				INNER JOIN
				(
						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
											dbo.FA_Vehicle_Amortization.AMO_Amount, 
											dbo.FA_Vehicle_Amortization.InService_Months, 
											dbo.FA_Vehicle_Amortization.Balance, 
											dbo.FA_Vehicle_Amortization.AMO_Month
						FROM         dbo.FA_Vehicle_Amortization
						Inner Join 
						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
													Max(AMO_Month) as AMOMonth
								FROM         dbo.FA_Vehicle_Amortization
								Where dbo.FA_Vehicle_Amortization.AMO_Month<@dMonthBeginning
								Group By Unit_Number
								
						) PrevMonth
						On dbo.FA_Vehicle_Amortization.Unit_Number=PrevMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=PrevMonth.AMOMonth
				 ) PrevAMO
						

				On VMO.Unit_Number =PrevAMO.Unit_Number
				INNER JOIN
				  dbo.Vehicle V ON VMO.Unit_Number = V.Unit_Number 
				INNER JOIN
				  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
				 INNER JOIN
				  dbo.Vehicle_Class VC ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
				 Inner JOIN
				 (Select Unit_Number,  
							Min(Depreciation_Start_Date) ISD, 
							Max(Depreciation_End_Date)  OSD
					from dbo.FA_Vehicle_Depreciation_History 
						Group By Unit_Number
					) VDH
			      
				 ON VMO.Unit_Number = VDH.Unit_Number
			      
				Left JOIN
				 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
					from dbo.FA_Vehicle_Depreciation_History  
							Inner Join 
							(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
								FROM         FA_Vehicle_Depreciation_History
									where (
											(Depreciation_Start_Date>=@dMonthBeginning and Depreciation_Start_Date <=@dMonthEnd)
										OR   
											(isnull(Depreciation_End_Date,convert(datetime,'31 dec 2078'))-1>=@dMonthBeginning AND isnull(Depreciation_End_Date,convert(datetime,'31 dec 2078'))-1<=@dMonthEnd)
										OR 
											(Depreciation_Start_Date<=@dMonthBeginning and isnull(Depreciation_End_Date,convert(datetime,'31 dec 2078'))-1 >=@dMonthEnd)
									  )	
									Group By Unit_Number									
						) LastDep
						On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
					
					) LastVDH
					On  VMO.Unit_Number =LastVDH.Unit_Number
				Left Join Vehicle_Total_Held_Days_vw VTH 
					On VMO.Unit_Number=VTH.Unit_Number
				Left Join Vehicle_Total_PFD_Days_vw VTP 
					On VMO.Unit_Number=VTP.Unit_Number
				
						
			WHERE     (VMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd)
And V.Owning_Company_ID=(select Code from lookup_table where category = 'BudgetBC Company')         


order by sold desc,V.unit_number




GO
