USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateRateTimePeriod]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateRateTimePeriod    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateRateTimePeriod    Script Date: 2/16/99 2:05:39 PM ******/
/*
PURPOSE: To insert a record into Rate_Time_Period table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateRateTimePeriod]
@RateID varchar(7),
@TimePeriod varchar(25),
@TimePeriodStart varchar(25),
@TimePeriodEnd varchar(25),
@KmCap varchar(25),
@TimePeriodType varchar(25),
@ChangedBy varchar(35)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisDate datetime
Declare @ThisLevel char(1)
Declare @ThisVehicleClassID int
Declare @ThisTimePeriodID int
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()
Insert Into Rate_Time_Period
	(Effective_Date,
	Termination_Date,
	Rate_ID,
	Type,
	Time_Period,
	Time_Period_Start,
	Time_Period_End,
	Km_Cap)
Values
	(@thisDate,
	'Dec 31 2078 11:59PM',
	Convert(int, @RateID),
	@TimePeriodType,
	@TimePeriod,
	Convert(smallint, @TimePeriodStart),
	Convert(smallint, @TimePeriodEnd),
	Convert(smallint, NULLIF(@KmCap, '')))
Select @ThisTimePeriodID = @@IDENTITY
Declare LevelCursor Cursor FAST_FORWARD
For
	(Select Distinct
		Rate_Level
	From
		Rate_Level
	Where
		Rate_ID=Convert(int,@RateID)
		And Termination_Date='Dec 31 2078 11:59PM')
	
Open LevelCursor
Fetch Next From LevelCursor Into @ThisLevel
While (@@Fetch_Status = 0)
	Begin
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
				Insert Into Rate_Charge_Amount
					(Effective_Date,Termination_Date,Rate_ID,
					Rate_Vehicle_Class_ID,Rate_Time_Period_ID,
					Rate_Level,Type,Amount)
				Values
					(@thisDate,'Dec 31 2078 11:59PM',
					Convert(int,@RateID),@ThisVehicleClassID,
					@ThisTimePeriodID,@ThisLevel,
					@TimePeriodType,99999.99)
				Fetch Next From VehicleClassCursor Into @ThisVehicleClassID
			End
		Close VehicleClassCursor
		Deallocate VehicleClassCursor

		Fetch Next From LevelCursor Into @ThisLevel
	End

Close LevelCursor
Deallocate LevelCursor

Update
	Vehicle_Rate
Set
	Last_Changed_By = @ChangedBy,
	Last_Changed_On = @thisDate
Where
	Rate_ID = Convert(int, @RateID)
	And Termination_Date = 'Dec 31 2078 11:59PM'

Return @ThisTimePeriodID















GO
