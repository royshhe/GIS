USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicleMovement]    Script Date: 2021-07-10 1:50:51 PM ******/
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
CREATE PROCEDURE [dbo].[UpdateVehicleMovement]
	@UnitNumber 	varchar(30),
	@OldDateTimeOut	varchar(30),
	@NewDateTimeOut	varchar(30),
	@MovementType	varchar(30),
	@StartingKm	varchar(30),
	@LocationOutName varchar(30),
	@LocationInID	varchar(30),
	@ApprovedBy 	varchar(30),
	@MovedBy 	varchar(30),
	@Billable 	char(1),
	@SendComments 	varchar(255),
	@DateTimeIn 	varchar(30),
	@EndingKm 	varchar(30),
	@ReceiveComments varchar(255),
	@UserName 	varchar(30)
AS
Declare @thisDate datetime
Declare @thisDateTimeIn datetime
Declare @thisEndingKm int
Declare @thisTotalNonRevenueKm int
Declare @LocationOutID int
Declare @iCount int

Declare @nUnitNumber Integer
Declare @dOldDateTimeOut DateTime

Select @nUnitNumber = Convert(int,NULLIF(@UnitNumber, ''))
Select @dOldDateTimeOut = Convert(datetime,NULLIF(@OldDateTimeOut, ''))

Select @thisDate = getDate()

If @DateTimeIn <> ''
	Select @thisDateTimeIn = Convert(datetime,@DateTimeIn)
Else
	Select @thisDateTimeIn = (null)
If @EndingKm <> ''
	Select @thisEndingKm = Convert(int,@EndingKm)
Else
	Select @thisEndingKm = (null)

Select @LocationOutID =	(Select
				Location_ID
			From
				Location
			Where
				Location=@LocationOutName)

Update
	Vehicle_Movement
Set
	Movement_In=@thisDateTimeIn,
	Movement_Type=@MovementType,
	Sending_Location_ID = @LocationOutID,
	Receiving_Location_ID=Convert(smallint,@LocationInID),
	Km_In=@thisEndingKm,
	Km_Out=Convert(int,@StartingKm),
	Driver_Name=@MovedBy,
        Remarks_Out=@SendComments,
	Remarks_In=@ReceiveComments,
	Approver_Name=@ApprovedBy,
	Billable=Convert(bit,@Billable)
Where
	Unit_Number		=@nUnitNumber
	And Movement_Out	=@dOldDateTimeOut

If Not @thisDateTimeIn IS NULL
	Begin
		Select @thisTotalNonRevenueKm =
			(Select
				Total_Non_Revenue_Km
			From
				Vehicle
			Where
				Unit_Number=@nUnitNumber)

		If @thisTotalNonRevenueKm IS NULL
			Select @thisTotalNonRevenueKm = 0

		If @Billable = '0'
			Begin
				Select @thisTotalNonRevenueKm =
					@thisTotalNonRevenueKm + (@thisEndingKm - Convert(int,@StartingKm))
			End

		-- np - Jul 09 ,1999 - modified : If there exists and OP or CO contract for this 
		--  vehicle, no update to Current_Rental_Status and Rental_Status_Effective_On

		/* Select @iCount =	(	Select	Count(*)
						From	Vehicle_On_Contract VOC,
							Contract CON
						Where	VOC.Unit_Number = @nUnitNumber
						And	VOC.Contract_Number = CON.Contract_Number
						And	CON.Status In ('op', 'co')
					) */

		-- 15-dec-1999 CY - changed condition to check override movement instead of contract
		SELECT	@iCount = Count(*)
		FROM	Override_Movement_Completion OMC
		WHERE	OMC.Unit_Number = @nUnitNumber
		AND	OMC.Movement_Out = @dOldDateTimeOut

		If @iCount > 0
		    -- there was an override movement completion for this movement, 
		    -- so do not update the current rental status and rental status effective date
		    Begin
			Update
				Vehicle
			Set
				Current_Location_ID=Convert(smallint,@LocationInID),
				Current_Km=@thisEndingKm,
				Total_Non_Revenue_Km=@thisTotalNonRevenueKm,
				Last_Update_By=@UserName,

				Last_Update_On=@thisDate
			Where
				Unit_Number=@nUnitNumber
		    End
		Else
		    -- there was no overriding movement completion for this movement; update status
		    Begin
			Update
				Vehicle
			Set
				Current_Location_ID = Convert(smallint,@LocationInID),
				Current_Km = @thisEndingKm,
				Total_Non_Revenue_Km = @thisTotalNonRevenueKm,
				Current_Rental_Status = 'a',
				Rental_Status_Effective_On = @thisDateTimeIn, --@thisDate,
				Last_Update_By = @UserName,
				Last_Update_On = @thisDate
			Where
				Unit_Number=@nUnitNumber
		    End
	End -- If Not @thisDateTimeIn IS NULL
ELSE
	UPDATE	vehicle
	SET	Last_Update_By = @UserName,
		Last_Update_On = @thisDate
	WHERE	Unit_Number = @nUnitNumber
	
Return 1
GO
