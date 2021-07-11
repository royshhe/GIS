USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRateChargeAmount]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRateChargeAmount    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateChargeAmount    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateChargeAmount    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateChargeAmount    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Rate_Charge_Amount table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateRateChargeAmount]
@RateID varchar(7),
@Level varchar(25),
@TimePeriod varchar(25),
@TimePeriodStart varchar(25),
@ClassName varchar(25),
@Amount varchar(25),
@TimePeriodType varchar(25),
@ChangedBy varchar(20)
AS
Declare @thisDate datetime
Declare @thisRateTimePeriodID int
Declare @ThisRateVehicleClassID int
Declare @ThisVehicleClassCode char(1)

Declare	@nRateID Integer
Declare	@nTimePeriodStart SmallInt

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nTimePeriodStart = Convert(smallint, NULLIF(@TimePeriodStart, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = getDate()

Select @ThisVehicleClassCode =
		(Select Distinct
			Vehicle_Class_Code
		From
			Vehicle_Class
		Where
			Vehicle_Class_Name = @ClassName)

Select @ThisRateVehicleClassID =
		(Select Distinct
			Rate_Vehicle_Class_ID
		From
			Rate_Vehicle_Class
		Where
			Rate_ID = @nRateID
		And 	Termination_Date = 'Dec 31 2078 11:59PM'
		And 	Vehicle_Class_Code = @ThisVehicleClassCode)

If @TimePeriod = 'Flat'
	Select @ThisRateTimePeriodID =
		(Select Distinct
			Rate_Time_Period_ID
		From
			Rate_Time_Period
		Where
			Rate_ID = @nRateID
		And 	Termination_Date = 'Dec 31 2078 11:59PM'
		And 	Time_Period = @TimePeriod
		And 	Type = @TimePeriodType)
Else
	Select @ThisRateTimePeriodID =
		(Select Distinct
			Rate_Time_Period_ID
		From
			Rate_Time_Period
		Where
			Rate_ID = @nRateID
		And 	Termination_Date = 'Dec 31 2078 11:59PM'
		And 	Time_Period = @TimePeriod
		And 	Type = @TimePeriodType
		And 	Time_Period_Start = @nTimePeriodStart)

Update
	Rate_Charge_Amount
Set
	Termination_Date=@thisDate
Where
	Rate_ID=@nRateID
And 	Rate_Level=@Level
And 	Rate_Vehicle_Class_ID=@ThisRateVehicleClassID
And 	Rate_Time_Period_ID=@ThisRateTimePeriodID
And 	Type=@TimePeriodType
And 	Termination_Date='Dec 31 2078 11:59PM'

--Create a record for Rate Charge Amount because the current has been expired
Insert Into Rate_Charge_Amount
	(Effective_Date,Termination_Date,Rate_ID,Rate_Level,Rate_Vehicle_Class_ID,
	Rate_Time_Period_ID,Type,Amount)
Values
	(DateAdd(second,1,@thisDate), 'Dec 31 2078 11:59PM',
	@nRateID, @Level, @ThisRateVehicleClassID,@ThisRateTimePeriodID,
	@TimePeriodType,Convert(decimal(9,2),@Amount))

--Update Vehicle Rate audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=@nRateID
And 	Termination_Date='Dec 31 2078 11:59PM'

Return @nRateID















GO
