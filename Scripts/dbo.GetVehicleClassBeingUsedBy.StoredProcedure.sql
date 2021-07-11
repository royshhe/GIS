USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleClassBeingUsedBy]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehicleClassBeingUsedBy]
	@VehicleClassCode Varchar(11)
AS
	/* 8/31/99 - changed comparisons from <> '' to IS NOT NULL */

	DECLARE @Customer 			VarChar(30)
	DECLARE @LocVehClass		VarChar(30)	
	DECLARE @OrgMinAge			VarChar(30)
	DECLARE @RateVehClass 		VarChar(30)
	DECLARE @TruckInventory 		VarChar(30)
	DECLARE @VehModelYear 		VarChar(30)
	DECLARE @Vehicle 			VarChar(30)
	DECLARE @ReturnString		VarChar(255)
		
	SELECT	@VehicleClassCode = NULLIF(@VehicleClassCode, '')

	SELECT	@Customer = 'Customers'
	FROM		Customer
	WHERE	Vehicle_Class_Code = @VehicleClassCode

	SELECT	@LocVehClass = 'Locations'
	FROM		Location_Vehicle_Class
	WHERE	Vehicle_Class_Code =@VehicleClassCode

	SELECT	@OrgMinAge = 'Organization Minimum Age'
	FROM		Organization_Min_Age_Override
	WHERE	Vehicle_Class_Code = @VehicleClassCode

	SELECT	@RateVehClass = 'Vehicle Rates'
	FROM		Rate_Vehicle_Class
	WHERE	Vehicle_Class_Code =@VehicleClassCode

	SELECT	@TruckInventory = 'Truck Inventory'
	FROM		Truck_Inventory
	WHERE	Vehicle_Class_Code = @VehicleClassCode

	SELECT	@VehModelYear = 'Vehicle Models'
	FROM		Vehicle_Model_Year
	WHERE	ICBC_Class = @VehicleClassCode

	SELECT	@Vehicle = 'Vehicles'
	FROM		Vehicle
	WHERE	Vehicle_Class_Code = @VehicleClassCode

	If @Customer IS NOT NULL
		SELECT @ReturnString = @Customer

	If @LocVehClass IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @LocVehClass
		Else
			SELECT @ReturnString = @LocVehClass

	If @OrgMinAge IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @OrgMinAge
		Else
			SELECT @ReturnString = @OrgMinAge

	If @RateVehClass IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @RateVehClass
		Else
			SELECT @ReturnString = @RateVehClass

	If @TruckInventory IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @TruckInventory
		Else
			SELECT @ReturnString = @TruckInventory

	If @VehModelYear IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @VehModelYear
		Else
			SELECT @ReturnString = @VehModelYear

	If @Vehicle IS NOT NULL
		If @ReturnString <> ''
			SELECT @ReturnString = @ReturnString + ', ' + @Vehicle
		Else
			SELECT @ReturnString = @Vehicle

	SELECT @ReturnString

	RETURN	1

















GO
