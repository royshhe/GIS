USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehOnContract]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdateVehOnContract    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehOnContract    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehOnContract    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehOnContract    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle_On_Contract table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateVehOnContract]
	@ContractNum Varchar(10),
	@VehOwningCo Varchar(5),
	@UnitNum Varchar(10),
	@CheckedOut Varchar(24),
	@PULocId Varchar(5),
	@ExpCheckIn Varchar(24),
	@ExpDOLocId Varchar(5),
	@ActualCheckIn Varchar(24),
	@ActualDOLocId Varchar(5),
	@KMOut Varchar(10),
	@KMIn Varchar(10),
	@FuelLevel Varchar(6),
	@FuelRemaining Varchar(10),
	@FuelAddedDollarAmt Varchar(10),
	@FuelAddedLitres Varchar(10),
	@VehCondStatus Varchar(1),
	@VehNotPresReason Varchar(20),
	@VehNotPresLoc Varchar(128),
	@CheckInBy Varchar(20),
	@CheckInReason Varchar(20),
	@ActualVehClassCode Varchar(1),
	@FPO Varchar(1),
	@CalcFuelLitre Varchar(10),
	@FuelPricePerLitre Varchar(11),
	@CalcFuelCharge Varchar(10),
	@UpgradeCharge Varchar(10),
	@CalcUpgradeCharge Varchar(10),
	@ForeignFPOCharge Varchar(10),
	@ReplaceContractNum Varchar(20)
AS
	/* 3/31/99 - cpy modified - convert FuelPricePerLitre to decimal(9,3), previously (9,2) */

	Declare	@nContractNum Integer
	Declare	@nUnitNum Integer
	Declare	@dCheckedOut DateTime

	SELECT 	
		@ContractNum = NULLIF(@ContractNum,""),
		@UnitNum = NULLIF(@UnitNum,""),
		@CheckedOut = NULLIF(@CheckedOut,""),
		@PULocId = NULLIF(@PULocId,""),
		@ExpCheckIn = NULLIF(@ExpCheckIn,""),
		@ExpDOLocId = NULLIF(@ExpDOLocId,""),
		@ActualCheckIn = NULLIF(@ActualCheckIn,""),
		@ActualDOLocId = NULLIF(@ActualDOLocId,""),
		@KMOut = NULLIF(@KMOut,""),
		@KMIn = NULLIF(@KMIn,""),
		@FuelLevel = NULLIF(@FuelLevel, ""),
		@FuelRemaining = NULLIF(@FuelRemaining,""),
		@FuelAddedDollarAmt = NULLIF(@FuelAddedDollarAmt, ""),
		@FuelAddedLitres = NULLIF(@FuelAddedLitres,""),
		@VehCondStatus = NULLIF(@VehCondStatus,""),
		@VehNotPresReason = NULLIF(@VehNotPresReason,""),
		@VehNotPresLoc = NULLIF(@VehNotPresLoc,""),
		@CheckInBy = NULLIF(@CheckInBy,""),
		@CheckInReason = NULLIF(@CheckInReason ,""),
		@ActualVehClassCode = NULLIF(@ActualVehClassCode,""),
		@FPO = NULLIF(@FPO,""),
		@CalcFuelLitre = NULLIF(@CalcFuelLitre, ""),
		@FuelPricePerLitre = NULLIF(@FuelPricePerLitre, ""),
		@CalcFuelCharge = NULLIF(@CalcFuelCharge, ""),
		@UpgradeCharge = NULLIF(@UpgradeCharge, ""),
		@CalcUpgradeCharge = NULLIF(@CalcUpgradeCharge, ""),
		@ForeignFPOCharge = NULLIF(@ForeignFPOCharge,""),
		@ReplaceContractNum = NULLIF(@ReplaceContractNum,"")
	/* 980921 - cpy - the check out specific columns are: PULocId, ExpCheckIn,
			  ExpDOLocId, KMOut, Substitute_Class, FPOPurchased, UpgradeCharge
			- the rest of the columns are check in specific columns
			  (ie. normally updated at checkin)
			- update the check out specific columns only if their respective
			  param values are NOT NULL; eg. if param @ExpCheckIn = "",
			  DO NOT update Expected_Check_In = NULL
         */

	Select		@nContractNum 	= Convert(Int, @ContractNum)
	Select		@nUnitNum 		= Convert(Int, @UnitNum)
	Select		@dCheckedOut 	= Convert(Datetime, @CheckedOut)
	
	UPDATE 	Vehicle_On_Contract
	SET 	Pick_Up_Location_ID = ISNULL(Convert(SmallInt, @PULocId),
			Pick_Up_Location_ID),
		Expected_Check_In = ISNULL(Convert(Datetime, @ExpCheckIn),
			Expected_Check_In),
		Expected_Drop_Off_Location_ID = ISNULL(Convert(SmallInt, @ExpDOLocId),
			Expected_Drop_Off_Location_ID),
		Actual_Check_In = Convert(Datetime, @ActualCheckIn),
		Actual_Drop_Off_Location_ID = Convert(SmallInt, @ActualDOLocId),
                -- Fxing data convertion error rhe
		Km_Out = ISNULL(Convert(Int, Convert(Decimal(9,0), @KMOut)), Km_Out),
                -- Fxing data convertion error rhe
		Km_In = Convert(Int, Convert(Decimal(9,0), @KMIn)),
		Fuel_Level = @FuelLevel,
		Fuel_Remaining = Convert(Decimal(5,2), @FuelRemaining),
		Fuel_Added_Dollar_Amt = Convert(Decimal(9,2), @FuelAddedDollarAmt),
		Fuel_Added_Litres = Convert(Decimal(5,2), @FuelAddedLitres),
		Vehicle_Condition_Status =  @VehCondStatus,
		Vehicle_Not_Present_Reason = @VehNotPresReason,
		Vehicle_Not_Present_Location = @VehNotPresLoc,
		Checked_In_By = @CheckInBy,
		Check_In_Reason = @CheckInReason,
		Actual_Vehicle_Class_Code = ISNULL(@ActualVehClassCode, Actual_Vehicle_Class_Code),
		FPO_Purchased = ISNULL(Convert(Bit, @FPO), FPO_Purchased),
		Calculated_Fuel_Charge = Convert(Decimal(9,2), @CalcFuelCharge),
		Upgrade_Charge = ISNULL(Convert(Decimal(9,2), @UpgradeCharge), Upgrade_Charge),
		Fuel_Price_Per_Litre = Convert(Decimal(9,3), @FuelPricePerLitre),
		Calculated_Fuel_Litre = Convert(Decimal(9,2), @CalcFuelLitre),
		Calculated_Upgrade_Charge = Convert(Decimal(9,2), @CalcUpgradeCharge),
		Foreign_FPO_Charge = Convert(Decimal(9,2), @ForeignFPOCharge),
		Replacement_Contract_Number = @ReplaceContractNum,
		Last_Updated_On =getdate()
	
	WHERE	Contract_Number 	= @nContractNum
	AND		Unit_Number 		= @nUnitNum
	AND		Checked_Out 		= @dCheckedOut

	RETURN @@ROWCOUNT
GO
