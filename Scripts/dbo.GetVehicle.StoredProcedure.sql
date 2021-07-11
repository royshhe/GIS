USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicle]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--GetVehicle 167399,'5LMFU28599LJ01908','','','','r','','',''

/*
PURPOSE: To search and retrieve a vehicle by the given params
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 5 2000	Return vehicle rental status code instead of the rental status desc.
Sli 	Aug 31 2005	Add MVA Number for compatibility level 80
*/
CREATE PROCEDURE [dbo].[GetVehicle] --186895,'','','','','r','','',''


	@UnitNumber		VarChar(10),
	@SerialNumber		VarChar(10),	
	@MVANumber		VarChar(10),
	@CategoryManufaturer	VarChar(20),
	@NumericKey		VarChar(1),
	@Retrieve		VarChar(1),
	@CategoryVehicleStatus  VarChar(25),
	@CategoryRentalStatus	VarChar(25),
	@CategoryConditionStatus VarChar(25)
AS
	--If @SerialNumber = ''
		--SELECT @SerialNumber = NULL
/*
NP - Aug 09 1999 - Added DropShip time, OwnerShip time, Licence Plate Attached On time and Vehicle Status Time to the select statement.
		    DropShip date, OwnerShip date, Licence Plate Attached On date and Vehicle Status date do not contain the time part
rhe- aug 20 2005  - fix for db compability level 80
*/
  If @Retrieve = ''
	If @UnitNumber = ''
		SELECT	V.Unit_Number,
			V.Foreign_Vehicle_Unit_Number,
			V.Serial_Number,
			V.Key_Ignition_Code,
			V.Key_Trunk_Code,
			V.Exterior_Colour,
			V.Interior_Colour,
			L.Value,
			VC.Vehicle_Type_ID,
			V.Vehicle_Class_Code,
			VMY.Model_Name,
			VMY.Model_Year,
			CONVERT(VarChar, V.Drop_ShipDate, 111),
			CONVERT(VarChar, V.Ownership_Date, 111),
			V.Owning_Company_ID,
			CONVERT(VarChar(1), V.Program),
			V.Turn_Back_Deadline,
			V.Maximum_KM,
			V.Do_Not_Rent_Past_KM,
			V.Minimum_Days,
			V.Maximum_Days,
			V.Do_Not_Rent_Past_Days,
			V.Reconditioning_Days_Allowed,
			V.Current_Location_ID,
			V.Current_KM,
			V.Total_Non_Revenue_KM,
			V.Next_Scheduled_Maintenance,
			CONVERT(VarChar(1), V.Smoking_Flag),
			V.Maximum_Rental_Period,
			L_VehStatus.Value,
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 111),
			V.Current_Rental_Status, --L_RentalStatus.Value,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 111),
			L_ConditionStatus.Value,
			CONVERT(VarChar, V.Condition_Status_Effective_On, 111),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 111),
			V.Current_Licence_Plate,
			V.Current_Licencing_Prov_State,
			CONVERT(VarChar(1),V.Foreign_Licence_Plate_Flag),
			V.Comments,
			V.Last_Update_By,
			CONVERT(VarChar, V.Last_Update_On, 111) Last_Update_On,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 108),
			CONVERT(VarChar, V.Condition_Status_Effective_On, 108),
			V.Current_Vehicle_Status,
			CONVERT(VarChar, V.Drop_ShipDate, 108),
			CONVERT(VarChar, V.Ownership_Date, 108),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 108),
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 108),
			V.MVA_Number,
            		V.Risk_Type,
			V.Dealer_ID,
			V.Year_Of_Agreement, 
			V.Purchase_Cycle, 
			V.Purchase_Price, 
			V.PDI_Amount, 
			CONVERT(VarChar(1), V.PDI_Included_In_Price), 
			V.PDI_Performed_By, 
			V.Volume_Incentive, 
			V.Incentive_Received_From, 
			V.Rebate_Amount, 
			V.Rebate_From, 
			V.Planned_Days_In_Service, 
			V.Vehicle_Cost, 
			CONVERT(VarChar(1),V.Own_Use) Own_Use, 		
			V.Purchase_GST, 
			V.Purchase_PST, 
			(Case When V.Payment_Type is not null Then Payment_Type
			         Else 'B'
			End) Payment_Type, 

--			CONVERT
--			(
--					VarChar,
--					(Case when V.Depreciation_Start_Date is not null then V.Depreciation_Start_Date
--								Else   dbo.VehicleISD(V.Unit_Number)--FAISD.ISD				
--					End),
--					111
--			) Depreciation_Start_Date,
		   CONVERT(VarChar, V.Depreciation_Start_Date, 111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_End_Date, 111) Depreciation_End_Date,
-- 
--			CONVERT
--			(
--					VarChar,
--					(Case WHEN V.Depreciation_End_Date is not null then V.Depreciation_End_Date
--								ELSE
--										(Case When V.Program = 1 then VH.Effective_On
--											      ELSE V.OSD
--										End) 
--						END),
--					111
--			)	 Depreciation_End_Date,

			V.Depreciation_Rate_Amount, 
			V.Depreciation_Rate_Percentage, 
			V.Loan_Repaid_Max_KM,
			V.Loan_Repaid_Max_Ownership,
			V.Finance_By, 
			V.Trans_Month,
			V.Loan_Amount,  
			CONVERT(VarChar(1), V.Loan_Tax_Included) Loan_Tax_Included, 
			V.Loan_Principal_Rate_ID,
			V.Override_Principal_Rate,
			CONVERT(VarChar, V.Financing_Start_Date,111) Financing_Start_Date, 
			CONVERT(VarChar, V.Financing_End_Date,111) Financing_End_Date, 
			--V.Term, 
			V.Payout_Amount, 
			CONVERT(VarChar, V.Payount_Date,111) Payount_Date, 
			V.Loan_Setup_Fee,
			
			V.Cap_Cost,
			V.Deduction, 
			V.Damage_Amount, 			
			V.KM_Reading, 			
			KM_Charge,			
			(Case
						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
						Else ''
			End) as ManufacturerISD,
			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,
			CONVERT(VarChar(11), V.ISD, 13) ISD,
			V.OSD,
--			(
--			Case When V.Sales_Processed =1  or V.Idle_Days is Not Null  Then V.Idle_Days 
--					Else	
--                           (Case When (VFH.HeldDate is Not Null ) And (V.OSD>VFH.HeldDate Or V.OSD is Null)  And  RTND.Allow_Non_Dep=1 Then											
--									DateDiff(d, VFH.HeldDate, 
--											(Case When V.OSD is not Null and V.OSD<getdate() then  V.OSD
--													  Else Getdate()
--											 End)
--									 )	
--							Else  NULL
--							End)
--			End)
--            As IdleDays,
			V.Idle_Days ,
			V.Depreciation_Periods, 
			V.Selling_Monthly_AMO, 
--			(Case When V.Depreciation_Type is not null Then Depreciation_Type
--			         Else 'D'
--			End) Depreciation_Type, 
			V.Depreciation_Type,
			V.Sales_Acc_Dep, 
			V.Selling_Price, 
			V.Sales_GST, 
			V.Sales_PST, 
			V.Sell_To, 
			--V.Sales_Processed, 
			CONVERT(VarChar(11), V.Sales_Processed_date,111) Sales_Processed_date,
			convert(varchar,VH.Effective_On,111) AS Disposal_Date,
			V.Lessee_ID,
			V.Initial_Cost,
			V.Interest_Rate,
			V.Principle_Rate,
			convert(varchar,V.Lease_Start_Date,111) as Lease_Start_Date,
			convert(varchar,V.Lease_End_Date,111) as Lease_End_Date,
			CONVERT(VarChar(1),V.Private_Lease), --Private_lease
--
--			(Case When LastAMO.Balance Is Not Null Then --VehBookValue.BookValue
--							LastAMO.Balance-
--								 Round
--								 (
--										(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--												 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--												 Else 0
--										End)*12/365  ,
--										2
--									)  -- Daily Deprecation Rate						 
--								  *
--								  (
--									  Case When  LastVDH.Depreciation_End_Date> DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--									  Then
--										  Datediff(d,  
--															
--													    (Case When LastVDH.Depreciation_Start_Date>=DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--															  Then LastVDH.Depreciation_Start_Date
--															  Else  DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--													    End),
--
--													   (Case When getdate()<LastVDH.Depreciation_End_Date then getdate() 
--														Else 
--														   LastVDH.Depreciation_End_Date-1
--													   End)
--										)
--										Else 0
--									 End		
--								  ) 
--						 Else 
--								V.Vehicle_Cost-
--								 Round
--								 (
--										(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--												 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--												 Else 0
--										End)*12/365  ,
--										2
--									)  -- Daily Deprecation Rate						 
--								
--								  *
--								   (
--
--                                     Case When LastVDH.Depreciation_End_Date>GetDate() Then DateDiff(d, LastVDH.Depreciation_Start_Date, GetDate())
--											 Else DateDiff(d, LastVDH.Depreciation_Start_Date, LastVDH.Depreciation_End_Date)
--									 End
--                                   )
--									
--			End)	-dbo.ZeroIfNull(V.Price_Difference)  NBV,

			dbo.VehCurrentBookValue(V.Unit_Number, Getdate()) -dbo.ZeroIfNull(V.Price_Difference)  NBV,


			(Case When VehLoanBlance.LoanBlance Is Not Null Then VehLoanBlance.LoanBlance 
			     Else V.Loan_Amount
			End) -dbo.ZeroIfNull(V.Payout_Amount) LoanBlance,
			V.Declaration_Amount,
			V.Amount_Paid,
			V.Payment_Cheque_No,
			CONVERT(Varchar,V.Payment_Date,111) Payment_Date,
			CONVERT(VarChar(1),V.Sales_Processed),
			VMY.PST_Rate,
			VTP.PFDDays,
			VTH.HeldDays, 

--			(Case When LastAMO.Balance Is Not Null Then --VehBookValue.BookValue
--							LastAMO.Balance-
--								 Round
--								 (
--										(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--												 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--												 Else 0
--										End)*12/365  ,
--										2
--									)  -- Daily Deprecation Rate						 
--								  *
--								  (
--									  Case When  LastVDH.Depreciation_End_Date> DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--									  Then
--										  Datediff(d,  
--															
--													    (Case When LastVDH.Depreciation_Start_Date>=DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--															  Then LastVDH.Depreciation_Start_Date
--															  Else  DATEADD(month,1, (LastAMO.AMO_Month-Day(LastAMO.AMO_Month)))
--													    End),
--
--													   (Case When getdate()<LastVDH.Depreciation_End_Date then getdate() 
--														Else 
--														   LastVDH.Depreciation_End_Date-1
--													   End)
--										)
--										Else 0
--									 End		
--								  ) 
--						 Else 
--								V.Vehicle_Cost-
--								 Round
--								 (
--										(Case When LastVDH.Depreciation_Rate_Amount is Not Null Then LastVDH.Depreciation_Rate_Amount
--												 When LastVDH.Depreciation_Rate_Percentage is Not Null Then V.Vehicle_Cost*LastVDH.Depreciation_Rate_Percentage/100
--												 Else 0
--										End)*12/365  ,
--										2
--									)  -- Daily Deprecation Rate						 
--								  *
--								   
--								   (
--
--                                     Case When LastVDH.Depreciation_End_Date>GetDate() Then DateDiff(d, LastVDH.Depreciation_Start_Date, GetDate())
--											 Else DateDiff(d, LastVDH.Depreciation_Start_Date, LastVDH.Depreciation_End_Date)
--									 End
--                                   )
--									
--			End) AS BookValue,

			dbo.VehCurrentBookValue(V.Unit_Number, Getdate()) AS BookValue,

			V.Price_Difference,
			CONVERT(VarChar, VFH.HeldDate,111) HeldSince,
			CONVERT(VarChar(1), RTND.Allow_Non_Dep) As NonDep,
			CONVERT(VarChar, V.Purchase_Process_Date,111) Purchase_Process_Date,
			V.Mark_Down,
			V.Excise_Tax,
			Battery_Levy,
			V.Market_Price,
			V.Sold_date,
			V.Ownership,
			V.Turn_Back_Message,
			V.FA_Remarks,
			V.Overrid_PM_Schedule_Id,
			V.TB_Expense
			 


--select *
FROM         dbo.Vehicle V 
INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
INNER JOIN   dbo.Vehicle_Class VC 
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code 
LEFT OUTER JOIN
                      dbo.FA_Risk_Type_Non_Dep AS RTND ON V.Risk_Type = RTND.Risk_Type
LEFT OUTER JOIN     dbo.Lookup_Table L 
		ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		= @CategoryManufaturer
LEFT OUTER JOIN    dbo.Lookup_Table L_VehStatus 
		ON V.Current_Vehicle_Status = L_VehStatus.Code AND	L_VehStatus.Category	= @CategoryVehicleStatus
LEFT OUTER JOIN      dbo.Lookup_Table L_RentalStatus 
		ON V.Current_Rental_Status = L_RentalStatus.Code  AND	L_RentalStatus.Category	= @CategoryRentalStatus
LEFT OUTER JOIN    dbo.Lookup_Table L_ConditionStatus 
		ON V.Current_Condition_Status = L_ConditionStatus.Code AND	L_ConditionStatus.Category	= @CategoryConditionStatus
--LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON V.Unit_Number = FAISD.Unit_Number
LEFT OUTER JOIN			
			(Select Unit_number, Vehicle_Status, max(Effective_On) Effective_On from Vehicle_History 
			Group by Unit_number, Vehicle_Status) VH
                       ON V.Unit_Number = VH.Unit_Number AND (V.Program = 0 AND VH.Vehicle_Status = 'f' OR
                      V.Program = 1 AND VH.Vehicle_Status = 'g')
LEFT OUTER JOIN Vehicle_Total_Held_Days_vw  VTH 
					ON V.Unit_number=VTH.Unit_number
LEFT OUTER JOIN Vehicle_Total_PFD_Days_vw  VTP 
					ON V.Unit_number=VTP.Unit_number
LEFT OUTER JOIN 	Vehicle_First_Held_vw VFH
					ON V.Unit_number=VFH.Unit_number
LEFT OUTER JOIN
                      dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
--LEFT OUTER JOIN
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number

--LEFT OUTER JOIN
--
--	(
--						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
--											dbo.FA_Vehicle_Amortization.AMO_Amount, 											
--											dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
--											dbo.FA_Vehicle_Amortization.AMO_Month
--						FROM         dbo.FA_Vehicle_Amortization
--						Inner Join 
--						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
--													Max(AMO_Month) as AMOMonth
--								FROM         dbo.FA_Vehicle_Amortization							
--								Group By Unit_Number								
--						) LastMonth
--						On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
--				 ) LastAMO
--    	On V.Unit_Number =LastAMO.Unit_Number
--
--
--LEFT OUTER JOIN
--
--		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
--			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
--					Else Convert (Datetime,  '2078-12-31')
--			End) Depreciation_End_Date,
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
--			from dbo.FA_Vehicle_Depreciation_History  
--					Inner Join 
--					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
--						FROM         FA_Vehicle_Depreciation_History						
--							Group By Unit_Number									
--				) LastDep
--				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
--			
--			) LastVDH
--
--		 On  V.Unit_Number =LastVDH.Unit_Number
--
--
LEFT OUTER JOIN 
		(
		Select LoanAMO.Unit_Number, LoanAMO.Balance LoanBlance
		from  FA_Loan_Amortization LoanAMO
		Inner Join
		(select Unit_Number, max(AMO_Month) AMO_Month, max(Finance_Start_Date)as Finance_Start_Date from FA_Loan_Amortization
		Group by Unit_Number) LastLoanAMO
		On LoanAMO.Unit_Number=LastLoanAMO.Unit_Number and LoanAMO.Finance_Start_Date=LastLoanAMO.Finance_Start_Date 
			 And LoanAMO.AMO_Month=LastLoanAMO.AMO_Month 
		) VehLoanBlance
		On V.Unit_Number=VehLoanBlance.Unit_Number


WHERE	(	V.MVA_Number = isnull(@MVANumber, '')
			OR	
				@MVANumber = ''
			)
		AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
			OR
				@SerialNumber = ''
			)		
        
		AND	Deleted			= 0

/*
		FROM	Vehicle V,
			Vehicle_Class VC,
			Vehicle_Model_Year VMY,
			FA_Inservcie_Date_vw FAISD,
			Lookup_Table L,
			Lookup_Table L_VehStatus,
			Lookup_Table L_RentalStatus,
			Lookup_Table L_ConditionStatus
		
		WHERE	(	V.MVA_Number = isnull(@MVANumber, '')
			OR	
				@MVANumber = ''
			)
		AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
			OR
				@SerialNumber = ''
			)		
        
		AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
		AND	VMY.Manufacturer_ID 	*= CONVERT(SmallInt, L.Code)
		AND	L.Category		= @CategoryManufaturer
		AND	V.Vehicle_Class_Code	= VC.Vehicle_Class_Code
		AND	L_VehStatus.Category	= @CategoryVehicleStatus
		AND	V.Current_Vehicle_Status *= L_VehStatus.Code
		AND	L_RentalStatus.Category	= @CategoryRentalStatus
		AND	V.Current_Rental_Status *= L_RentalStatus.Code
		AND	L_ConditionStatus.Category	= @CategoryConditionStatus
		AND	V.Current_Condition_Status *= L_ConditionStatus.Code
		AND    V.Unit_Number *= FAISD.Unit_Number
		AND	Deleted			= 0
*/
	Else
	  	If @NumericKey = ''
			SELECT	V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,
				V.Key_Ignition_Code,
				V.Key_Trunk_Code,
				V.Exterior_Colour,
				V.Interior_Colour,
				L.Value,
				VC.Vehicle_Type_ID,
				V.Vehicle_Class_Code,
				VMY.Model_Name,
				VMY.Model_Year,
				CONVERT(VarChar, V.Drop_ShipDate, 111),
				CONVERT(VarChar, V.Ownership_Date, 111),
				V.Owning_Company_ID,
				CONVERT(VarChar(1), V.Program),
				V.Turn_Back_Deadline,
				V.Maximum_KM,
				V.Do_Not_Rent_Past_KM,
				V.Minimum_Days,
				V.Maximum_Days,
				V.Do_Not_Rent_Past_Days,
				V.Reconditioning_Days_Allowed,
				V.Current_Location_ID,
				V.Current_KM,
				V.Total_Non_Revenue_KM,
				V.Next_Scheduled_Maintenance,
				CONVERT(VarChar(1), V.Smoking_Flag),
				V.Maximum_Rental_Period,
				L_VehStatus.Value,
				CONVERT(VarChar, V.Vehicle_Status_Effective_On, 111),
				V.Current_Rental_Status, --L_RentalStatus.Value,
				CONVERT(VarChar, V.Rental_Status_Effective_On, 111),
				L_ConditionStatus.Value,
				CONVERT(VarChar, V.Condition_Status_Effective_On, 111),
				CONVERT(VarChar, V.Licence_Plate_Attached_On, 111),
				V.Current_Licence_Plate,
				V.Current_Licencing_Prov_State,
				CONVERT(VarChar(1),V.Foreign_Licence_Plate_Flag),
				V.Comments,
				V.Last_Update_By,
				CONVERT(VarChar, V.Last_Update_On, 111) Last_Update_On,
				CONVERT(VarChar, V.Rental_Status_Effective_On, 108),
				CONVERT(VarChar, V.Condition_Status_Effective_On, 108),
				V.Current_Vehicle_Status,
				CONVERT(VarChar, V.Drop_ShipDate, 108),
				CONVERT(VarChar, V.Ownership_Date, 108),
				CONVERT(VarChar, V.Licence_Plate_Attached_On, 108),
				CONVERT(VarChar, V.Vehicle_Status_Effective_On, 108),
				V.MVA_number,
				V.Risk_Type,
				V.Dealer_ID,
				V.Year_Of_Agreement, 
				V.Purchase_Cycle, 
				V.Purchase_Price, 
				V.PDI_Amount, 
				CONVERT(VarChar(1), V.PDI_Included_In_Price), 
				V.PDI_Performed_By, 
				V.Volume_Incentive, 
				V.Incentive_Received_From, 
				V.Rebate_Amount, 
				V.Rebate_From, 
				V.Planned_Days_In_Service, 
				V.Vehicle_Cost, 
				CONVERT(VarChar(1),V.Own_Use) Own_Use, 			
				V.Purchase_GST, 
				V.Purchase_PST, 
				(Case When V.Payment_Type is not null Then Payment_Type
			         Else 'B'
			   End) Payment_Type, 
--				CONVERT(VarChar,
--									(Case when V.Depreciation_Start_Date is not null then V.Depreciation_Start_Date
--												Else  dbo.VehicleISD(V.Unit_Number)				
--									End),
--								111) Depreciation_Start_Date, 
				CONVERT(VarChar, V.Depreciation_Start_Date, 111) Depreciation_Start_Date, 
				CONVERT(VarChar, V.Depreciation_End_Date, 111) Depreciation_End_Date,
--				CONVERT
--				(
--					VarChar,
--					(Case WHEN V.Depreciation_End_Date is not null then V.Depreciation_End_Date
--								ELSE
--										(Case When V.Program = 1 then VH.Effective_On
--											      ELSE V.OSD
--										End) 
--						END),
--					111
--				)	 Depreciation_End_Date,

				V.Depreciation_Rate_Amount, 
				V.Depreciation_Rate_Percentage, 
				V.Loan_Repaid_Max_KM,
				V.Loan_Repaid_Max_Ownership,
				V.Finance_By, 
				V.Trans_Month,
				V.Loan_Amount,  
				CONVERT(VarChar(1), V.Loan_Tax_Included) Loan_Tax_Included, 
				V.Loan_Principal_Rate_ID,
				V.Override_Principal_Rate,
				CONVERT(VarChar, V.Financing_Start_Date,111) Financing_Start_Date, 
				CONVERT(VarChar, V.Financing_End_Date,111) Financing_End_Date, 
				--V.Term, 
				V.Payout_Amount, 
				CONVERT(VarChar, V.Payount_Date,111) Payount_Date, 		
				V.Loan_Setup_Fee,
--			
--				(Case When V.Cap_Cost is not null then V.Cap_Cost
--					  When dbo.FA_Repurchase_Eligibility.Capitalized is not null And V.Program = 1 then dbo.FA_Repurchase_Eligibility.Capitalized
--					  Else V.Vehicle_Cost
--			   End) Cap_Cost, 
--				V.Deduction, 
--				V.Damage_Amount, 
--						-- default KM Reading
--				(Case When V.KM_Reading is Not Null  Then V.KM_Reading 
--						Else V.Current_KM
--				End) KM_Reading,
--				--Default KM Charge 
--				(Case When KM_Charge is Not Null Then KM_Charge
--						 Else
--								(Case When V.KM_Reading is Not Null Then [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.KM_Reading)
--										 Else [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.Current_KM)
--								End)
--				End) KM_Charge, 
--				 --[dbo].[GetKMCharge] ('2010', '1', 'Ford','1','42000')
--			   
--				(Case
--						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
--						Else ''
--				End) as ManufacturerISD,
--				CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,
--				CONVERT(VarChar(11), V.ISD, 13) ISD,
--				(Case 
--							When V.OSD is Not Null then	CONVERT(VarChar(11), V.OSD, 13)
--							Else CONVERT(VarChar(11),VH.Effective_On ,13) 
--				End)	 OSD,	


			V.Cap_Cost,
			V.Deduction, 
			V.Damage_Amount, 			
			V.KM_Reading, 			
			KM_Charge,			
           	(Case
						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
						Else ''
			End) as ManufacturerISD,
			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,

			CONVERT(VarChar(11), V.ISD, 13) ISD,
			V.OSD,
			
--				(
--				Case When V.Sales_Processed =1  or V.Idle_Days is Not Null  Then V.Idle_Days 
--						Else	
--							   (Case When (VFH.HeldDate is Not Null ) And (V.OSD>VFH.HeldDate Or V.OSD is Null)  And  RTND.Allow_Non_Dep=1 Then											
--										DateDiff(d, VFH.HeldDate, 
--												(Case When V.OSD is not Null and V.OSD<getdate() then  V.OSD
--														  Else Getdate()
--												 End)
--										 )	
--								Else  NULL
--								End)
--				 End)
--			    As IdleDays,
				V.Idle_Days,
				V.Depreciation_Periods, 
				V.Selling_Monthly_AMO, 
--				(Case When V.Depreciation_Type is not null Then Depreciation_Type
--			         Else 'D'
--				End) Depreciation_Type, 
				V.Depreciation_Type,
				V.Sales_Acc_Dep, 
				V.Selling_Price, 
				V.Sales_GST, 
				V.Sales_PST, 
				V.Sell_To, 
				--V.Sales_Processed, 
				CONVERT(VarChar(11), V.Sales_Processed_date,111) Sales_Processed_date,
				CONVERT(VARCHAR,VH.Effective_On,111) AS Disposal_Date,
				V.Lessee_ID,
				V.Initial_Cost,
				V.Interest_Rate,
				V.Principle_Rate,
				CONVERT(Varchar,V.Lease_Start_Date,111) Lease_Start_Date,
				CONVERT(Varchar,V.Lease_End_Date,111) Lease_End_Date,
				CONVERT(VarChar(1),V.Private_Lease), --Private_lease
  			    dbo.VehCurrentBookValue(V.Unit_Number, Getdate())-dbo.ZeroIfNull(V.Price_Difference) NBV,
				(Case When VehLoanBlance.LoanBlance Is Not Null Then VehLoanBlance.LoanBlance 
				     Else V.Loan_Amount
				 End) -dbo.ZeroIfNull(V.Payout_Amount) LoanBlance,
				V.Declaration_Amount,
				V.Amount_Paid,
				V.Payment_Cheque_No,
				CONVERT(VarChar,V.Payment_Date,111) Payment_Date,
				CONVERT(VarChar(1),V.Sales_Processed),
				VMY.PST_Rate,
				PFDDays,
				VTH.HeldDays,
				dbo.VehCurrentBookValue(V.Unit_Number, Getdate()) AS BookValue,
				V.Price_Difference,
			    CONVERT(VarChar, VFH.HeldDate,111) HeldSince,
				CONVERT(VarChar(1), RTND.Allow_Non_Dep) As NonDep,
				CONVERT(VarChar, V.Purchase_Process_Date,111) Purchase_Process_Date,
				V.Mark_Down,
				V.Excise_Tax,
				Battery_Levy,
				V.Market_Price,
				V.Sold_date,
				V.Ownership,
				V.Turn_Back_Message,
				V.FA_Remarks,
				V.Overrid_PM_Schedule_Id,
				V.TB_Expense






FROM         dbo.Vehicle V 
INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
INNER JOIN   dbo.Vehicle_Class VC 
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code 
LEFT OUTER JOIN
                      dbo.FA_Risk_Type_Non_Dep AS RTND ON V.Risk_Type = RTND.Risk_Type
LEFT OUTER JOIN     dbo.Lookup_Table L 
		ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		= @CategoryManufaturer
LEFT OUTER JOIN    dbo.Lookup_Table L_VehStatus 
		ON V.Current_Vehicle_Status = L_VehStatus.Code AND	L_VehStatus.Category	= @CategoryVehicleStatus
LEFT OUTER JOIN      dbo.Lookup_Table L_RentalStatus 
		ON V.Current_Rental_Status = L_RentalStatus.Code  AND	L_RentalStatus.Category	= @CategoryRentalStatus
LEFT OUTER JOIN    dbo.Lookup_Table L_ConditionStatus 
		ON V.Current_Condition_Status = L_ConditionStatus.Code AND	L_ConditionStatus.Category	= @CategoryConditionStatus
--LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON V.Unit_Number = FAISD.Unit_Number
LEFT OUTER JOIN
              (Select Unit_number, Vehicle_Status, max(Effective_On) Effective_On from Vehicle_History 
					Group by Unit_number, Vehicle_Status)  VH 
			ON V.Unit_Number = VH.Unit_Number AND (V.Program = 0 AND VH.Vehicle_Status = 'f' OR
                      V.Program = 1 AND VH.Vehicle_Status = 'g')
LEFT OUTER JOIN Vehicle_Total_Held_Days_vw  VTH 
					ON V.Unit_number=VTH.Unit_number
LEFT OUTER JOIN Vehicle_Total_PFD_Days_vw  VTP 
					ON V.Unit_number=VTP.Unit_number
LEFT OUTER JOIN 	Vehicle_First_Held_vw VFH
					ON V.Unit_number=VFH.Unit_number
LEFT OUTER JOIN
                      dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
--LEFT OUTER JOIN
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number
--LEFT OUTER JOIN
--
--	(
--						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
--											dbo.FA_Vehicle_Amortization.AMO_Amount, 											
--											dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
--											dbo.FA_Vehicle_Amortization.AMO_Month
--						FROM         dbo.FA_Vehicle_Amortization
--						Inner Join 
--						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
--													Max(AMO_Month) as AMOMonth
--								FROM         dbo.FA_Vehicle_Amortization							
--								Group By Unit_Number								
--						) LastMonth
--						On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
--				 ) LastAMO
--    	On V.Unit_Number =LastAMO.Unit_Number
--
--LEFT OUTER JOIN
--
--		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
--			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
--					Else Convert (Datetime,  '2078-12-31')
--			End) Depreciation_End_Date,
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
--			from dbo.FA_Vehicle_Depreciation_History  
--					Inner Join 
--					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
--						FROM         FA_Vehicle_Depreciation_History						
--							Group By Unit_Number									
--				) LastDep
--				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
--			
--			) LastVDH
--
--		 On  V.Unit_Number =LastVDH.Unit_Number


LEFT OUTER JOIN 
		(
		Select LoanAMO.Unit_Number, LoanAMO.Balance LoanBlance
		from  FA_Loan_Amortization LoanAMO
		Inner Join
		(select Unit_Number, max(AMO_Month) AMO_Month, max(Finance_Start_Date)as Finance_Start_Date from FA_Loan_Amortization
		Group by Unit_Number) LastLoanAMO
		On LoanAMO.Unit_Number=LastLoanAMO.Unit_Number and LoanAMO.Finance_Start_Date=LastLoanAMO.Finance_Start_Date 
			 And LoanAMO.AMO_Month=LastLoanAMO.AMO_Month 
		) VehLoanBlance
		On V.Unit_Number=VehLoanBlance.Unit_Number

			WHERE	V.Foreign_Vehicle_Unit_Number = @UnitNumber
--			AND	ISNULL(V.Serial_Number, '%' + LTrim(@SerialNumber)) Like '%' + LTrim(@SerialNumber)
			AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
				OR
					@SerialNumber ='' --IS NULL
				)
			AND	(	V.MVA_Number = isnull(@MVANumber,'')
				OR
					@MVANumber = '' --IS NULL
				)
			AND	Deleted			= 0

/*
			FROM	Vehicle V,
				Vehicle_Class VC,
				Vehicle_Model_Year VMY,
				FA_Inservcie_Date_vw FAISD,
				Lookup_Table L,
				Lookup_Table L_VehStatus,
				Lookup_Table L_RentalStatus,
				Lookup_Table L_ConditionStatus
			WHERE	V.Foreign_Vehicle_Unit_Number = @UnitNumber
--			AND	ISNULL(V.Serial_Number, '%' + LTrim(@SerialNumber)) Like '%' + LTrim(@SerialNumber)
			AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
				OR
					@SerialNumber ='' --IS NULL
				)
			AND	(	V.MVA_Number = isnull(@MVANumber,'')
				OR
					@MVANumber = '' --IS NULL
				)
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	VMY.Manufacturer_ID 	*= CONVERT(SmallInt, L.Code)
			AND	L.Category		= @CategoryManufaturer
	
			AND	V.Vehicle_Class_Code	= VC.Vehicle_Class_Code
			AND	L_VehStatus.Category	= @CategoryVehicleStatus
			AND	V.Current_Vehicle_Status *= L_VehStatus.Code
			AND	L_RentalStatus.Category	= @CategoryRentalStatus
			AND	V.Current_Rental_Status *= L_RentalStatus.Code
			AND	L_ConditionStatus.Category	= @CategoryConditionStatus
			AND	V.Current_Condition_Status *= L_ConditionStatus.Code
			AND    V.Unit_Number *= FAISD.Unit_Number		
			AND	Deleted			= 0
*/
	  	Else
			SELECT	V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,
				V.Key_Ignition_Code,
				V.Key_Trunk_Code,
				V.Exterior_Colour,
				V.Interior_Colour,
				L.Value,
				VC.Vehicle_Type_ID,
				V.Vehicle_Class_Code,
				VMY.Model_Name,
				VMY.Model_Year,
				CONVERT(VarChar, V.Drop_ShipDate, 111),
				CONVERT(VarChar, V.Ownership_Date, 111),
				V.Owning_Company_ID,
				CONVERT(VarChar(1), V.Program),
				V.Turn_Back_Deadline,
				V.Maximum_KM,
				V.Do_Not_Rent_Past_KM,
				V.Minimum_Days,
				V.Maximum_Days,
				V.Do_Not_Rent_Past_Days,
				V.Reconditioning_Days_Allowed,
				V.Current_Location_ID,
				V.Current_KM,
				V.Total_Non_Revenue_KM,
				V.Next_Scheduled_Maintenance,
				CONVERT(VarChar(1), V.Smoking_Flag),
				V.Maximum_Rental_Period,
				L_VehStatus.Value,
				CONVERT(VarChar, V.Vehicle_Status_Effective_On, 111),
				V.Current_Rental_Status, --L_RentalStatus.Value,
				CONVERT(VarChar, V.Rental_Status_Effective_On, 111),
				L_ConditionStatus.Value,
				CONVERT(VarChar, V.Condition_Status_Effective_On, 111),
				CONVERT(VarChar, V.Licence_Plate_Attached_On, 111),
				V.Current_Licence_Plate,
				V.Current_Licencing_Prov_State,
				CONVERT(VarChar(1),V.Foreign_Licence_Plate_Flag),
				V.Comments,
				V.Last_Update_By,
				CONVERT(VarChar, V.Last_Update_On, 111) Last_Update_On,
				CONVERT(VarChar, V.Rental_Status_Effective_On, 108),
				CONVERT(VarChar, V.Condition_Status_Effective_On, 108),
				V.Current_Vehicle_Status,
				CONVERT(VarChar, V.Drop_ShipDate, 108),
				CONVERT(VarChar, V.Ownership_Date, 108),
				CONVERT(VarChar, V.Licence_Plate_Attached_On, 108),
				CONVERT(VarChar, V.Vehicle_Status_Effective_On, 108),
				V.MVA_Number,
				V.Risk_Type,
				V.Dealer_ID,
				V.Year_Of_Agreement, 
			V.Purchase_Cycle, 
			V.Purchase_Price, 
			V.PDI_Amount, 
			CONVERT(VarChar(1), V.PDI_Included_In_Price), 
			V.PDI_Performed_By, 
			V.Volume_Incentive, 
			V.Incentive_Received_From, 
			V.Rebate_Amount, 
			V.Rebate_From, 
			V.Planned_Days_In_Service, 
			V.Vehicle_Cost, 
			CONVERT(VarChar(1),V.Own_Use) Own_Use, 		
			V.Purchase_GST, 
			V.Purchase_PST, 
			(Case When V.Payment_Type is not null Then Payment_Type
			         Else 'B'
			End) Payment_Type, 
--			CONVERT(VarChar,
--									(Case when V.Depreciation_Start_Date is not null then V.Depreciation_Start_Date
--												Else  dbo.VehicleISD(V.Unit_Number)				
--									End),
--								111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_Start_Date, 111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_End_Date, 111) Depreciation_End_Date,
--			CONVERT
--			(
--					VarChar,
--					(Case WHEN V.Depreciation_End_Date is not null then V.Depreciation_End_Date
--								ELSE
--										(Case When V.Program = 1 then VH.Effective_On
--											      ELSE V.OSD
--										End) 
--						END),
--					111
--			)	 Depreciation_End_Date,

			V.Depreciation_Rate_Amount, 
			V.Depreciation_Rate_Percentage, 
			V.Loan_Repaid_Max_KM,
			V.Loan_Repaid_Max_Ownership,
			V.Finance_By, 
			V.Trans_Month, 
            V.Loan_Amount, 
			CONVERT(VarChar(1), V.Loan_Tax_Included) Loan_Tax_Included, 
			V.Loan_Principal_Rate_ID,
			V.Override_Principal_Rate,
			CONVERT(VarChar, V.Financing_Start_Date,111) Financing_Start_Date, 
			CONVERT(VarChar, V.Financing_End_Date,111) Financing_End_Date, 
			--V.Term, 
			V.Payout_Amount, 
			CONVERT(VarChar, V.Payount_Date,111) Payount_Date, 	
			V.Loan_Setup_Fee,
			
--			(Case When V.Cap_Cost is not null then V.Cap_Cost
--					  When dbo.FA_Repurchase_Eligibility.Capitalized is not null And V.Program = 1 then dbo.FA_Repurchase_Eligibility.Capitalized
--					  Else V.Vehicle_Cost
--			End) Cap_Cost, 
--			V.Deduction, 
--			V.Damage_Amount, 
--				-- default KM Reading
--			(Case When V.KM_Reading is Not Null  Then V.KM_Reading 
--					Else V.Current_KM
--			End) KM_Reading,
--			--Default KM Charge 
--			(Case When KM_Charge is Not Null Then KM_Charge
--					 Else
--							(Case When V.KM_Reading is Not Null Then [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.KM_Reading)
--									 Else [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.Current_KM)
--							End)
--			End) KM_Charge, 
--			 --[dbo].[GetKMCharge] ('2010', '1', 'Ford','1','42000')
--			
--			(Case
--					When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
--					Else ''
--			End) as ManufacturerISD,
--			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,
--			CONVERT(VarChar(11), V.ISD, 13) ISD,
--			(Case 
--							When V.OSD is Not Null then	CONVERT(VarChar(11), V.OSD, 13)
--							Else CONVERT(VarChar(11),VH.Effective_On ,13) 
--			End)	 OSD,		


			V.Cap_Cost,
			V.Deduction, 
			V.Damage_Amount, 			
			V.KM_Reading, 			
			KM_Charge,			
             (Case
						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
						Else ''
			End) as ManufacturerISD,
			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,

			CONVERT(VarChar(11), V.ISD, 13) ISD,
			V.OSD,
			 
--			(
--			Case When V.Sales_Processed =1  or V.Idle_Days is Not Null  Then V.Idle_Days 
--					Else	
--                           (Case When (VFH.HeldDate is Not Null ) And (V.OSD>VFH.HeldDate Or V.OSD is Null) And  RTND.Allow_Non_Dep=1 Then											
--									DateDiff(d, VFH.HeldDate, 
--											(Case When V.OSD is not Null and V.OSD<getdate() then  V.OSD
--													  Else Getdate()
--											 End)
--									 )	
--							Else  NULL
--							End)
--			 End)
--           As IdleDays,
			V.Idle_Days, 
			V.Depreciation_Periods, 
			V.Selling_Monthly_AMO, 
--			(Case When V.Depreciation_Type is not null Then Depreciation_Type
--			         Else 'D'
--			End) Depreciation_Type, 
			V.Depreciation_Type,
			V.Sales_Acc_Dep, 
			V.Selling_Price, 
			V.Sales_GST, 
			V.Sales_PST, 
			V.Sell_To, 
			--V.Sales_Processed, 
			CONVERT(VarChar(11), V.Sales_Processed_date,111) Sales_Processed_date,
			CONVERT(VarChar,VH.Effective_On,111) AS Disposal_Date,
			V.Lessee_ID,
			V.Initial_Cost,
			V.Interest_Rate,
			V.Principle_Rate,
			Convert(VarChar,V.Lease_Start_Date,111) Lease_Start_Date,
			Convert(Varchar,V.Lease_End_Date,111) Lease_End_Date,
			CONVERT(VarChar(1),V.Private_Lease), --Private_lease
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate())	-dbo.ZeroIfNull(V.Price_Difference) NBV,
			(Case When VehLoanBlance.LoanBlance Is Not Null Then VehLoanBlance.LoanBlance 
			     Else V.Loan_Amount
			 End) -dbo.ZeroIfNull(V.Payout_Amount) LoanBlance,
			V.Declaration_Amount,
			V.Amount_Paid,
			V.Payment_Cheque_No,
			convert(Varchar,V.Payment_Date,111) Payment_Date,
			CONVERT(VarChar(1),V.Sales_Processed),
			VMY.PST_Rate,
			PFDDays,
			VTH.HeldDays,
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate())AS BookValue,
			V.Price_Difference,
			CONVERT(VarChar, VFH.HeldDate,111) HeldSince,
		    CONVERT(VarChar(1), RTND.Allow_Non_Dep) As NonDep,
			 CONVERT(VarChar, V.Purchase_Process_Date,111) Purchase_Process_Date,
			V.Mark_Down,
			V.Excise_Tax,
			Battery_Levy,
			V.Market_Price,
			V.Sold_date,
			V.Ownership,
			V.Turn_Back_Message,
			V.FA_Remarks,
			V.Overrid_PM_Schedule_Id,
			V.TB_Expense	
 




FROM         dbo.Vehicle V 
INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
INNER JOIN   dbo.Vehicle_Class VC 
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code 
LEFT OUTER JOIN
                      dbo.FA_Risk_Type_Non_Dep AS RTND ON V.Risk_Type = RTND.Risk_Type
LEFT OUTER JOIN     dbo.Lookup_Table L 
		ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		= @CategoryManufaturer
LEFT OUTER JOIN    dbo.Lookup_Table L_VehStatus 
		ON V.Current_Vehicle_Status = L_VehStatus.Code AND	L_VehStatus.Category	= @CategoryVehicleStatus
LEFT OUTER JOIN      dbo.Lookup_Table L_RentalStatus 
		ON V.Current_Rental_Status = L_RentalStatus.Code  AND	L_RentalStatus.Category	= @CategoryRentalStatus
LEFT OUTER JOIN    dbo.Lookup_Table L_ConditionStatus 
		ON V.Current_Condition_Status = L_ConditionStatus.Code AND	L_ConditionStatus.Category	= @CategoryConditionStatus
--LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON V.Unit_Number = FAISD.Unit_Number
LEFT OUTER JOIN
           (Select Unit_number, Vehicle_Status, max(Effective_On) Effective_On from Vehicle_History 
			Group by Unit_number, Vehicle_Status)  VH 
			ON V.Unit_Number = VH.Unit_Number AND (V.Program = 0 AND VH.Vehicle_Status = 'f' OR
                      V.Program = 1 AND VH.Vehicle_Status = 'g')
LEFT OUTER JOIN Vehicle_Total_Held_Days_vw  VTH 
					ON V.Unit_number=VTH.Unit_number
LEFT OUTER JOIN Vehicle_Total_PFD_Days_vw  VTP 
					ON V.Unit_number=VTP.Unit_number
LEFT OUTER JOIN 	Vehicle_First_Held_vw VFH
					ON V.Unit_number=VFH.Unit_number
LEFT OUTER JOIN
                      dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
--LEFT OUTER JOIN
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number
--
--LEFT OUTER JOIN
--	(
--				SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
--									dbo.FA_Vehicle_Amortization.AMO_Amount, 											
--									dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
--									dbo.FA_Vehicle_Amortization.AMO_Month
--				FROM         dbo.FA_Vehicle_Amortization
--				Inner Join 
--				(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
--											Max(AMO_Month) as AMOMonth
--						FROM         dbo.FA_Vehicle_Amortization							
--						Group By Unit_Number								
--				) LastMonth
--				On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
--		 ) LastAMO
--	On V.Unit_Number =LastAMO.Unit_Number
--
--
--LEFT OUTER JOIN
--
--		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
--			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
--					Else Convert (Datetime,  '2078-12-31')
--			End) Depreciation_End_Date,
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
--			from dbo.FA_Vehicle_Depreciation_History  
--					Inner Join 
--					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
--						FROM         FA_Vehicle_Depreciation_History						
--							Group By Unit_Number									
--				) LastDep
--				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
--			
--			) LastVDH
--
--		 On  V.Unit_Number =LastVDH.Unit_Number


LEFT OUTER JOIN 
		(
		Select LoanAMO.Unit_Number, LoanAMO.Balance LoanBlance
		from  FA_Loan_Amortization LoanAMO
		Inner Join
		(select Unit_Number, max(AMO_Month) AMO_Month, max(Finance_Start_Date)as Finance_Start_Date from FA_Loan_Amortization
		Group by Unit_Number) LastLoanAMO
		On LoanAMO.Unit_Number=LastLoanAMO.Unit_Number and LoanAMO.Finance_Start_Date=LastLoanAMO.Finance_Start_Date 
			 And LoanAMO.AMO_Month=LastLoanAMO.AMO_Month 
		) VehLoanBlance
		On V.Unit_Number=VehLoanBlance.Unit_Number




			WHERE	(	
					(V.Unit_Number = CONVERT(Int, @UnitNumber) AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
				OR	(Foreign_Vehicle_Unit_Number = @UnitNumber)
				)
			AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
				OR
					@SerialNumber ='' --IS NULL
				)
			AND	(	V.MVA_Number = isnull(@MVANumber,'')
				OR
					@MVANumber = '' --IS NULL
				)

			AND	Deleted			= 0

/*

			FROM	Vehicle V,
				Vehicle_Class VC,
				Vehicle_Model_Year VMY,
				FA_Inservcie_Date_vw FAISD,
				Lookup_Table L,
				Lookup_Table L_VehStatus,
				Lookup_Table L_RentalStatus,
				Lookup_Table L_ConditionStatus
			WHERE	(	
					(V.Unit_Number = CONVERT(Int, @UnitNumber) AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
				OR	(Foreign_Vehicle_Unit_Number = @UnitNumber)
				)
			AND	(	V.Serial_Number Like '%' + LTrim(isnull(@SerialNumber,''))
				OR
					@SerialNumber ='' --IS NULL
				)
			AND	(	V.MVA_Number = isnull(@MVANumber,'')
				OR
					@MVANumber = '' --IS NULL
				)
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	VMY.Manufacturer_ID 	*= CONVERT(SmallInt, L.Code)
			AND	L.Category		= @CategoryManufaturer
			AND	V.Vehicle_Class_Code	= VC.Vehicle_Class_Code
			AND	L_VehStatus.Category	= @CategoryVehicleStatus
			AND	V.Current_Vehicle_Status *= L_VehStatus.Code
			AND	L_RentalStatus.Category	= @CategoryRentalStatus
			AND	V.Current_Rental_Status *= L_RentalStatus.Code
			AND	L_ConditionStatus.Category	= @CategoryConditionStatus
			AND	V.Current_Condition_Status *= L_ConditionStatus.Code
			AND    V.Unit_Number *= FAISD.Unit_Number
	
			AND	Deleted			= 0
*/

  Else
	IF UPPER(@RETRIEVE)='Y'
		SELECT	V.Unit_Number,
			V.Foreign_Vehicle_Unit_Number,
			V.Serial_Number,
			V.Key_Ignition_Code,
			V.Key_Trunk_Code,
			V.Exterior_Colour,
			V.Interior_Colour,
			L.Value,
			VC.Vehicle_Type_ID,
			V.Vehicle_Class_Code,
			VMY.Model_Name,
			VMY.Model_Year,
			CONVERT(VarChar, V.Drop_ShipDate, 111),
			CONVERT(VarChar, V.Ownership_Date, 111),
			V.Owning_Company_ID,
			CONVERT(VarChar(1), V.Program),
			V.Turn_Back_Deadline,
			V.Maximum_KM,
			V.Do_Not_Rent_Past_KM,
			V.Minimum_Days,
			V.Maximum_Days,
			V.Do_Not_Rent_Past_Days,
			V.Reconditioning_Days_Allowed,
			V.Current_Location_ID,
			V.Current_KM,
			V.Total_Non_Revenue_KM,
			V.Next_Scheduled_Maintenance,
			CONVERT(VarChar(1), V.Smoking_Flag),
			V.Maximum_Rental_Period,
			L_VehStatus.Value,
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 111),
			V.Current_Rental_Status, --L_RentalStatus.Value,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 111),
			L_ConditionStatus.Value,
			CONVERT(VarChar, V.Condition_Status_Effective_On, 111),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 111),
			V.Current_Licence_Plate,
			V.Current_Licencing_Prov_State,
			CONVERT(VarChar(1), V.Foreign_Licence_Plate_Flag),
			V.Comments,
			V.Last_Update_By,
			CONVERT(VarChar, V.Last_Update_On, 111) Last_Update_On,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 108),
			CONVERT(VarChar, V.Condition_Status_Effective_On, 108),
			V.Current_Vehicle_Status,
			CONVERT(VarChar, V.Drop_ShipDate, 108),
			CONVERT(VarChar, V.Ownership_Date, 108),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 108),
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 108),
			V.MVA_Number,
			V.Risk_Type,
			V.Dealer_ID,
			V.Year_Of_Agreement, 
			V.Purchase_Cycle, 
			V.Purchase_Price, 
			V.PDI_Amount, 
			CONVERT(VarChar(1), V.PDI_Included_In_Price), 
			V.PDI_Performed_By, 
			V.Volume_Incentive, 
			V.Incentive_Received_From, 
			V.Rebate_Amount, 
			V.Rebate_From, 
			V.Planned_Days_In_Service, 
			V.Vehicle_Cost, 
			CONVERT(VarChar(1),V.Own_Use) Own_Use, 
			V.Purchase_GST, 
			V.Purchase_PST, 
			(Case When V.Payment_Type is not null Then Payment_Type
			         Else 'B'
			End) Payment_Type, 
--			CONVERT(VarChar,
--									(Case when V.Depreciation_Start_Date is not null then V.Depreciation_Start_Date
--												Else  dbo.VehicleISD(V.Unit_Number)				
--									End),
--								111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_Start_Date, 111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_End_Date, 111) Depreciation_End_Date,
--			CONVERT
--			(
--					VarChar,
--					(Case WHEN V.Depreciation_End_Date is not null then V.Depreciation_End_Date
--								ELSE
--										(Case When V.Program = 1 then VH.Effective_On
--											      ELSE V.OSD
--										End) 
--						END),
--					111
--			)	 Depreciation_End_Date,

			V.Depreciation_Rate_Amount, 
			V.Depreciation_Rate_Percentage, 
			V.Loan_Repaid_Max_KM,
			V.Loan_Repaid_Max_Ownership,
			V.Finance_By,
			V.Trans_Month, 
			 V.Loan_Amount, 
			CONVERT(VarChar(1), V.Loan_Tax_Included) Loan_Tax_Included, 
			V.Loan_Principal_Rate_ID,
			V.Override_Principal_Rate,
			CONVERT(VarChar, V.Financing_Start_Date,111) Financing_Start_Date, 
			CONVERT(VarChar, V.Financing_End_Date,111) Financing_End_Date, 
			--V.Term, 
			V.Payout_Amount, 
			CONVERT(VarChar, V.Payount_Date,111) Payount_Date, 	
			V.Loan_Setup_Fee,
			
--			(Case When V.Cap_Cost is not null then V.Cap_Cost
--					  When dbo.FA_Repurchase_Eligibility.Capitalized is not null  And V.Program = 1 then dbo.FA_Repurchase_Eligibility.Capitalized
--					  Else V.Vehicle_Cost
--			End) Cap_Cost, 
--			V.Deduction, 
--			V.Damage_Amount, 
--			-- default KM Reading
--			(Case When V.KM_Reading is Not Null  Then V.KM_Reading 
--					Else V.Current_KM
--			End) KM_Reading,
--			--Default KM Charge 
--			(Case When KM_Charge is Not Null Then KM_Charge
--					 Else
--							(Case When V.KM_Reading is Not Null Then [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.KM_Reading)
--									 Else [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.Current_KM)
--							End)
--			End) KM_Charge, 
--			 --[dbo].[GetKMCharge] ('2010', '1', 'Ford','1','42000')
--	
--			(Case
--					When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
--					Else ''
--			End)
--			as ManufacturerISD,
--
--			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number)) GISISD,
--			CONVERT(VarChar(11), V.ISD, 13) ISD,
--			(Case 
--							When V.OSD is Not Null then	CONVERT(VarChar(11), V.OSD, 13)
--							Else CONVERT(VarChar(11),VH.Effective_On ,13) 
--			 End)	 OSD,	


			V.Cap_Cost,
			V.Deduction, 
			V.Damage_Amount, 			
			V.KM_Reading, 			
			KM_Charge,			
            (Case
						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
						Else ''
			End) as ManufacturerISD,
			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,

			CONVERT(VarChar(11), V.ISD, 13) ISD,
			V.OSD,
	
--			(
--			Case When V.Sales_Processed =1  or V.Idle_Days is Not Null  Then V.Idle_Days 
--					Else	
--                           (Case When (VFH.HeldDate is Not Null ) And (V.OSD>VFH.HeldDate Or V.OSD is Null) And  RTND.Allow_Non_Dep=1 Then											
--									DateDiff(d, VFH.HeldDate, 
--											(Case When V.OSD is not Null and V.OSD<getdate() then  V.OSD
--													  Else Getdate()
--											 End)
--									 )	
--							Else  NULL
--							End)
--			 End)
--            As IdleDays,
			V.Idle_Days,
			V.Depreciation_Periods, 
			V.Selling_Monthly_AMO, 
--			(Case When V.Depreciation_Type is not null Then Depreciation_Type
--			         Else 'D'
--			End) Depreciation_Type, 
			V.Depreciation_Type,
			V.Sales_Acc_Dep, 
			V.Selling_Price, 
			V.Sales_GST, 
			V.Sales_PST, 
			V.Sell_To, 
			--V.Sales_Processed, 
			CONVERT(VarChar(11), V.Sales_Processed_date,111) Sales_Processed_date,
			Convert(Varchar,VH.Effective_On,111) AS Disposal_Date,
			V.Lessee_ID,
			V.Initial_Cost,
			V.Interest_Rate,
			V.Principle_Rate,
			Convert(Varchar,V.Lease_Start_Date,111) Lease_Start_Date,
			Convert(Varchar,V.Lease_End_Date,111) Lease_End_Date,
			CONVERT(VarChar(1),V.Private_Lease), --Private_lease
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate())-dbo.ZeroIfNull(V.Price_Difference) As NBV,
			(Case When VehLoanBlance.LoanBlance Is Not Null Then VehLoanBlance.LoanBlance 
			     Else V.Loan_Amount
			 End) -dbo.ZeroIfNull(V.Payout_Amount) LoanBlance,
			V.Declaration_Amount,
			V.Amount_Paid,
			V.Payment_Cheque_No,
			Convert(Varchar,V.Payment_Date,111) Payment_Date,
			CONVERT(VarChar(1),V.Sales_Processed),
			VMY.PST_Rate,
			PFDDays,
			VTH.HeldDays,
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate()) AS BookValue,
			V.Price_Difference,
			CONVERT(VarChar, VFH.HeldDate,111) HeldSince,
			CONVERT(VarChar(1), RTND.Allow_Non_Dep) As NonDep,
			CONVERT(VarChar, V.Purchase_Process_Date,111) Purchase_Process_Date,
			V.Mark_Down,
			V.Excise_Tax,
			Battery_Levy,
			V.Market_Price,
			V.Sold_date,
			V.Ownership,
			V.Turn_Back_Message,
			V.FA_Remarks,
			V.Overrid_PM_Schedule_Id,
			V.TB_Expense
 

FROM         dbo.Vehicle V 
INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
INNER JOIN   dbo.Vehicle_Class VC 
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code 
LEFT OUTER JOIN
                      dbo.FA_Risk_Type_Non_Dep AS RTND ON V.Risk_Type = RTND.Risk_Type
LEFT OUTER JOIN     dbo.Lookup_Table L 
		ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		= @CategoryManufaturer
LEFT OUTER JOIN    dbo.Lookup_Table L_VehStatus 
		ON V.Current_Vehicle_Status = L_VehStatus.Code AND	L_VehStatus.Category	= @CategoryVehicleStatus
LEFT OUTER JOIN      dbo.Lookup_Table L_RentalStatus 
		ON V.Current_Rental_Status = L_RentalStatus.Code  AND	L_RentalStatus.Category	= @CategoryRentalStatus
LEFT OUTER JOIN    dbo.Lookup_Table L_ConditionStatus 
		ON V.Current_Condition_Status = L_ConditionStatus.Code AND	L_ConditionStatus.Category	= @CategoryConditionStatus
--LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON V.Unit_Number = FAISD.Unit_Number
LEFT OUTER JOIN
             (Select Unit_number, Vehicle_Status, max(Effective_On)  Effective_On from Vehicle_History 
			 Group by Unit_number, Vehicle_Status)  VH 
			 ON V.Unit_Number = VH.Unit_Number AND (V.Program = 0 AND VH.Vehicle_Status = 'f' OR
                      V.Program = 1 AND VH.Vehicle_Status = 'g')
LEFT OUTER JOIN Vehicle_Total_Held_Days_vw  VTH 
					ON V.Unit_number=VTH.Unit_number
LEFT OUTER JOIN Vehicle_Total_PFD_Days_vw  VTP 
					ON V.Unit_number=VTP.Unit_number
LEFT OUTER JOIN 	Vehicle_First_Held_vw VFH
					ON V.Unit_number=VFH.Unit_number
LEFT OUTER JOIN
                      dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
--LEFT OUTER JOIN
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number
--LEFT OUTER JOIN
--
--	(
--						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
--											dbo.FA_Vehicle_Amortization.AMO_Amount, 											
--											dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
--											dbo.FA_Vehicle_Amortization.AMO_Month
--						FROM         dbo.FA_Vehicle_Amortization
--						Inner Join 
--						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
--													Max(AMO_Month) as AMOMonth
--								FROM         dbo.FA_Vehicle_Amortization							
--								Group By Unit_Number								
--						) LastMonth
--						On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
--				 ) LastAMO
--    	On V.Unit_Number =LastAMO.Unit_Number
--
--
--LEFT OUTER JOIN
--
--		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
--			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
--					Else Convert (Datetime,  '2078-12-31')
--			End) Depreciation_End_Date,
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
--			from dbo.FA_Vehicle_Depreciation_History  
--					Inner Join 
--					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
--						FROM         FA_Vehicle_Depreciation_History						
--							Group By Unit_Number									
--				) LastDep
--				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
--			
--			) LastVDH
--
--		 On  V.Unit_Number =LastVDH.Unit_Number


LEFT OUTER JOIN 
		(
		Select LoanAMO.Unit_Number, LoanAMO.Balance LoanBlance
		from  FA_Loan_Amortization LoanAMO
		Inner Join
		(select Unit_Number, max(AMO_Month) AMO_Month, max(Finance_Start_Date)as Finance_Start_Date from FA_Loan_Amortization
		Group by Unit_Number) LastLoanAMO
		On LoanAMO.Unit_Number=LastLoanAMO.Unit_Number and LoanAMO.Finance_Start_Date=LastLoanAMO.Finance_Start_Date 
			 And LoanAMO.AMO_Month=LastLoanAMO.AMO_Month 
		) VehLoanBlance
		On V.Unit_Number=VehLoanBlance.Unit_Number


	WHERE	--V.Unit_Number 		= CONVERT(Int, @UnitNumber)		
			((V.Unit_Number = CONVERT(Int, @UnitNumber) )--AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
							)
		AND	Deleted			 = 0


/*		FROM	Vehicle V,
			Vehicle_Class VC,
			Vehicle_Model_Year VMY,
			FA_Inservcie_Date_vw FAISD,
			Lookup_Table L,
			Lookup_Table L_VehStatus,
			Lookup_Table L_RentalStatus,
			Lookup_Table L_ConditionStatus
		WHERE	V.Unit_Number 		= CONVERT(Int, @UnitNumber)
		AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
		AND	VMY.Manufacturer_ID 	*= CONVERT(SmallInt, L.Code)
		AND	L.Category		= @CategoryManufaturer
		AND	V.Vehicle_Class_Code	= VC.Vehicle_Class_Code
		
		AND	L_VehStatus.Category	 = @CategoryVehicleStatus
		AND	V.Current_Vehicle_Status *= L_VehStatus.Code
		AND	L_RentalStatus.Category	 = @CategoryRentalStatus
		AND	V.Current_Rental_Status  *= L_RentalStatus.Code
		AND	L_ConditionStatus.Category	= @CategoryConditionStatus
		AND	V.Current_Condition_Status 	*= L_ConditionStatus.Code
		AND    V.Unit_Number *= FAISD.Unit_Number
		AND	Deleted			 = 0
*/
	ELSE
		SELECT	V.Unit_Number,
			V.Foreign_Vehicle_Unit_Number,
			V.Serial_Number,
			V.Key_Ignition_Code,
			V.Key_Trunk_Code,
			V.Exterior_Colour,
			V.Interior_Colour,
			L.Value,
			VC.Vehicle_Type_ID,
			V.Vehicle_Class_Code,
			VMY.Model_Name,
			VMY.Model_Year,
			CONVERT(VarChar, V.Drop_ShipDate, 111),
			CONVERT(VarChar, V.Ownership_Date, 111),
			V.Owning_Company_ID,
			CONVERT(VarChar(1), V.Program),
			V.Turn_Back_Deadline,
			V.Maximum_KM,
			V.Do_Not_Rent_Past_KM,
			V.Minimum_Days,
			V.Maximum_Days,
			V.Do_Not_Rent_Past_Days,
			V.Reconditioning_Days_Allowed,
			V.Current_Location_ID,
			V.Current_KM,
			V.Total_Non_Revenue_KM,
			V.Next_Scheduled_Maintenance,
			CONVERT(VarChar(1), V.Smoking_Flag),
			V.Maximum_Rental_Period,
			L_VehStatus.Value,
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 111),
			V.Current_Rental_Status, --L_RentalStatus.Value,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 111),
			L_ConditionStatus.Value,
			CONVERT(VarChar, V.Condition_Status_Effective_On, 111),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 111),
			V.Current_Licence_Plate,
			V.Current_Licencing_Prov_State,
			CONVERT(VarChar(1), V.Foreign_Licence_Plate_Flag),
			V.Comments,
			V.Last_Update_By,
			CONVERT(VarChar, V.Last_Update_On, 111) Last_Update_On,
			CONVERT(VarChar, V.Rental_Status_Effective_On, 108),
			CONVERT(VarChar, V.Condition_Status_Effective_On, 108),
			V.Current_Vehicle_Status,
			CONVERT(VarChar, V.Drop_ShipDate, 108),
			CONVERT(VarChar, V.Ownership_Date, 108),
			CONVERT(VarChar, V.Licence_Plate_Attached_On, 108),
			CONVERT(VarChar, V.Vehicle_Status_Effective_On, 108),
			V.MVA_Number,
			V.Risk_Type,
			V.Dealer_ID,
			V.Year_Of_Agreement, 
			V.Purchase_Cycle, 
			V.Purchase_Price, 
			V.PDI_Amount, 
			CONVERT(VarChar(1), V.PDI_Included_In_Price), 
			V.PDI_Performed_By, 
			V.Volume_Incentive, 
			V.Incentive_Received_From, 
			V.Rebate_Amount, 
			V.Rebate_From, 
			V.Planned_Days_In_Service, 
			V.Vehicle_Cost, 
			CONVERT(VarChar(1),V.Own_Use) Own_Use, 
			V.Purchase_GST, 
			V.Purchase_PST, 
			(Case When V.Payment_Type is not null Then Payment_Type
			         Else 'B'
			End) Payment_Type, 
--			CONVERT(VarChar,
--									(Case when V.Depreciation_Start_Date is not null then V.Depreciation_Start_Date
--												Else  dbo.VehicleISD(V.Unit_Number)				
--									End),
--								111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_Start_Date, 111) Depreciation_Start_Date, 
		   CONVERT(VarChar, V.Depreciation_End_Date, 111) Depreciation_End_Date,
--			CONVERT
--			(
--					VarChar,
--					(Case WHEN V.Depreciation_End_Date is not null then V.Depreciation_End_Date
--								ELSE
--										(Case When V.Program = 1 then VH.Effective_On
--											      ELSE V.OSD
--										End) 
--						END),
--					111
--			)	 Depreciation_End_Date,

			V.Depreciation_Rate_Amount, 
			V.Depreciation_Rate_Percentage, 
			V.Loan_Repaid_Max_KM,
			V.Loan_Repaid_Max_Ownership,
			V.Finance_By,
			V.Trans_Month, 
			 V.Loan_Amount, 
			CONVERT(VarChar(1), V.Loan_Tax_Included) Loan_Tax_Included, 
			V.Loan_Principal_Rate_ID,
			V.Override_Principal_Rate,
			CONVERT(VarChar, V.Financing_Start_Date,111) Financing_Start_Date, 
			CONVERT(VarChar, V.Financing_End_Date,111) Financing_End_Date, 
			--V.Term, 
			V.Payout_Amount, 
			CONVERT(VarChar, V.Payount_Date,111) Payount_Date, 	
			V.Loan_Setup_Fee,
			
--			(Case When V.Cap_Cost is not null then V.Cap_Cost
--					  When dbo.FA_Repurchase_Eligibility.Capitalized is not null  And V.Program = 1 then dbo.FA_Repurchase_Eligibility.Capitalized
--					  Else V.Vehicle_Cost
--			End) Cap_Cost, 
--			V.Deduction, 
--			V.Damage_Amount, 
--			-- default KM Reading
--			(Case When V.KM_Reading is Not Null  Then V.KM_Reading 
--					Else V.Current_KM
--			End) KM_Reading,
--			--Default KM Charge 
--			(Case When KM_Charge is Not Null Then KM_Charge
--					 Else
--							(Case When V.KM_Reading is Not Null Then [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.KM_Reading)
--									 Else [dbo].[GetKMCharge] (V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.Current_KM)
--							End)
--			End) KM_Charge, 
--			 --[dbo].[GetKMCharge] ('2010', '1', 'Ford','1','42000')
--	
--			(Case
--					When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
--					Else ''
--			End)
--			as ManufacturerISD,
--
--			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number)) GISISD,
--			CONVERT(VarChar(11), V.ISD, 13) ISD,
--			(Case 
--							When V.OSD is Not Null then	CONVERT(VarChar(11), V.OSD, 13)
--							Else CONVERT(VarChar(11),VH.Effective_On ,13) 
--			 End)	 OSD,	


			V.Cap_Cost,
			V.Deduction, 
			V.Damage_Amount, 			
			V.KM_Reading, 			
			KM_Charge,			
            (Case
						When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
						Else ''
			End) as ManufacturerISD,
			CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,

			CONVERT(VarChar(11), V.ISD, 13) ISD,
			V.OSD,
	
--			(
--			Case When V.Sales_Processed =1  or V.Idle_Days is Not Null  Then V.Idle_Days 
--					Else	
--                           (Case When (VFH.HeldDate is Not Null ) And (V.OSD>VFH.HeldDate Or V.OSD is Null) And  RTND.Allow_Non_Dep=1 Then											
--									DateDiff(d, VFH.HeldDate, 
--											(Case When V.OSD is not Null and V.OSD<getdate() then  V.OSD
--													  Else Getdate()
--											 End)
--									 )	
--							Else  NULL
--							End)
--			 End)
--            As IdleDays,
			V.Idle_Days,
			V.Depreciation_Periods, 
			V.Selling_Monthly_AMO, 
--			(Case When V.Depreciation_Type is not null Then Depreciation_Type
--			         Else 'D'
--			End) Depreciation_Type, 
			V.Depreciation_Type,
			V.Sales_Acc_Dep, 
			V.Selling_Price, 
			V.Sales_GST, 
			V.Sales_PST, 
			V.Sell_To, 
			--V.Sales_Processed, 
			CONVERT(VarChar(11), V.Sales_Processed_date,111) Sales_Processed_date,
			Convert(Varchar,VH.Effective_On,111) AS Disposal_Date,
			V.Lessee_ID,
			V.Initial_Cost,
			V.Interest_Rate,
			V.Principle_Rate,
			Convert(Varchar,V.Lease_Start_Date,111) Lease_Start_Date,
			Convert(Varchar,V.Lease_End_Date,111) Lease_End_Date,
			CONVERT(VarChar(1),V.Private_Lease), --Private_lease
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate())-dbo.ZeroIfNull(V.Price_Difference) As NBV,
			(Case When VehLoanBlance.LoanBlance Is Not Null Then VehLoanBlance.LoanBlance 
			     Else V.Loan_Amount
			 End) -dbo.ZeroIfNull(V.Payout_Amount) LoanBlance,
			V.Declaration_Amount,
			V.Amount_Paid,
			V.Payment_Cheque_No,
			Convert(Varchar,V.Payment_Date,111) Payment_Date,
			CONVERT(VarChar(1),V.Sales_Processed),
			VMY.PST_Rate,
			PFDDays,
			VTH.HeldDays,
			dbo.VehCurrentBookValue(V.Unit_Number, Getdate()) AS BookValue,
			V.Price_Difference,
			CONVERT(VarChar, VFH.HeldDate,111) HeldSince,
			CONVERT(VarChar(1), RTND.Allow_Non_Dep) As NonDep,
			CONVERT(VarChar, V.Purchase_Process_Date,111) Purchase_Process_Date,
			V.Mark_Down,
			V.Excise_Tax,
			Battery_Levy,
			V.Market_Price,
			V.Sold_date,
			V.Ownership,
			V.Turn_Back_Message,
			V.FA_Remarks,
			V.Overrid_PM_Schedule_Id,
			V.TB_Expense
 

FROM         dbo.Vehicle V 
INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
INNER JOIN   dbo.Vehicle_Class VC 
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code 
LEFT OUTER JOIN
                      dbo.FA_Risk_Type_Non_Dep AS RTND ON V.Risk_Type = RTND.Risk_Type
LEFT OUTER JOIN     dbo.Lookup_Table L 
		ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		= @CategoryManufaturer
LEFT OUTER JOIN    dbo.Lookup_Table L_VehStatus 
		ON V.Current_Vehicle_Status = L_VehStatus.Code AND	L_VehStatus.Category	= @CategoryVehicleStatus
LEFT OUTER JOIN      dbo.Lookup_Table L_RentalStatus 
		ON V.Current_Rental_Status = L_RentalStatus.Code  AND	L_RentalStatus.Category	= @CategoryRentalStatus
LEFT OUTER JOIN    dbo.Lookup_Table L_ConditionStatus 
		ON V.Current_Condition_Status = L_ConditionStatus.Code AND	L_ConditionStatus.Category	= @CategoryConditionStatus
--LEFT OUTER JOIN   dbo.FA_Inservcie_Date_vw FAISD 
--		ON V.Unit_Number = FAISD.Unit_Number
LEFT OUTER JOIN
             (Select Unit_number, Vehicle_Status, max(Effective_On)  Effective_On from Vehicle_History 
			 Group by Unit_number, Vehicle_Status)  VH 
			 ON V.Unit_Number = VH.Unit_Number AND (V.Program = 0 AND VH.Vehicle_Status = 'f' OR
                      V.Program = 1 AND VH.Vehicle_Status = 'g')
LEFT OUTER JOIN Vehicle_Total_Held_Days_vw  VTH 
					ON V.Unit_number=VTH.Unit_number
LEFT OUTER JOIN Vehicle_Total_PFD_Days_vw  VTP 
					ON V.Unit_number=VTP.Unit_number
LEFT OUTER JOIN 	Vehicle_First_Held_vw VFH
					ON V.Unit_number=VFH.Unit_number
LEFT OUTER JOIN
                      dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
--LEFT OUTER JOIN
--		(
--		Select VehAMO.Unit_Number, VehAMO.Balance BookValue
--		from  FA_Vehicle_Amortization VehAMO
--		Inner Join
--		(select Unit_Number, max(AMO_Month)as AMO_Month from FA_Vehicle_Amortization
--		Group by Unit_Number) LastVehAMO
--		On VehAMO.Unit_Number=LastVehAMO.Unit_Number and VehAMO.AMO_Month=LastVehAMO.AMO_Month
--		) VehBookValue
--		On V.Unit_Number=VehBookValue.Unit_Number
--LEFT OUTER JOIN
--
--	(
--						SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 
--											dbo.FA_Vehicle_Amortization.AMO_Amount, 											
--											dbo.FA_Vehicle_Amortization.Balance,  -- Book Value
--											dbo.FA_Vehicle_Amortization.AMO_Month
--						FROM         dbo.FA_Vehicle_Amortization
--						Inner Join 
--						(		SELECT      dbo.FA_Vehicle_Amortization.Unit_Number, 												
--													Max(AMO_Month) as AMOMonth
--								FROM         dbo.FA_Vehicle_Amortization							
--								Group By Unit_Number								
--						) LastMonth
--						On dbo.FA_Vehicle_Amortization.Unit_Number=LastMonth.Unit_Number and dbo.FA_Vehicle_Amortization.AMO_Month=LastMonth.AMOMonth
--				 ) LastAMO
--    	On V.Unit_Number =LastAMO.Unit_Number
--
--
--LEFT OUTER JOIN
--
--		 ( Select dbo.FA_Vehicle_Depreciation_History.Unit_Number,  
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date, 
--			(Case When dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date is not Null then dbo.FA_Vehicle_Depreciation_History.Depreciation_End_Date
--					Else Convert (Datetime,  '2078-12-31')
--			End) Depreciation_End_Date,
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Amount, 
--			dbo.FA_Vehicle_Depreciation_History.Depreciation_Rate_Percentage
--			from dbo.FA_Vehicle_Depreciation_History  
--					Inner Join 
--					(	SELECT     Unit_Number, Max(Depreciation_Start_Date) As Last_Start_Date
--						FROM         FA_Vehicle_Depreciation_History						
--							Group By Unit_Number									
--				) LastDep
--				On dbo.FA_Vehicle_Depreciation_History.Unit_Number=LastDep.Unit_Number and dbo.FA_Vehicle_Depreciation_History.Depreciation_Start_Date=LastDep.Last_Start_Date
--			
--			) LastVDH
--
--		 On  V.Unit_Number =LastVDH.Unit_Number


LEFT OUTER JOIN 
		(
		Select LoanAMO.Unit_Number, LoanAMO.Balance LoanBlance
		from  FA_Loan_Amortization LoanAMO
		Inner Join
		(select Unit_Number, max(AMO_Month) AMO_Month, max(Finance_Start_Date)as Finance_Start_Date from FA_Loan_Amortization
		Group by Unit_Number) LastLoanAMO
		On LoanAMO.Unit_Number=LastLoanAMO.Unit_Number and LoanAMO.Finance_Start_Date=LastLoanAMO.Finance_Start_Date 
			 And LoanAMO.AMO_Month=LastLoanAMO.AMO_Month 
		) VehLoanBlance
		On V.Unit_Number=VehLoanBlance.Unit_Number


	WHERE	--V.Unit_Number 		= CONVERT(Int, @UnitNumber)		
			((V.Unit_Number = CONVERT(Int, @UnitNumber) AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
					OR (Foreign_Vehicle_Unit_Number = @UnitNumber)		)
		AND	Deleted			 = 0


/*		FROM	Vehicle V,
			Vehicle_Class VC,
			Vehicle_Model_Year VMY,
			FA_Inservcie_Date_vw FAISD,
			Lookup_Table L,
			Lookup_Table L_VehStatus,
			Lookup_Table L_RentalStatus,
			Lookup_Table L_ConditionStatus
		WHERE	V.Unit_Number 		= CONVERT(Int, @UnitNumber)
		AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
		AND	VMY.Manufacturer_ID 	*= CONVERT(SmallInt, L.Code)
		AND	L.Category		= @CategoryManufaturer
		AND	V.Vehicle_Class_Code	= VC.Vehicle_Class_Code
		
		AND	L_VehStatus.Category	 = @CategoryVehicleStatus
		AND	V.Current_Vehicle_Status *= L_VehStatus.Code
		AND	L_RentalStatus.Category	 = @CategoryRentalStatus
		AND	V.Current_Rental_Status  *= L_RentalStatus.Code
		AND	L_ConditionStatus.Category	= @CategoryConditionStatus
		AND	V.Current_Condition_Status 	*= L_ConditionStatus.Code
		AND    V.Unit_Number *= FAISD.Unit_Number
		AND	Deleted			 = 0
*/

RETURN 1


--
--
--select *
--from vehicle
--where foreign_vehicle_unit_number='6066'
--
--exec GetVehicle '6066', '', '', 'Manufacturer', 'Y', 'Y', 'Vehicle Status', 'Vehicle Rental Status', 'Vehicle Condition Status'
--
--select * from Vehicle  V
--
--WHERE	--V.Unit_Number 		= CONVERT(Int, @UnitNumber)		
--			(V.Unit_Number = CONVERT(Int, '141615') AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
--							OR	(Foreign_Vehicle_Unit_Number = @UnitNumber)
--		AND	Deleted			 = 0






----UpdVehicle


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
