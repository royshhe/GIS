USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleForeign]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.CreateVehicleForeign    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleForeign    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleForeign    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVehicleForeign    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Vehicle table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVehicleForeign]
	@OwningCompanyID 		VarChar(10),
	@ForeignVehicleUnitNumber 	VarChar(20),
	@VehicleClassCode 		Char(1),
	@VehicleModelID 		VarChar(10),
	@ExteriorColour 			VarChar(15),
	@CurrentLocationID 		VarChar(10),
	@CurrentLicencingProvState 	VarChar(30),
	@CurrentLicencePlate 		VarChar(10),
	@CurrentRentalStatusCode 	Char(1),
	@RentalStatusEffectiveOn 	VarChar(24),
	@CurrentConditionStatusCode 	Char(1),
	@ConditionStatusEffectiveOn 	VarChar(24),
	@CurrentVehicleStatusCode 	Char(1),
	@VehicleStatusEffectiveOn 	VarChar(24),
	@ForeignLicencePlate_Flag 	Char(1),
	@Deleted 			Char(1),
	@User 				VarChar(20),
	@KmIn				VarChar(10) = NULL
AS
	Declare @thisUnitNumber int
	SELECT	@VehicleStatusEffectiveOn	=  DATEADD(dd, 0, DATEDIFF(dd, 0, convert(datetime,@VehicleStatusEffectiveOn)))
	SELECT	@ConditionStatusEffectiveOn	=  DATEADD(dd, 0, DATEDIFF(dd, 0, convert(datetime,@ConditionStatusEffectiveOn)))
	SELECT	@RentalStatusEffectiveOn	=  DATEADD(dd, 0, DATEDIFF(dd, 0, convert(datetime,@RentalStatusEffectiveOn)))

	INSERT INTO Vehicle
	(	Owning_Company_ID,
		Foreign_Vehicle_Unit_Number,
		Vehicle_Class_Code,
		Vehicle_Model_ID,
		Exterior_Colour,
		Current_Location_ID,
		Current_Licencing_Prov_State,
		Current_Licence_Plate,
		Current_Rental_Status,
		Rental_Status_Effective_On,
		Current_Condition_Status,
		Condition_Status_Effective_On,
		Current_Vehicle_Status,
		Vehicle_Status_Effective_On,
		Foreign_Licence_Plate_Flag,
		Current_KM,
		Deleted,
		Last_Update_By,
		Last_Update_On
	)
	VALUES
	(	CONVERT(SmallInt, @OwningCompanyID),
		NULLIF(@ForeignVehicleUnitNumber,''),
		@VehicleClassCode,
		CONVERT(SmallInt, @VehicleModelID),
		@ExteriorColour,
		CONVERT(SmallInt, @CurrentLocationID),
		@CurrentLicencingProvState,
		@CurrentLicencePlate,
		@CurrentRentalStatusCode,
		CONVERT(DateTime, @RentalStatusEffectiveOn),
		@CurrentConditionStatusCode,
		CONVERT(DateTime, @ConditionStatusEffectiveOn),
		@CurrentVehicleStatusCode,
		CONVERT(DateTime, @VehicleStatusEffectiveOn),
		CONVERT(Bit, @ForeignLicencePlate_Flag),
		CONVERT(Int, NULLIF(@KmIn, '')),
		CONVERT(Bit, @Deleted),
		@User,
		GetDate()
	)
	
	Select @thisUnitNumber = @@IDENTITY
	/* insert a record into Vehicle Status */
	Insert Into Vehicle_History
		(	Unit_Number,
			Vehicle_Status,
			Effective_On
		)
	Values
		(	@thisUnitNumber,
			@CurrentVehicleStatusCode,
			CONVERT(DateTime, @VehicleStatusEffectiveOn)
		)
	/* insert a record into Condition History */
	Insert Into Condition_History
		(	Unit_Number,
			Condition_Status,
			Effective_On
		)
	Values
		(	@thisUnitNumber,
			@CurrentConditionStatusCode,
			CONVERT(DateTime, @ConditionStatusEffectiveOn)
		)
Return @thisUnitNumber
GO
