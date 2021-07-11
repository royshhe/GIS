USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteVehicleMovementAdjust]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PURPOSE: To update a record in Vehicle_Movement table .
MOD HISTORY:
Name	Date		Comment
NP	Oct 27 		- Moved data conversion code out of the where clause 
CPY	15-dec-1999	- modified condition used to update vehicle status
			  (check for override movement instead of contract status)
			- also, when updating rental_status_effective_on, use 
			  the Movement In date instead of getdate()
Don K	Jan 21 2000	- Always update audit info on vehicle table
*/
create PROCEDURE [dbo].[DeleteVehicleMovementAdjust]
	@UnitNumber 	varchar(30),
	@OldDateTimeOut	varchar(30),
	@UserName 	varchar(30)
AS
Declare @nUnitNumber Integer

Select @nUnitNumber = Convert(int,NULLIF(@UnitNumber, ''))


delete
	Vehicle_Movement
Where
	Unit_Number		=@nUnitNumber
	And convert(Varchar,Movement_Out)	=@OldDateTimeOut

	UPDATE	vehicle
	SET	Last_Update_By = @UserName,
		Last_Update_On = GETDATE()
	WHERE	Unit_Number = @nUnitNumber
	
Return 1
GO
