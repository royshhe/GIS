USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicleForeign]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/* Update Foreign Vehicle
    -Created by Kenneth Wong Aug 25, 2005
    
    -Add Deleted=0 by Peter Ni 10 Sep ,2008	
*/
CREATE PROCEDURE [dbo].[UpdateVehicleForeign]
	@OwningCompanyID 		VarChar(10),
	@ForeignVehicleUnitNumber 	VarChar(20),
	@VehicleClassCode 		Char(1),
	@VehicleModelID 		VarChar(10),
	@ExteriorColour 		VarChar(15),
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
	UPDATE Vehicle 
	SET Owning_Company_ID = CONVERT(SmallInt, @OwningCompanyID),
	Foreign_Vehicle_Unit_Number = NULLIF(@ForeignVehicleUnitNumber,''),
	Vehicle_Class_Code = @VehicleClassCode,
	Vehicle_Model_ID = CONVERT(SmallInt, @VehicleModelID),
	Exterior_Colour = @ExteriorColour,
	Current_Location_ID = CONVERT(SmallInt, @CurrentLocationID),
	Current_Licencing_Prov_State = @CurrentLicencingProvState,
	Current_Licence_Plate = @CurrentLicencePlate,
	Current_Rental_Status = @CurrentRentalStatusCode,
	Rental_Status_Effective_On = CONVERT(DateTime, @RentalStatusEffectiveOn),
	Current_Condition_Status = @CurrentConditionStatusCode,
	Condition_Status_Effective_On =CONVERT(DateTime, @ConditionStatusEffectiveOn),
	Current_Vehicle_Status = @CurrentVehicleStatusCode,
	Vehicle_Status_Effective_On = CONVERT(DateTime, @VehicleStatusEffectiveOn),
	Foreign_Licence_Plate_Flag = CONVERT(Bit, @ForeignLicencePlate_Flag),
	Current_KM = CONVERT(Int, NULLIF(@KmIn, '')),
	Deleted = CONVERT(Bit, @Deleted),
	Last_Update_By = @User,
	Last_Update_On = GetDate()
	WHERE Foreign_Vehicle_Unit_Number = @ForeignVehicleUnitNumber and
	Current_Licence_Plate = @CurrentLicencePlate and
	Current_Licencing_Prov_State = @CurrentLicencingProvState and
	Owning_Company_ID = CONVERT(SmallInt, @OwningCompanyID)
	and Deleted=0

	DECLARE vehicle_cursor CURSOR FOR
	select unit_number from vehicle where Foreign_Vehicle_Unit_Number =  @ForeignVehicleUnitNumber and
		Current_Licence_Plate =  @CurrentLicencePlate and
		Current_Licencing_Prov_State = @CurrentLicencingProvState and
		Owning_Company_ID =  CONVERT(SmallInt, @OwningCompanyID)
		and Deleted=0
	OPEN vehicle_cursor
	FETCH NEXT FROM vehicle_cursor into @thisUnitNumber
	CLOSE vehicle_cursor
	DEALLOCATE vehicle_cursor
		
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
