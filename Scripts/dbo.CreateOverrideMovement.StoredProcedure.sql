USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOverrideMovement]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To insert a record into Override_Movement_Completion table.
MOD HISTORY:
Name    Date        	Comments
CPY	3/25/99 	- bug fix - apply NULLIF check to all fields before using 
CPY	3/26/99 	- bug fix - remove convert to smallint on ToLocation 
CPY	4/08/99 	- bug fix - remove convert to smallint on FromLocation
			- when getting the last movement out time, use receiving loc
			  instead of sending loc 
CPY	4/09/99 	- cpy bug fix - removed @Location param 
CPY	4/10/99 	- cpy bug fix - changed Movement_In to save the last Checked_Out
			field in vehicle_on_contract for this unit
			- NOTE: by the time an override is saved, a vehicle on contract
			  record must have been saved as well, so we can just look up
			  the most recent Checked_Out date for this contract# and unit# 
NP	11/2/99 	- np changed the size of FromLocation and ToLocation from 
			VarChar(20) to VarChar(25) 
CPY	Jan 6 2000	- automatically complete the corresponding movement for this override
			  by updating the vehicle_movement table
CPY	Feb 7 2000	- automatically update the vehicle table with the new 
			  current KM and current location
*/

CREATE PROCEDURE [dbo].[CreateOverrideMovement]
	@ContractNumber varchar(20),
	@UnitNumber 	varchar(20),
	@FromLocation 	varchar(25),
	@ToLocation 	varchar(25),
	@LicenceNumber 	varchar(20),
	@KmIn 		varchar(20),
	@FuelLevel 	varchar(20),
	@FuelRemaining 	varchar(20)
AS

Declare @iToLocationID 		int
Declare @iFromLocationID 	int
Declare @dMovementOut 		datetime
DECLARE @dMovementIn 		Datetime
DECLARE @iUnitNumber		Int
DECLARE @iContractNumber	Int,
	@iKMIn			Int

SELECT	@iUnitNumber = Convert(int, NULLIF(@UnitNumber,'')),
	@iContractNumber = Convert(int, NULLIF(@ContractNumber,'')),
	@iKMIn = Convert(Int, NULLIF(@KmIn,''))

	Select	@iToLocationID = Location_ID
	From	Location
	Where	Location = NULLIF(@ToLocation,'')

	Select	@iFromLocationID = Location_ID
	From	Location
	Where	Location = NULLIF(@FromLocation,'')

	/* Select @thisMovementOut = (	Select	Movement_Out
				From	Vehicle_Movement
				Where	Unit_Number = Convert(int, NULLIF(@UnitNumber,''))
				And 	Sending_Location_ID = @thisFromLocationID) */

	-- Get last IN-TRANSIT movement that is destined to arrive at this ToLocationId
SET ROWCOUNT 1

	Select 	@dMovementOut = Movement_Out
	From	Vehicle_Movement
	Where	Unit_Number = @iUnitNumber
	And 	Receiving_Location_ID = @iToLocationID
	And 	Movement_In IS NULL
	ORDER BY Movement_Out DESC

	-- if for some reason there is no IN-TRANSIT movement to arrive at this ToLocationId,
	-- just get the last IN-TRANSIT movement for this unit (there should only be 1
	-- movement in transit for any given unit at a given time)
	IF @dMovementOut IS NULL
		Select 	@dMovementOut = Movement_Out
		From	Vehicle_Movement
		Where	Unit_Number = @iUnitNumber
		And 	Movement_In IS NULL
		ORDER BY Movement_Out DESC

	SELECT	@dMovementIn = Checked_Out
	FROM	Vehicle_On_Contract
	WHERE	Contract_Number = @iContractNumber
	AND	Unit_Number = @iUnitNumber
	ORDER BY Checked_Out DESC

SET ROWCOUNT 0

	Insert Into Override_Movement_Completion
		(Unit_Number,
		 Movement_Out,
		 Override_Contract_Number,
		 Receiving_Location_ID,
		 Movement_In,
		 Km_In,
		 Fuel_Level,
		 Litres_Of_Fuel_Remaining )
	Values
		(@iUnitNumber,
		 @dMovementOut,
		 @iContractNumber,
		 @iToLocationID,
		 @dMovementIn, 
		 @iKMIn,
		 NULLIF(@FuelLevel,''),
		 Convert(int, NULLIF(@FuelRemaining,'')))

	-- Jan 6 2000 - complete the corresponding movement for this override

	Update	Vehicle_Movement
	Set	Movement_In = @dMovementIn,
		Receiving_Location_ID = @iToLocationID,
		Km_In = @iKMIn,
		Remarks_In = "Movement was overridden by GIS contract# " + @ContractNumber + "."
	Where	Unit_Number	= @iUnitNumber
	And 	Movement_Out	= @dMovementOut

	-- Feb 7 2000 - update the vehicle's current KM and current location

	UPDATE	Vehicle
	SET	Current_KM = @iKMIn,
		Current_Location_Id = @iToLocationID
	WHERE	Unit_Number = @iUnitNumber

Return 1









GO
