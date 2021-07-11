USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRestrictions]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRestrictions    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRestrictions    Script Date: 2/16/99 2:05:44 PM ******/
/*
PURPOSE: To update a record in Rate_Restriction table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateRestrictions]
@RateID varchar(7),
@OldRestrictionID varchar(25),
@NewRestrictionID varchar(25),
@NumberOfHours varchar(25),
@NumberOfDays varchar(25),
@TimeOfDay varchar(25),
@ChangedBy varchar(20)
AS
Declare @thisDate datetime
Declare @nRateID Integer
Declare @nOldRestrictionID SmallInt

Select @nRateID = Convert(int, NULLIF(@RateID, ''))
Select @nOldRestrictionID = Convert(smallint, NULLIF(@OldRestrictionID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = (getDate())

-- Set the current Rate Restriction to expired
Update
	Rate_Restriction
Set
	Termination_Date = @thisDate
Where
	Rate_ID=@nRateID
	And Termination_Date = 'Dec 31 2078 11:59PM'
	And Restriction_ID = @nOldRestrictionID

--Create a record in Rate Restriction , the cuurent has been expired
Insert Into Rate_Restriction
	(Effective_Date,
	Termination_Date,
	Rate_ID,
	Restriction_ID,
	Number_Of_Hours,
	Number_Of_Days,
	Time_Of_Day)
Values
	(DateAdd(second, 1, @thisDate),
	'Dec 31 2078 11:59PM',
	Convert(int, @RateID),
	Convert(smallint, @NewRestrictionID),
	Convert(int, NULLIF(@NumberOfHours, '')),
	Convert(int, NULLIF(@NumberOfDays, '')),
	@TimeOfDay)

--update audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By = @ChangedBy,
	Last_Changed_On = @thisDate
Where
	Rate_ID = @nRateID
	And Termination_Date = 'Dec 31 2078 11:59PM'
Return @nRateID















GO
