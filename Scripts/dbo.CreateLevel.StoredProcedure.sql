USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLevel]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLevel    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateLevel    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLevel    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLevel    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a list of  records into Rate_Charge_Amount table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLevel]
@RateID varchar(7),
@LevelLetter char(1),
@ChangedBy varchar(20)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @ThisDate datetime
Declare @ThisTimePeriodID int
Declare @ThisTimePeriodType varchar(25)
Declare @ThisVehicleClassID int

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @ThisDate = getDate()

Insert Into Rate_Level
	(Effective_Date,Termination_Date,Rate_ID,Rate_Level)
Values
	(@ThisDate,'Dec 31 2078 11:59PM',
	Convert(int,@RateID),@LevelLetter)

Declare VehicleClassCursor Cursor FAST_FORWARD
For
	(Select Distinct
		Rate_Vehicle_Class_ID
	From

		Rate_Vehicle_Class
	Where
		Rate_ID=Convert(int,@RateID)
		And Termination_Date='Dec 31 2078 11:59PM')

Open VehicleClassCursor
Fetch Next From VehicleClassCursor Into @ThisVehicleClassID

While (@@Fetch_Status = 0)
	Begin			
		Declare TimePeriodCursor Cursor FAST_FORWARD
		For
			(Select Distinct
				Rate_Time_Period_ID
			From
				Rate_Time_Period
			Where
				Rate_ID=Convert(int,@RateID)
				And Termination_Date='Dec 31 2078 11:59PM')

		Open TimePeriodCursor
		Fetch Next From TimePeriodCursor Into @ThisTimePeriodID

		While (@@Fetch_Status = 0)
			Begin
				Select @ThisTimePeriodType =
							(Select Distinct
								Type
							From
								Rate_Time_Period
							Where
								Rate_Time_Period_ID = @ThisTimePeriodID
								And Termination_Date='Dec 31 2078 11:59PM')
				Insert Into Rate_Charge_Amount
					(Effective_Date,Termination_Date,Rate_ID,
					Rate_Vehicle_Class_ID,Rate_Time_Period_ID,
					Rate_Level,Type,Amount)
				Values
					(@ThisDate,'Dec 31 2078 11:59PM',
					Convert(int,@RateID),@ThisVehicleClassID,
					@ThisTimePeriodID,@LevelLetter,
					@ThisTimePeriodType,99999.99)
				Fetch Next From TimePeriodCursor Into @ThisTimePeriodID
			End

		Close TimePeriodCursor
		Deallocate TimePeriodCursor

		Fetch Next From VehicleClassCursor Into @ThisVehicleClassID
	End

Close VehicleClassCursor
Deallocate VehicleClassCursor

Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@ThisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Return 1















GO
