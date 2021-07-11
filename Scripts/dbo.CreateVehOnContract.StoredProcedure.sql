USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehOnContract]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To insert a record into Vehicle_On_Contract table.
MOD HISTORY:
Name    Date        Comments
Don K	Jan 10 2000 Added business transaction ID
*/

CREATE PROCEDURE [dbo].[CreateVehOnContract]
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
	@ReplaceContractNum Varchar(20),
	@BusTrxID varchar(11)
AS
	/* 3/31/99 - cpy modified - convert @FuelPricePerLitre to decimal(9,3), previously (9,2)*/

	INSERT INTO Vehicle_On_Contract
		(Contract_Number,
--		 Vehicle_Owning_Company_ID,
		 Unit_Number,
		 Checked_Out,
		 Pick_Up_Location_ID,
		 Expected_Check_In,
		 Expected_Drop_Off_Location_ID,
		 Actual_Check_In,
		 Actual_Drop_Off_Location_ID,
		 Km_Out,
		 Km_In,
		 Fuel_Level,
		 Fuel_Remaining,
		 Fuel_Added_Dollar_Amt,
		 Fuel_Added_Litres,
		 Vehicle_Condition_Status,
		 Vehicle_Not_Present_Reason,
		 Vehicle_Not_Present_Location,
		 Checked_In_By,
		 Check_In_Reason,
		 Actual_Vehicle_Class_Code,
		 FPO_Purchased,
		 Calculated_Fuel_Charge,

		 Upgrade_Charge,
		 Fuel_Price_Per_Litre,
		 Calculated_Fuel_Litre,
		 Calculated_Upgrade_Charge,
		 Foreign_FPO_Charge,
		 Replacement_Contract_Number,
		 Business_Transaction_ID, 
		 Last_Updated_On
		)
	VALUES	(Convert(Int, NULLIF(@ContractNum,"")),
--		 Convert(SmallInt, NULLIF(@VehOwningCo,"")),
		 Convert(Int, NULLIF(@UnitNum,"")),
		 Convert(Datetime, NULLIF(@CheckedOut,"")),
		 Convert(SmallInt, NULLIF(@PULocId,"")),
		 Convert(Datetime, NULLIF(@ExpCheckIn,"")),
		 Convert(SmallInt, NULLIF(@ExpDOLocId,"")),
		 Convert(Datetime, NULLIF(@ActualCheckIn,"")),
		 Convert(SmallInt, NULLIF(@ActualDOLocId,"")),
		 Convert(Int, NULLIF(@KMOut,"")),
		 Convert(Int, NULLIF(@KMIn,"")),
		 NULLIF(@FuelLevel, ""),
		 Convert(Decimal(5,2), NULLIF(@FuelRemaining,"")),
		 Convert(Decimal(9,2), NULLIF(@FuelAddedDollarAmt, "")),
		 Convert(Decimal(5,2), NULLIF(@FuelAddedLitres,"")),
		 NULLIF(@VehCondStatus,""),
		 NULLIF(@VehNotPresReason,""),
		 NULLIF(@VehNotPresLoc,""),
		 NULLIF(@CheckInBy,""),
		 NULLIF(@CheckInReason ,""),
		 NULLIF(@ActualVehClassCode,""),
		 Convert(Bit, NULLIF(@FPO,"")),
		 Convert(Decimal(9,2), NULLIF(@CalcFuelCharge,"")),
		 Convert(Decimal(9,2), NULLIF(@UpgradeCharge,"")),
		 Convert(Decimal(9,3), NULLIF(@FuelPricePerLitre,"")),
		 Convert(Decimal(9,2), NULLIF(@CalcFuelLitre,"")),
		 Convert(Decimal(9,2), NULLIF(@CalcUpgradeCharge,"")),
		 Convert(Decimal(9,2), NULLIF(@ForeignFPOCharge,"")),
		 NULLIF(@ReplaceContractNum,""),
		 Convert(Int, NULLIF(@BusTrxID, '')),
		 Getdate()
		)
	RETURN @@ROWCOUNT
GO
