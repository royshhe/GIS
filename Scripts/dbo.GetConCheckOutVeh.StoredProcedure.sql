USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConCheckOutVeh]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: 	To retrieve the available vehicle for check out based on the given parameters.
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 6 2000	Return current licencing province state and displayed unit number
CPY	Jan 21 2000 	Added param to search by GIS# or foreign unit # (@Command = 'S'), or
			retrieve by GIS# only (@Command = 'R' or null)
*/
CREATE PROCEDURE [dbo].[GetConCheckOutVeh]
	@UnitNum Varchar(20),
	@LicPlate Varchar(10),
	@VehClassCode Varchar(1),
	@PickupDate  Varchar(24),
	@DropOffDate  Varchar(24),
	@Command Varchar(1) = NULL
AS
DECLARE @iDaysRental Int
DECLARE @iUnitNum Int
	SELECT	@LicPlate = NULLIF(@LicPlate,''),
		@VehClassCode = NULLIF(@VehClassCode,''),
		@iUnitNum =
		CASE ISNUMERIC(@UnitNum)
			WHEN 1 THEN Convert(Int, NULLIF(@UnitNum,''))
			ELSE NULL
		END, 
		@Command = ISNULL(@Command, 'R')

	IF @Command = 'S'

		SELECT	V.Unit_Number,
			V.Current_Licence_Plate,
			V.Model_Name,
			V.Model_Year,
			V.Exterior_Colour,
			V.Current_Km,
			Convert(Char(1), V.Smoking_Flag),
			V.Name,
			V.Vehicle_Type_ID,
			Convert(Char(1), V.Program),
			V.Current_Condition_Status,
			V.Do_Not_Rent_Past_Km,
				V.Ownership_Date,
			V.Do_Not_Rent_Past_Days,
			V.Turn_Back_Deadline,
			V.Next_Scheduled_Maintenance,
			V.Current_Rental_Status,
			V.Maximum_Rental_Period,
			V.Current_Location_ID,
			V.Owning_Company_ID,
			V.Manufacturer_ID,
			V.Foreign_Vehicle_Unit_Number,
			V.Current_Licencing_Prov_State,
			V.Displayed_Unit_Number,
			v.addendum
		FROM	Vehicle_Avail_Units V 
		WHERE  ( (V.Unit_Number = @iUnitNum
				  AND
			  V.Foreign_Vehicle_Unit_Number IS NULL)
		     OR	V.Foreign_Vehicle_Unit_Number = @UnitNum )
		AND	V.Current_Licence_Plate = @LicPlate
		AND	V.Vehicle_Class_Code = @VehClassCode
                AND     V.Unit_Number not in (
			select Unit_Number from Vehicle_Movement_Transaction
			where  (Date_out between CONVERT(DATETIME,@PickupDate) and CONVERT(DATETIME,@DropOffDate)) 
				or (Date_in between CONVERT(DATETIME,@PickupDate) and CONVERT(DATETIME,@DropOffDate))
                      )

	ELSE IF @Command = 'R' 

		-- NOTE: Vehicle_Avail_Units is a view
		-- 981113 - cpy - added foreign_vehicle_unit_number
		SELECT	V.Unit_Number,
			V.Current_Licence_Plate,
			V.Model_Name,
			V.Model_Year,
			V.Exterior_Colour,
			V.Current_Km,
			Convert(Char(1), V.Smoking_Flag),
			V.Name,
			V.Vehicle_Type_ID,
			Convert(Char(1), V.Program),
			V.Current_Condition_Status,
			V.Do_Not_Rent_Past_Km,
			Convert(Varchar(20), V.Ownership_Date,113),
			V.Do_Not_Rent_Past_Days,
			V.Turn_Back_Deadline,
			V.Next_Scheduled_Maintenance,
			V.Current_Rental_Status,
			V.Maximum_Rental_Period,
			V.Current_Location_ID,
			V.Owning_Company_ID,
			V.Manufacturer_ID,
			V.Foreign_Vehicle_Unit_Number,
			V.Current_Licencing_Prov_State,
			V.Displayed_Unit_Number,
			v.addendum
		FROM	Vehicle_Avail_Units V
		WHERE   V.Unit_Number = @iUnitNum
		AND	V.Current_Licence_Plate = @LicPlate
		AND	V.Vehicle_Class_Code = @VehClassCode
 		AND     V.Unit_Number not in (
			select Unit_Number from Vehicle_Movement_Transaction
			where  (Date_out between CONVERT(DATETIME,@PickupDate) and CONVERT(DATETIME,@DropOffDate)) 
				or (Date_in between CONVERT(DATETIME,@PickupDate) and CONVERT(DATETIME,@DropOffDate))
                      )

	RETURN @@ROWCOUNT
GO
