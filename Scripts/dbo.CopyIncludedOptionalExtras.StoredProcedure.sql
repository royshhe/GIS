USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyIncludedOptionalExtras]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyIncludedOptionalExtras    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedOptionalExtras    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedOptionalExtras    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyIncludedOptionalExtras    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Included_Optional_Extra info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyIncludedOptionalExtras]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - specified cursor as Fast_foward; close cursor */
	/* 8/13/99 - copy new columns included_daily_amount, included_weekly_amount */

Declare @thisDate datetime
Declare @dEndDate datetime
Declare @OptionalExtraID smallint
Declare @Quantity smallint
Declare @InclDailyAmount decimal(7,2)
Declare @InclWeeklyAmount decimal(7,2)
--
	Select 	@thisDate = getDate(),
		@dEndDate = Cast('Dec 31 2078 23:59' AS Datetime)
--	
Declare thisCursor Cursor FAST_FORWARD For
	(Select Optional_Extra_ID,
		Quantity,
		Included_Daily_Amount,
		Included_Weekly_amount
	From
		Included_Optional_Extra
	Where
		Rate_ID = Convert(int,@OldRateID)
	And 	Termination_Date = @dEndDate)
--
--
	Open thisCursor
	Fetch Next From thisCursor Into @OptionalExtraID, @Quantity,	
					@InclDailyAmount, @InclWeeklyAmount
--
	While (@@Fetch_Status = 0)
	Begin
		Insert Into Included_Optional_Extra
			(Rate_ID,
			 Effective_Date,
			 Termination_Date,
			 Optional_Extra_ID,
			 Quantity,
			 Included_Daily_Amount,
			 Included_Weekly_Amount)
		Values
			(@NewRateID,
			 @thisDate,
			 @dEndDate,
			 @OptionalExtraID,
			 @Quantity,
			 @InclDailyAmount,
			 @InclWeeklyAmount)
--
		Fetch Next From thisCursor Into @OptionalExtraID, @Quantity,	
						@InclDailyAmount, @InclWeeklyAmount

	End

Close thisCursor
Deallocate thisCursor

Return 1









GO
