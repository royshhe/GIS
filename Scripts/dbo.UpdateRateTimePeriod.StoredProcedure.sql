USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRateTimePeriod]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRateTimePeriod    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateTimePeriod    Script Date: 2/16/99 2:05:44 PM ******/
/*
PURPOSE: To update a record in Rate_Time_Period table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateRateTimePeriod]
@RateID varchar(7),
@RateTimePeriodID varchar(25),
@TimePeriod varchar(25),
@TimePeriodStart varchar(25),
@TimePeriodEnd varchar(25),
@KmCap varchar(25),
@TimePeriodType varchar(25),
@ChangedBy varchar(35)
AS
Declare @thisDate datetime

Declare	@nRateID Integer
Declare	@nRateTimePeriodID Integer

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nRateTimePeriodID = Convert(int, NULLIF(@RateTimePeriodID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = (getDate())

--Set the current Rate Time Period to expired
Update
	Rate_Time_Period
Set
	Termination_Date = @thisDate
Where
	Rate_ID = @nRateID
And 	Rate_Time_Period_ID = @nRateTimePeriodID
And 	Termination_Date = 'Dec 31 2078 11:59PM'

Set Identity_Insert Rate_Time_Period On

--Create a record for Rate Time Period, the current has been expired
Insert Into Rate_Time_Period
	(Effective_Date,
	Termination_Date,
	Rate_ID,
	Rate_Time_Period_ID,
	Type,
	Time_Period,
	Time_Period_Start,
	Time_Period_End,
	Km_Cap)
Values
	(DateAdd(second,1,@thisDate),
	'Dec 31 2078 11:59PM',
	@nRateID,
	@nRateTimePeriodID,
	@TimePeriodType,
	@TimePeriod,
	Convert(smallint, @TimePeriodStart),
	Convert(smallint, @TimePeriodEnd),
	Convert(smallint, NULLIF(@KmCap, '')))

Set Identity_Insert Rate_Time_Period Off

--Update the vehicle rate audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By = @ChangedBy,
	Last_Changed_On = @thisDate
Where
	Rate_ID = @nRateID
And 	Termination_Date = 'Dec 31 2078 11:59PM'

Return @nRateTimePeriodID














GO
