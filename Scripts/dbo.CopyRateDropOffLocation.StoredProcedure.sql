USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyRateDropOffLocation]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyRateDropOffLocation    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateDropOffLocation    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateDropOffLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateDropOffLocation    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Rate_Drop_Off_Location info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyRateDropOffLocation]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisDate datetime
Declare @RateLocationSetID int
Declare @LocationID smallint
Declare @IncludedInRate bit
Select @thisDate = getDate()
Declare thisCursor Cursor FAST_FORWARD
For
	(Select
		Rate_Location_Set_ID,Location_ID,Included_In_Rate
	From
		Rate_Drop_Off_Location
	Where
		Rate_ID=Convert(int,@OldRateID)
		And Termination_Date='Dec 31 2078 23:59')
Open thisCursor
Fetch Next From thisCursor Into @RateLocationSetID,
				@LocationID,
				@IncludedInRate
While (@@Fetch_Status = 0)
	Begin
		Insert Into Rate_Drop_Off_Location
			(Rate_ID,Effective_Date,Termination_Date,
			Rate_Location_Set_ID,Location_ID,Included_In_Rate)
		Values
			(@NewRateID,@thisDate,'Dec 31 2078 23:59',
			@RateLocationSetID,@LocationID,@IncludedInRate)
		Fetch Next From thisCursor Into @RateLocationSetID,
						@LocationID,
						@IncludedInRate
	End

Close thisCursor
Deallocate thisCursor

Return 1














GO
