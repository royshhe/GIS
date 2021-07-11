USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyRateRestriction]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyRateRestriction    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateRestriction    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateRestriction    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateRestriction    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Rate_Restriction info from the current rate into the new rate.
MOD HISTORY:
Name    Date        	Comments
CPY	5/11/99 	- cpy modified - specified cursor as Fast_foward; close cursor 
CPY	Jan 14 2000	- changed declaration of @NumberOfDays and @NumberOfHours from
			  tinyint to smallint
*/
CREATE PROCEDURE [dbo].[CopyRateRestriction]
@OldRateID int,
@NewRateID int
AS

Declare @thisDate datetime
Declare @RestrictionID smallint
Declare @TimeOfDay char(5)
Declare @NumberOfDays Smallint
Declare @NumberOfHours Smallint
Select @thisDate = getDate()
Declare thisCursor Cursor FAST_FORWARD
For
	(Select
		Restriction_ID,Time_Of_Day,Number_Of_Days,Number_Of_Hours
	From
		Rate_Restriction
	Where
		Rate_ID=@OldRateID
		And Termination_Date='Dec 31 2078 23:59')
Open thisCursor
Fetch Next From thisCursor Into @RestrictionID,
				@TimeOfDay,
				@NumberOfDays,
				@NumberOfHours
While (@@Fetch_Status = 0)
	Begin
		Insert Into Rate_Restriction
			(Rate_ID,Effective_Date,Termination_Date,
			Restriction_ID,Time_Of_Day,Number_Of_Days,
			Number_Of_Hours)
		Values
			(@NewRateID,@thisDate,'Dec 31 2078 23:59',
			@RestrictionID,@TimeOfDay,@NumberOfDays,
			@NumberOfHours)
		Fetch Next From thisCursor Into @RestrictionID,
						@TimeOfDay,
						@NumberOfDays,
						@NumberOfHours
	End

Close thisCursor
Deallocate thisCursor

Return 1















GO
