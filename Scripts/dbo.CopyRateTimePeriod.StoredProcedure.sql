USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyRateTimePeriod]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyRateTimePeriod    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateTimePeriod    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateTimePeriod    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateTimePeriod    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Rate_Time_Period info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyRateTimePeriod]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisDate datetime
Declare @RateTimePeriodID int
Declare @TimePeriod char(10)
Declare @TimePeriodStart smallint
Declare @TimePeriodEnd smallint
Declare @KmCap smallint
Declare @Type char(7)
Select @thisDate = getDate()
Declare thisCursor Cursor FAST_FORWARD
For
	(Select
		Rate_Time_Period_ID,Time_Period,Time_Period_Start,
		Time_Period_End,Km_Cap,Type
	From
		Rate_Time_Period
	Where
		Rate_ID=Convert(int,@OldRateID)
		And Termination_Date='Dec 31 2078 23:59')
Open thisCursor
Fetch Next From thisCursor Into @RateTimePeriodID,
				@TimePeriod,
				@TimePeriodStart,
				@TimePeriodEnd,
				@KmCap,
				@Type
While (@@Fetch_Status = 0)
	Begin
		Set Identity_Insert Rate_Time_Period On
		Insert Into Rate_Time_Period

			(Rate_ID,Effective_Date,Termination_Date,
			Rate_Time_Period_ID,Time_Period,
			Time_Period_Start,Time_Period_End,Km_Cap,Type)
		Values
			(@NewRateID,@thisDate,'Dec 31 2078 23:59',
			@RateTimePeriodID,@TimePeriod,@TimePeriodStart,
			@TimePeriodEnd,@KmCap,@Type)
		Set Identity_Insert Rate_Time_Period Off
		Fetch Next From thisCursor Into @RateTimePeriodID,
						@TimePeriod,
						@TimePeriodStart,
						@TimePeriodEnd,
						@KmCap,
						@Type
	End

Close thisCursor
Deallocate thisCursor

Return 1















GO
