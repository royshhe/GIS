USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdVehicle]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.UpdVehicle    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehicle    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehicle    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdVehicle    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
CPY	Jan 5 2000  Added VehRentalStatus param; update vehicle rental status of the vehicle
*/
CREATE PROCEDURE [dbo].[UpdVehicle]
	@UnitNumber			VarChar(10),
	@ForeignVehicleUnitNumber	VarChar(20),
	@SerialNumber			VarChar(30),
	@MVANumber			VarChar(20),
	@KeyIgnitionCode		VarChar(20),
	@KeyTrunkCode			VarChar(20),
	@ExteriorColour			VarChar(15),
	@InteriorColour			VarChar(15),
	@VehicleClassCode		VarChar(1),
	@VehicleModelId			VarChar(10),
	@OwnershipDate			VarChar(24),
	@OwningCompanyID		VarChar(10),
	@Program			VarChar(1),
	@TurnBackDeadline		VarChar(24),
	@MaximumKM			VarChar(10),
	@DoNotRentPastKM		VarChar(10),
	@MinimumDays			VarChar(10),
	@MaximumDays			VarChar(10),
	@DoNotRentPastDays		VarChar(10),
	@ReconditioningDaysAllowed	VarChar(10),
	@CurrentLocationID		VarChar(10),
	@CurrentKM			VarChar(10),
	@TotalNonRevenueKM		VarChar(10),
	@NextScheduledMaintenance	VarChar(10),
	@SmokingFlag  			VarChar(1),
	@MaximumRentalPeriod		VarChar(10),
	@LicencePlateAttachedOn		VarChar(24),
	@CurrentLicencePlate		VarChar(10),
	@CurrentLicencingProvState	VarChar(20),
	@ForeignLicencePlate_Flag	VarChar(1),
	@Comments			VarChar(255),
	@LastUpdateBy			VarChar(20),
	@VehicleRentalStatus		Varchar(1),
    @RiskType Varchar(1),
	@YearOfAgreement VarChar(20)  =  '',
	@PurchaseCycle VarChar(20)  =  '',
	@PurchasePrice VarChar(20)  =  '',
	@PDIAmount VarChar(20)  =  '',
	@PDIIncludedInPrice VarChar(1)  =  '',
	@PDIPerformedBy VarChar(20) =  '',
	@VolumeIncentive VarChar(20)  =  '',
	@IncentiveReceivedFrom VarChar(20)  =  '',
	@RebateAmount VarChar(20)  =  '',
	@RebateFrom VarChar(20)  =  '',
	@PlannedDayssInService VarChar(20)  =  '',
	@VehicleCost VarChar(20)  =  '',
	@MarkDown VarChar(20)  =  '',
    @ExciseTax VarChar(20)  =  '',
	@BatteryLevy VarChar(20)  =  '',
	@OwnUse VarChar(1)  =  '',
	@PurchaseGST VarChar(20) =  '',
	@PurchasePST Varchar(20)  =  '',
	@PaymentType Varchar(20)  =  '',

	@DepreciationStartDate Varchar(24)  =  '',
	@DepreciationEndDate Varchar(24)  =  '',
	@DepreciationRateAmount Varchar(20)  =  '',
	@DepreciationRatePercentage Varchar(20)  =  '',	

	@LoanRepaidMaxKm varchar(20) = '',
    @LoanRepaidMaxOwnership varchar(20) = '',
	@FinanceBy Varchar(20)  =  '',
	@TransMonth Varchar(20)  =  '',
	@LoanAmount Varchar(20)  =  '',
	@LoanTaxIncluded Varchar(1)  =  '',
	@PrincipalRateID varchar(20) ='',
	@OverridePrincipalRate varchar(20) ='',
	@FinancingStartDate Varchar(24)  =  '',
	@FinancingEndDate Varchar(24)  =  '',
	--@Term Varchar(20)  =  '',
	@PayoutAmount Varchar(20)  =  '',
	@PayountDate Varchar(24)  =  '',
	@SetupFee varchar(20) ='',

	@CapCost Varchar(20)  =  '',
	@Deduction Varchar(20)  =  '',
	@DamageAmount Varchar(20)  =  '',
	@KMReading Varchar(20)  =  '',
	@KMCharge Varchar(20)  =  '',
	@ISD Varchar(20)  =  '',
	@OSD Varchar(20)  =  '',
	@IdleDays varchar(20)='',
	@DepreciationPeriods Varchar(20)  =  '',
	@SellingMonthlyAMO Varchar(20)  =  '',
	@DepreciationType char(10)='',
	@SalesAccDep Varchar(20)  =  '',
	@SellingPrice Varchar(20)  =  '',
	@SalesGST Varchar(20)  =  '',
	@SalesPST Varchar(20)  =  '',
	@SellTo Varchar(20)  =  '',
	@SalesProcesseddate Varchar(24) =  '',
	
	@LesseeID Varchar(20) ='',
	@InitialCost Varchar(20)='',
	@InterestRate Varchar(20)='',
	@PrincipalRate Varchar(20)='',
	@LeaseStartDate varchar(20)='',
	@LeaseEndDate Varchar(20)='',
	@PrivateLease Varchar(1)='',
	@PriceProtection Varchar(20)='',
    @DeclarationAmount Varchar(20)='',
    @AmountPaid Varchar(20)= '',
    @PaymentChequeNo Varchar(30)= '',
    @PaymentDate Varchar(24)= '',

	@SalesProcessed Varchar(1)  =  '',
	
	@MarketPrice Varchar(20)='',
	@SoldDate Varchar(24)= '',
	@Ownership Varchar(25)='',
	@TurnBackMessage Varchar(255)='',
	@FARemarks Varchar(75)='',
	@PMScheduleID Varchar(20)='',
	@TBExpense Varchar(20)=''

AS
	Declare @nUnitNumber Int
    Declare @OldRiskType Varchar(1)
    Declare @OldVehicleCost Decimal(9,2)



	Select 	@nUnitNumber = CONVERT(Int, NULLIF(@UnitNumber, '')),
		@VehicleModelId = NULLIF(@VehicleModelId,''),
		@OwnershipDate = NULLIF(@OwnershipDate,''),
		@OwningCompanyID = NULLIF(@OwningCompanyID,''),
		@Program = NULLIF(@Program,''),
		@TurnBackDeadline = NULLIF(@TurnBackDeadline,''),
		@MaximumKM = NULLIF(@MaximumKM,''),
		@DoNotRentPastKM = NULLIF(@DoNotRentPastKM,''),
		@MinimumDays = NULLIF(@MinimumDays,''),
		@MaximumDays = NULLIF(@MaximumDays,''),
		@DoNotRentPastDays = NULLIF(@DoNotRentPastDays,''),
		@ReconditioningDaysAllowed = NULLIF(@ReconditioningDaysAllowed,''),
		@CurrentLocationID = NULLIF(@CurrentLocationID,''),
		@CurrentKM = NULLIF(@CurrentKM,''),
		@TotalNonRevenueKM = NULLIF(@TotalNonRevenueKM,''),
		@NextScheduledMaintenance = NULLIF(@NextScheduledMaintenance,''),
		@SmokingFlag = NULLIF(@SmokingFlag,''),
		@MaximumRentalPeriod = NULLIF(@MaximumRentalPeriod,''),
		@LicencePlateAttachedOn = NULLIF(@LicencePlateAttachedOn,''),
		@ForeignLicencePlate_Flag = NULLIF(@ForeignLicencePlate_Flag,''),
		@ForeignVehicleUnitNumber = NULLIF(@ForeignVehicleUnitNumber,''),
		@MVANumber= NULLIF(@MVANumber,''),
		@VehicleRentalStatus = NULLIF(@VehicleRentalStatus,''),
        @RiskType = NULLIF(@RiskType,''),

		@YearOfAgreement = NULLIF(@YearOfAgreement, ''),
		@PurchaseCycle = NULLIF(@PurchaseCycle, ''),
		@PurchasePrice = NULLIF(@PurchasePrice, ''),
		@PDIAmount = NULLIF(@PDIAmount, ''),
		@PDIIncludedInPrice = NULLIF(@PDIIncludedInPrice, ''),
		@PDIPerformedBy = NULLIF(@PDIPerformedBy, ''),
		@VolumeIncentive = NULLIF(@VolumeIncentive, ''),
		@IncentiveReceivedFrom = NULLIF(@IncentiveReceivedFrom, ''),
		@RebateAmount = NULLIF(@RebateAmount, ''),
		@RebateFrom = NULLIF(@RebateFrom, ''),
		@PlannedDayssInService = NULLIF(@PlannedDayssInService, ''),
		@VehicleCost = NULLIF(@VehicleCost, ''),
        @MarkDown = NULLIF(@MarkDown, ''),
        @ExciseTax = NULLIF(@ExciseTax, ''),
	    @BatteryLevy = NULLIF(@BatteryLevy, ''),
		@OwnUse = NULLIF(@OwnUse, ''),
		@PurchaseGST = NULLIF(@PurchaseGST, ''),
		@PurchasePST = NULLIF(@PurchasePST, ''),
		@PaymentType = NULLIF(@PaymentType, ''),

		@DepreciationRateAmount = NULLIF(@DepreciationRateAmount, ''),
		@DepreciationRatePercentage = NULLIF(@DepreciationRatePercentage, ''),
		@DepreciationStartDate = NULLIF(@DepreciationStartDate, ''),
		@DepreciationEndDate = NULLIF(@DepreciationEndDate, ''),

		@LoanRepaidMaxKm = NULLIF(@LoanRepaidMaxKm, ''),
		@LoanRepaidMaxOwnership = NULLIF(@LoanRepaidMaxOwnership, ''),
		@FinanceBy = NULLIF(@FinanceBy, ''),
		@TransMonth = NULLIF(@TransMonth, ''),
		@LoanAmount = NULLIF(@LoanAmount, ''),
		@LoanTaxIncluded = NULLIF(@LoanTaxIncluded, ''),
		@PrincipalRateID = NULLIF(@PrincipalRateID, ''),
		@OverridePrincipalRate=NULLIF(@OverridePrincipalRate, ''),
		@FinancingStartDate = NULLIF(@FinancingStartDate, ''),
		@FinancingEndDate = NULLIF(@FinancingEndDate, ''),
		--@Term = NULLIF(@Term, ''),
		@PayoutAmount = NULLIF(@PayoutAmount, ''),
		@PayountDate = NULLIF(@PayountDate, ''),
		@SetupFee = NULLIF(@SetupFee, ''),

		@CapCost = NULLIF(@CapCost, ''),
		@Deduction = NULLIF(@Deduction, ''),
		@DamageAmount = NULLIF(@DamageAmount, ''),
		@KMReading = NULLIF(@KMReading, ''),
		@KMCharge = NULLIF(@KMCharge, ''),
		@ISD = NULLIF(@ISD, ''),
		@OSD = NULLIF(@OSD, ''),
		@IdleDays=NULLIF(@IdleDays,''),
		@DepreciationPeriods = NULLIF(@DepreciationPeriods, ''),
		@SellingMonthlyAMO = NULLIF(@SellingMonthlyAMO, ''),
		@DepreciationType= NULLIF(@DepreciationType, ''),
		@SalesAccDep = NULLIF(@SalesAccDep, ''),
		@SellingPrice = NULLIF(@SellingPrice, ''),
		@SalesGST = NULLIF(@SalesGST, ''),
		@SalesPST = NULLIF(@SalesPST, ''),
		@SellTo = NULLIF(@SellTo, ''),
		@SalesProcesseddate = NULLIF(@SalesProcesseddate, ''),

		@LesseeID = NULLIF(@LesseeID, ''),
		@InitialCost = NULLIF(@InitialCost, ''),
		@InterestRate = NULLIF(@InterestRate, ''),
		@PrincipalRate = NULLIF(@PrincipalRate, ''),
		@LeaseStartDate = NULLIF(@LeaseStartDate, ''),
		@LeaseEndDate = NULLIF(@LeaseEndDate, ''),
		@PrivateLease = NULLIF(@PrivateLease,''),
		
		@PriceProtection=NULLIF(@PriceProtection,''),
		@DeclarationAmount =NULLIF(@DeclarationAmount,''),
		@AmountPaid =NULLIF(@AmountPaid,''),
		@PaymentChequeNo =NULLIF(@PaymentChequeNo,''),
		@PaymentDate =NULLIF(@PaymentDate,''),
		@SalesProcessed = NULLIF(@SalesProcessed, ''),
		@MarketPrice=NULLIF(@MarketPrice,''),
		@SoldDate =NULLIF(@SoldDate,''),
		@Ownership=NULLIF(@Ownership,''),
		@TurnBackMessage=NULLIF(@TurnBackMessage,''),
		@FARemarks=NULLIF(@FARemarks,''),
		@PMScheduleID=NULLIF(@PMScheduleID,''),
		@TBExpense=NULLIF(@TBExpense,'')


Select @OldRiskType=Risk_Type, @OldVehicleCost = Vehicle_Cost from Vehicle where Unit_number=@nUnitNumber

	UPDATE	Vehicle
	SET	Foreign_Vehicle_Unit_Number 	= @ForeignVehicleUnitNumber,
		MVA_Number			= @MVANumber,
		Serial_Number			= @SerialNumber,
		Key_Ignition_Code		= @KeyIgnitionCode,
		Key_Trunk_Code			= @KeyTrunkCode,
		Exterior_Colour			= @ExteriorColour,
		Interior_Colour			= @InteriorColour,
		Vehicle_Class_Code		= @VehicleClassCode,
		Vehicle_Model_Id		= CONVERT(SmallInt, @VehicleModelId),
		Ownership_Date			= CONVERT(DateTime, @OwnershipDate),
		Owning_Company_ID		= CONVERT(SmallInt, @OwningCompanyID),
		Program				= CONVERT(Bit, @Program),
		Turn_Back_Deadline 		= CONVERT(DateTime, @TurnBackDeadline),
		Maximum_KM			= CONVERT(Int, @MaximumKM),
		Do_Not_Rent_Past_KM		= CONVERT(Int, @DoNotRentPastKM),
		Minimum_Days			= CONVERT(SmallInt, @MinimumDays),
		Maximum_Days			= CONVERT(SmallInt, @MaximumDays),
		Do_Not_Rent_Past_Days		= CONVERT(SmallInt, @DoNotRentPastDays),
		Reconditioning_Days_Allowed	= CONVERT(SmallInt, @ReconditioningDaysAllowed),
		Current_Location_ID		= CONVERT(SmallInt, @CurrentLocationID),
		Current_KM			= CONVERT(Int, @CurrentKM),
		Total_Non_Revenue_KM		= CONVERT(Int, @TotalNonRevenueKM),
		Next_Scheduled_Maintenance	= CONVERT(Int, @NextScheduledMaintenance),
		Smoking_Flag 			= CONVERT(Bit, @SmokingFlag),
		Maximum_Rental_Period		= CONVERT(SmallInt, @MaximumRentalPeriod),
		Licence_Plate_Attached_On	= CONVERT(DateTime, @LicencePlateAttachedOn),
		Current_Licence_Plate		= @CurrentLicencePlate,
		Current_Licencing_Prov_State	= @CurrentLicencingProvState,
		Foreign_Licence_Plate_Flag	= CONVERT(Bit, @ForeignLicencePlate_Flag),
		Comments			= @Comments,
		Last_Update_By			= @LastUpdateBy,
		Last_Update_On			= GetDate(),
		Current_Rental_Status		= @VehicleRentalStatus,
		Risk_Type		= @RiskType,

		Year_Of_Agreement   =   @YearOfAgreement,
		Purchase_Cycle   =   @PurchaseCycle,
		Purchase_Price   =   Convert(Decimal(9,2),@PurchasePrice),
		PDI_Amount   =    Convert(Decimal(9,2),@PDIAmount),
		PDI_Included_In_Price   =     Convert(Bit,@PDIIncludedInPrice),
		PDI_Performed_By   =   @PDIPerformedBy,
		Volume_Incentive   =    Convert(Decimal(9,2),@VolumeIncentive),
		Incentive_Received_From   =   @IncentiveReceivedFrom,
		Rebate_Amount   =    Convert(Decimal(9,2),@RebateAmount),
		Rebate_From   =   @RebateFrom,
		Planned_Days_In_Service   =   Convert(Smallint,@PlannedDayssInService),
		Vehicle_Cost   =    Convert(Decimal(9,2),@VehicleCost),
		Mark_Down   =        Convert(Decimal(9,2),@MarkDown),                       
		Excise_Tax   =    Convert(Decimal(9,2),@ExciseTax),                           
		Battery_Levy =    Convert(Decimal(9,2),@BatteryLevy),
		Own_Use   =     Convert(Bit,@OwnUse),
		Purchase_GST   =    Convert(Decimal(9,4),@PurchaseGST),
		Purchase_PST   =    Convert(Decimal(9,4),@PurchasePST),
		Payment_Type   =   @PaymentType,

		Depreciation_Rate_Amount   =    Convert(Decimal(9,2),@DepreciationRateAmount),
		Depreciation_Rate_Percentage   =    Convert(Decimal(9,2),@DepreciationRatePercentage),
		Depreciation_Start_Date   =   Convert(Datetime,@DepreciationStartDate),
		Depreciation_End_Date   =   Convert(Datetime,@DepreciationEndDate),

		Loan_Repaid_Max_KM = Convert(int,@LoanRepaidMaxKm),
		Loan_Repaid_Max_Ownership =Convert(smallint,@LoanRepaidMaxOwnership),
		Finance_By   =   @FinanceBy,
		Trans_Month   =    Convert(Smallint,@TransMonth),
		Loan_Amount   =    Convert(Decimal(9,2),@LoanAmount),
		Loan_Tax_Included   =    Convert(Bit,@LoanTaxIncluded),
		Loan_Principal_Rate_ID = Convert(int,@PrincipalRateID),
		Override_Principal_Rate= Convert(Decimal(10,7),@OverridePrincipalRate),
		Financing_Start_Date   =   Convert(Datetime,@FinancingStartDate),
		Financing_End_Date   =   Convert(Datetime,@FinancingEndDate),
		--Term   =    Convert(Smallint,@Term),
		Payout_Amount   =    Convert(Decimal(9,2),@PayoutAmount),
		Payount_Date   =   Convert(Datetime,@PayountDate),
		Loan_Setup_Fee   =    Convert(Decimal(9,2),@SetupFee),

		Cap_Cost   =    Convert(Decimal(9,2),@CapCost),
		Deduction   =    Convert(Decimal(9,2),@Deduction),
		Damage_Amount   =    Convert(Decimal(9,2),@DamageAmount),
		KM_Reading   =    Convert(Int,@KMReading),
		KM_Charge   =    Convert(Decimal(9,2),@KMCharge),
		ISD   =   Convert(Datetime,@ISD),
		OSD   =   Convert(Datetime,@OSD),
		Idle_Days= convert(smallint,@IdleDays),
		Depreciation_Periods  =   Convert(Decimal(9,2),@DepreciationPeriods),
		Selling_Monthly_AMO   =   Convert(Decimal(9,2),@SellingMonthlyAMO),
		Depreciation_Type	=	@DepreciationType,
		Sales_Acc_Dep   =   Convert(Decimal(9,2),@SalesAccDep),
		Selling_Price   =    Convert(Decimal(9,2),@SellingPrice),
		Sales_GST   =    Convert(Decimal(9,4),@SalesGST),
		Sales_PST   =    Convert(Decimal(9,4),@SalesPST),
		Sell_To   =   @SellTo,
		Sales_Processed_date   =   Convert(Datetime,@SalesProcesseddate),

		Lessee_id = Convert(smallint,@Lesseeid),
		Initial_Cost = Convert(Decimal(9,2),@InitialCost),
		Interest_Rate = Convert(Decimal(9,2),@InterestRate),
		Principle_Rate = Convert(Decimal(9,2),@PrincipalRate),
		Lease_Start_Date = Convert(Datetime,@LeaseStartDate),
		Lease_End_Date = Convert(Datetime,@LeaseEndDate),
		Private_Lease =   Convert(Bit,@PrivateLease),
		
		Price_Difference=Convert(Decimal(9,2),@PriceProtection),
		Declaration_Amount   =    Convert(Decimal(9,2),@DeclarationAmount),
		Amount_Paid   =    Convert(Decimal(9,2),@AmountPaid),
		Payment_Cheque_No   =   @PaymentChequeNo,
		Payment_Date = Convert(Datetime,@PaymentDate),

		Sales_Processed   =   Convert(Bit, @SalesProcessed),
		
		Market_Price=	Convert(Decimal(9,2),@MarketPrice),
		Sold_Date=Convert(Datetime,@Solddate),
		Ownership=@Ownership,
		Turn_Back_Message=@TurnBackMessage,
		FA_Remarks=@FARemarks,
		Overrid_PM_Schedule_Id=@PMScheduleID,
		TB_Expense=@TBExpense

	WHERE	Unit_Number = @nUnitNumber


				
	if @OldVehicleCost<>Convert(Decimal(9,2),@VehicleCost)		
	Update FA_Vehicle_Amortization Set Balance=   Convert(Decimal(9,2),@VehicleCost)
	WHERE	Unit_Number = @nUnitNumber and InService_Months = 0



	if (@OldRiskType<> @RiskType) or (@OldRiskType is null and @RiskType is not null) or (@OldRiskType is not null and @RiskType is null) 
			Insert Into Vehicle_RiskType_History
				(Unit_Number,Risk_Type,Effective_On,Last_Update_By)
			Values
				(@nUnitNumber, NULLIF(@RiskType, ''),  GetDate(),@LastUpdateBy)


RETURN 1



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
