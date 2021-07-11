USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleMovement]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Start and possibly complete a vehicle movement.
AUTHOR: ?
MOD HISTORY:
Name    Date        	Comments
Don K	Jun 3 1999  	After a complete move, set the vehicle status to 'a'
			because it might not be 'a' to start with.
Don K	Jun 4 1999  	Changed to use ANSI null comparisons
CPY	Dec 15 1999	- when updating rental_status_effective_on, use 
			  the Movement Out date instead of getdate()
CPY	Jan 24 2000	- update rental_status_effective_on when completing movement
*/
CREATE PROCEDURE [dbo].[CreateVehicleMovement]
	@UnitNumber 	varchar(30),
	@NOTUSED	varchar(30),
	@NewDateTimeOut	varchar(30),
	@MovementType	varchar(30),
	@StartingKm	varchar(30),
	@LocationOutName varchar(30),
	@LocationInID	varchar(30),
	@ApprovedBy	varchar(30),
	@MovedBy	varchar(30),
	@Billable	char(1),
	@SendComments	varchar(255),
	@DateTimeIn	varchar(30),
	@EndingKm	varchar(30),
	@ReceiveComments varchar(255),
	@UserName 	varchar(30)
AS
Declare @thisDate datetime
Declare @thisDateTimeIn datetime
Declare @thisEndingKm int
Declare @thisTotalNonRevenueKm int
Declare @LocationOutID int
DECLARE	@dNewDateTimeOut Datetime

Select @thisDate = getDate(),
	@dNewDateTimeOut = Convert(Datetime, NULLIF(@NewDateTimeOut,''))

If @DateTimeIn <> ''
        Select @thisDateTimeIn = Convert(datetime,@DateTimeIn)
Else
        Select @thisDateTimeIn = (null)
If @EndingKm <> ''
        Select @thisEndingKm = Convert(int,@EndingKm)
Else
        Select @thisEndingKm = (null)
Select @LocationOutID = (Select
                                Location_ID
                        From
                                Location
                        Where
                                Location=@LocationOutName)
Insert Into Vehicle_Movement
        (Unit_Number, Movement_In, 
	 Movement_Type, Sending_Location_ID, Movement_Out, 
	 Receiving_Location_ID, Km_In, 
	 Km_Out, Driver_Name,Remarks_Out, 
	 Remarks_In, Approver_Name, Billable)
values
        (Convert(int,@UnitNumber), @thisDateTimeIn,
        @MovementType, @LocationOutID, @dNewDateTimeOut, 
	Convert(smallint,@LocationInID), @thisEndingKm,
        Convert(int,@StartingKm), @MovedBy, @SendComments,
        @ReceiveComments, @ApprovedBy, Convert(bit,@Billable))
If @thisDateTimeIn IS NOT NULL
/* Car is in new location, movement is done */
        Begin
                Select @thisTotalNonRevenueKm =
                        (Select
                                Total_Non_Revenue_Km
                        From
                                Vehicle
                        Where
                                Unit_Number=Convert(int,@UnitNumber))
                If @thisTotalNonRevenueKm IS NULL
                        Select @thisTotalNonRevenueKm = 0
                If @Billable = '0'
                        Begin
                                Select @thisTotalNonRevenueKm =
                                        @thisTotalNonRevenueKm + (@thisEndingKm - Convert(int,@StartingKm))
                        End

                Update
                        Vehicle
                Set
                        Current_Rental_Status='a',
			Rental_Status_Effective_On = @thisDateTimeIn,
                        Current_Location_ID=Convert(smallint,@LocationInID),
                        Current_Km=@thisEndingKm,
                        Total_Non_Revenue_Km=@thisTotalNonRevenueKm,
                        Last_Update_By=@UserName,
                        Last_Update_On=@thisDate
                Where
                        Unit_Number=Convert(int,@UnitNumber)
        End
Else
/* Vehicle In Transit */
        Begin
		--15-dec-1999 CY - use Movement Out date when updating Rental_Status_Effective_On
                Update
                        Vehicle
                Set
                        Current_Rental_Status='c',
                        Rental_Status_Effective_On=@dNewDateTimeOut,
                        Last_Update_By=@UserName,
                        Last_Update_On=@thisDate
                Where
                        Unit_Number=Convert(int,@UnitNumber)
        End
Return 1
















GO
