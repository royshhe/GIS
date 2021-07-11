USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Car_Sales_Performance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[RP_SP_FA_Car_Sales_Performance]    --'2016-10-01', '2016-10-31'

	@sBeginning Varchar(24)='2009-05-01',
	@sEnd Varchar(24)='2009-05-31',
	@SellTo VarChar(30) ='*'

As

Declare @dBeginning Datetime
Declare @dEnd Datetime

SELECT	@dBeginning = Convert(Datetime, NULLIF(@sBeginning,''))
SELECT	@dEnd = Convert(Datetime, NULLIF(@sEnd,''))
SELECT	@SellTo =NULLIF(@SellTo,'')

	SELECT  	
                           V.sold_date as SoldDate,
							--V.OSD as SoldDate,
							V.Depreciation_End_Date,						
							V.Unit_Number, 
							V.Serial_Number, 
							VC.FA_Vehicle_Type_ID, 
							VMY.Model_Name, 
							VMY.Model_Year,
							(case when v.Km_reading is not null then V.Km_reading
							      else V.Current_Km
							  End) Current_Km,
							Buyer.Buyer_Name,
							(Case When V.Lessee_id Is Not NULL Then 'Lease'
									 Else 'Rental'
							End) VehicleUse,
							VDH.ISD, 							
						   
							(Case When VTH.HeldDays is not Null then VTH.HeldDays Else 0 End) HeldDays,
							(Case When VTP.PFDDays is not Null then VTP.PFDDays Else 0 End) PullForDisposalDays,							
							(Case When V.Program =1 Then 'Program' Else RiskType.Value End) As OrderType , 
							
							Depreciation_Type,
							V.Depreciation_Periods,
							V.Idle_Days,
							dbo.UpdatedVehicleISD(V.Unit_Number) InServiceDate,

							DATEDIFF(Day, dbo.UpdatedVehicleISD(v.Unit_Number),  
								(Case When getdate()<LastVDH.Depreciation_End_Date then getdate()
										 Else LastVDH.Depreciation_End_Date
									End
								 )
							 ) AS DaysInService,

							(Case 
									  When V.Depreciation_Rate_Amount is Not Null Then '$'+Convert(Varchar(20),V.Depreciation_Rate_Amount)
									 When  V.Depreciation_Rate_Percentage Is Not Null Then Convert(Varchar(20),V.Depreciation_Rate_Percentage) +'%' 	
									 Else ''
							End) DepreciationRate,
							
							LastAMO.AMO_Amount as CurrentMonthDep, 
							V.Selling_Price, 
							V.Vehicle_Cost, 
							V.Vehicle_Cost-LastAMO.Balance  As AccuAMO,
							ISNULL(Price_Difference,0) as Price_Protection,	
--                           (Case When LastAMO.Balance Is Not Null Then --VehBookValue.BookValue
--								LastAMO.Balance-
--									 Round
--									 (
--											(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--													 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--													 Else 0
--											End)*12/365  ,
--											2
--										)  -- Daily Deprecation Rate						 
--									  *
--									  (
--										  Case When  LastVDH.Depreciation_End_Date> DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--										  Then
--											  Datediff(d,   DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month))),							
--												  (Case When getdate()<LastVDH.Depreciation_End_Date then getdate() 
--													Else 
--													   LastVDH.Depreciation_End_Date-1
--												   End)
--											   )
--											Else 0
--										 End		
--									  ) 
--							 Else 
--									V.Vehicle_Cost-
--									 Round
--									 (
--											(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--													 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--													 Else 0
--											End)*12/365  ,
--											2
--										)  -- Daily Deprecation Rate						 
--									  *
--									  (
--										  Case When  LastVDH.Depreciation_End_Date> DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--										  Then
--											  Datediff(d,   DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month))),							
--												  (Case When getdate()<LastVDH.Depreciation_End_Date then getdate() 
--													Else 
--													   LastVDH.Depreciation_End_Date-1
--												   End)
--											   )
--											Else 0
--										 End		
--									  ) 
--										
--						  End) AS BookValue,

						dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  AS BookValue,

						dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  -ISNULL(V.Price_Difference,0) as NBV ,   -- NBV
                         
							--=Selling Price – (NBV – (KM Charge + Deduction))
                          V.Selling_Price
						  -
						  (
                                    --NBV
								  (
								   dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  -ISNULL(V.Price_Difference,0)
												
									)   -- End NBV				
                           		-    (ISNULL(Deduction,0)	+ISNULL(KM_Charge,0))
							 )
							As OtherGainLoss, -- Gain Loss Other than decution and KM_Charge
							
							 V.Selling_Price
						   -
						   --NBV
						   (
						    dbo.VehCurrentBookValue(V.Unit_Number, Getdate())  -ISNULL(V.Price_Difference,0)
										
							)   -- End NBV				
                            As GainLoss,	

							ISNULL(KM_Charge,0)*(-1) as KM_Charge,			
							ISNULL(Deduction,0)*(-1) as Deduction,
							ISNULL(Damage_Amount,0) as Damage_Amount,	
							 V.TB_Expense						
							--(Case When V.Program =1 Then ISNULL(Damage_Amount,0)  Else 0 End) as TurnBackExpense 
							

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
			inner join 
			(SELECT MAX(VM1.Date_In) AS Last_Move_Time, VM1.Unit_Number As Unit_number FROM
				(SELECT     Movement_In as Date_in, Unit_Number
					FROM         dbo.Vehicle_Movement
				 UNION
				 SELECT Actual_Check_In as Date_in, Unit_Number
					FROM	 vehicle_on_contract) VM1 Group By VM1.Unit_Number) VM
				on V.unit_number=vm.unit_number

		  INNER JOIN
						(
								SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
													dbo.FA_Vehicle_Amortization.AMO_Amount, 											
													dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
													dbo.FA_Vehicle_Amortization.AMO_Month
								FROM         dbo.FA_Vehicle_Amortization
								Inner Join 
								(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
															Max(AMO_Month) as AMOMonth
										FROM         dbo.FA_Vehicle_Amortization							
										Group By Unit_Number								
								) LastMonth
								On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
						 ) LastAMO
    			On V.Unit_Number =LastAMO.Unit_Number
				Left JOIN
				 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
					(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
							Else Convert (Datetime,  '2078-12-31')
					End) Depreciation_End_Date,
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
					dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
					from dbo.FA_Vehicle_Depreciation_History  
							Inner Join 
							(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
								FROM         FA_Vehicle_Depreciation_History						
									Group By Unit_Number									
						) LastDep
						On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
					
					) LastVDH

				 On  V.Unit_Number =LastVDH.Unit_Number

			
--		   LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--				ON V.Unit_Number = FAISD.Unit_Number
			Left Join Vehicle_Total_Held_Days_vw VTH 
				On V.Unit_Number=VTH.Unit_Number
			Left Join Vehicle_Total_PFD_Days_vw VTP 
				On V.Unit_Number=VTP.Unit_Number
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

						
			WHERE     --(LastAMO.AMO_Month BETWEEN @dMonthBeginning AND @dMonthEnd) and (V.OSD<=@dMonthEnd)
							  (@SellTo='*' or V.Sell_To =@SellTo) And (V.sold_date between @dBeginning and @dEnd)

   Order by 	Buyer.Buyer_Name,V.Sales_Processed_date,VMY.Model_Name











GO
