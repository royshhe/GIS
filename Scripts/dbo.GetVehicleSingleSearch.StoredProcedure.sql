USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleSingleSearch]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To search and retrieve one or more vehicle record(s) using the given params.
	 If Retrieve is supplied, then
		- retrieve a single record using the UnitNumber and CategoryVehicleStatus.
	 Else, do a search using the given params.
	 	- if sDate and no UnitNumber, then search using sDate, 
		  SerialNumber, LicencePlate, and CategoryVehicleStatus.
		- if sDate and not NumericKey, then search using sDate, 
		  UnitNumber (matched with Foreign Unit Number), SerialNumber, 
		  LicencePlate, and CategoryVehicleStatus.
		- if sDate and is NumericKey, then search using sDate, 
		  UnitNumber (matched with GIS Unit Number), SerialNumber, 
		  LicencePlate, and CategoryVehicleStatus.
		- if no sDate and no UnitNumber, then search using SerialNumber 
		  and CategoryVehicleStatus
		- if no sDate and not NumericKey, then search using 
		  UnitNumber (matched with Foreign Unit Number), SerialNumber, 
		  and CategoryVehicleStatus.
		- if no sDate and is NumericKey, then search using 
		  UnitNumber (matched with GIS Unit Number), SerialNumber, 
		  and CategoryVehicleStatus.
MOD HISTORY:
Name	Date        	Comments
Don K	Mar 9 2000	Don't exclude vehicles with null serial numbers.
*/

CREATE PROCEDURE [dbo].[GetVehicleSingleSearch]
	@UnitNumber		VarChar(10),
	@SerialNumber		VarChar(10),
	@LicencePlate		VarChar(20),
	@sDate			VarChar(24),
	@NumericKey		VarChar(1),
	@Retrieve		VarChar(1),
	@CategoryVehicleStatus  VarChar(25),
	@sMaxDateTime		VarChar(24)
AS
Declare @AsOfDateAttached 	DateTime
Declare @AsOfDateRemoved 	DateTime
Declare @MaxDateTime 	DateTime
If @sDate = ''
  Begin
	Select @AsOfDateAttached = NULL
	Select @AsOfDateRemoved = NULL
  End
Else
  Begin
	Select @AsOfDateAttached = CONVERT(DateTime, @sDate + ' 11:59:59 PM')
	Select @AsOfDateRemoved = CONVERT(DateTime, @sDate)
  End
Select @MaxDateTime = CONVERT(DateTime, @sMaxDateTime)
If @Retrieve <> ''	
	-- retrieve a single record using the UnitNumber and CategoryVehicleStatus.
	SELECT	Distinct
		V.Unit_Number,
		V.Foreign_Vehicle_Unit_Number,
		V.Serial_Number,
		VMY.Model_Name,
		V.Exterior_Colour,
		V.Current_Licence_Plate,
		L.Value,
		Case V.Foreign_Vehicle_Unit_Number
			When NULL Then
				''
			When '' Then

				''
			Else
				'Foreign'
		End
	FROM	Vehicle V,
		Vehicle_Model_Year VMY,
		Lookup_Table L
	WHERE	V.Unit_Number 			= CONVERT(Int, @UnitNumber)
	AND	V.Vehicle_Model_ID 		= VMY.Vehicle_Model_ID
	AND	V.Current_Vehicle_Status	= L.Code
	AND	L.Category		= @CategoryVehicleStatus
	AND	Deleted			= 0
Else If @AsOfDateAttached IS NOT NULL
	If @UnitNumber = ''
	 	/* if sDate and no UnitNumber, then search using sDate, 
		   SerialNumber, LicencePlate, and CategoryVehicleStatus */
		SELECT	Distinct
			V.Unit_Number,
			V.Foreign_Vehicle_Unit_Number,
			V.Serial_Number,
			VMY.Model_Name,
			V.Exterior_Colour,
			V.Current_Licence_Plate,
			L.Value,
			Case V.Foreign_Vehicle_Unit_Number
				When NULL Then
					''
				When '' Then
					''
				Else
					'Foreign'
			End
		FROM	Vehicle V,
			Vehicle_Model_Year VMY,
			Lookup_Table L,
			Vehicle_Licence_History VLH
		WHERE	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
		AND	VLH.Licence_Plate_Number = @LicencePlate
		
		AND	V.Unit_Number = VLH.Unit_Number
		AND	VLH.Attached_On <= @AsOfDateAttached
		AND	ISNULL(VLH.Removed_On, @MaxDateTime) >= @AsOfDateRemoved
		
		AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
		AND	V.Current_Vehicle_Status= L.Code
		AND	L.Category		= @CategoryVehicleStatus
		AND	Deleted			= 0
	Else
  		If @NumericKey = ''
			/* if sDate and not NumericKey, then search using sDate, 
			   UnitNumber (matched with Foreign Unit Number), SerialNumber, 
			   LicencePlate, and CategoryVehicleStatus. */
			SELECT	Distinct
				V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,
				VMY.Model_Name,
				V.Exterior_Colour,
				V.Current_Licence_Plate,
				L.Value,
				Case V.Foreign_Vehicle_Unit_Number
					When NULL Then
						''
					When '' Then

						''
					Else
						'Foreign'

				End
		
			FROM	Vehicle V,
				Vehicle_Model_Year VMY,
				Lookup_Table L,
				Vehicle_Licence_History VLH
			WHERE	V.Foreign_Vehicle_Unit_Number = @UnitNumber
			AND	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
			AND	VLH.Licence_Plate_Number = @LicencePlate
			AND	V.Unit_Number = VLH.Unit_Number
			
			AND	VLH.Attached_On <= @AsOfDateAttached
			AND	ISNULL(VLH.Removed_On, @MaxDateTime) >= @AsOfDateRemoved
		
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	V.Current_Vehicle_Status= L.Code
			AND	L.Category		= @CategoryVehicleStatus
	
			AND	Deleted			= 0
	  	Else
			/* if sDate and is NumericKey, then search using sDate, 
			   UnitNumber (matched with GIS Unit Number), SerialNumber, 
			   LicencePlate, and CategoryVehicleStatus. */
			SELECT	Distinct
				V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,
				VMY.Model_Name,
				V.Exterior_Colour,
				V.Current_Licence_Plate,
				L.Value,
				Case V.Foreign_Vehicle_Unit_Number
					When NULL Then
						''
					When '' Then
						''
					Else
						'Foreign'
				End
			FROM	Vehicle V,
				Vehicle_Model_Year VMY,
				Lookup_Table L,
				Vehicle_Licence_History VLH
			WHERE	(	
					(V.Unit_Number = CONVERT(Int, @UnitNumber) AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
				OR	(Foreign_Vehicle_Unit_Number = @UnitNumber)
				)
			AND	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
			AND	VLH.Licence_Plate_Number = @LicencePlate
			AND	V.Unit_Number = VLH.Unit_Number
			
			AND	VLH.Attached_On <= @AsOfDateAttached
			AND	ISNULL(VLH.Removed_On, @MaxDateTime) >= @AsOfDateRemoved
		
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	V.Current_Vehicle_Status= L.Code
			AND	L.Category		= @CategoryVehicleStatus
			AND	Deleted			= 0
Else
	If @UnitNumber = ''
		/* if no sDate and no UnitNumber, then search using SerialNumber 
		   and CategoryVehicleStatus */
		SELECT	Distinct
			V.Unit_Number,
			V.Foreign_Vehicle_Unit_Number,
			V.Serial_Number,
			VMY.Model_Name,
			V.Exterior_Colour,
			V.Current_Licence_Plate,
			L.Value,
			Case V.Foreign_Vehicle_Unit_Number
				When NULL Then
					''
				When '' Then
					''
				Else
					'Foreign'
			End
		FROM	Vehicle V,
			Vehicle_Model_Year VMY,
			Lookup_Table L
		WHERE	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
		
		AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
		AND	V.Current_Vehicle_Status= L.Code
		AND	L.Category		= @CategoryVehicleStatus
		AND	Deleted			= 0
	Else
  		If @NumericKey = ''
			/* if no sDate and not NumericKey, then search using 
			   UnitNumber (matched with Foreign Unit Number), SerialNumber, 
			   and CategoryVehicleStatus. */
			SELECT	Distinct
				V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,

				VMY.Model_Name,
				V.Exterior_Colour,
				V.Current_Licence_Plate,
				L.Value,
				Case V.Foreign_Vehicle_Unit_Number
					When NULL Then
						''
					When '' Then
						''
					Else
						'Foreign'
				End
		
			FROM	Vehicle V,
				Vehicle_Model_Year VMY,
				Lookup_Table L
			WHERE	V.Foreign_Vehicle_Unit_Number = @UnitNumber
			AND	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
			
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	V.Current_Vehicle_Status= L.Code
			AND	L.Category		= @CategoryVehicleStatus
	
			AND	Deleted			= 0
	  	Else
			/* if no sDate and is NumericKey, then search using 
			   UnitNumber (matched with GIS Unit Number), SerialNumber, 
			   and CategoryVehicleStatus. */
			SELECT	Distinct
				V.Unit_Number,
				V.Foreign_Vehicle_Unit_Number,
				V.Serial_Number,
				VMY.Model_Name,
				V.Exterior_Colour,
				V.Current_Licence_Plate,
				L.Value,
				Case V.Foreign_Vehicle_Unit_Number
					When NULL Then
						''
					When '' Then
						''
					Else
						'Foreign'
				End
			FROM	Vehicle V,
				Vehicle_Model_Year VMY,
				Lookup_Table L
			WHERE	(	
					(V.Unit_Number = CONVERT(Int, @UnitNumber) AND	(Foreign_Vehicle_Unit_Number = '' OR Foreign_Vehicle_Unit_Number IS Null))
				OR	(Foreign_Vehicle_Unit_Number = @UnitNumber)
				)
			AND	ISNULL(V.Serial_Number, '') Like '%' + LTrim(@SerialNumber)
		
			AND	V.Vehicle_Model_ID 	= VMY.Vehicle_Model_ID
			AND	V.Current_Vehicle_Status= L.Code
			AND	L.Category		= @CategoryVehicleStatus
			AND	Deleted			= 0
RETURN 1


















GO
