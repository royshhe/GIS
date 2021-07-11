USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyRateLocationSet]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyRateLocationSet    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateLocationSet    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateLocationSet    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateLocationSet    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Rate_Location_Set info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyRateLocationSet]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisDate datetime
Declare @RateLocationSetID int
Declare @KmCap smallint
Declare @PerKmCharge decimal(7,2)
Declare @FlatSurcharge decimal(7,2)
Declare @DailySurcharge decimal(7,2)
Declare @AllowAllValidDropOffLocs bit
Select @thisDate = getDate()
Declare thisCursor Cursor FAST_FORWARD
For
	(Select
		Rate_Location_Set_ID,Km_Cap,Per_Km_Charge,
		Flat_Surcharge,Daily_Surcharge,Allow_All_Auth_Drop_Off_Locs
	From
		Rate_Location_Set
	Where
		Rate_ID=Convert(int,@OldRateID)
		And Termination_Date='Dec 31 2078 23:59')
Open thisCursor
Fetch Next From thisCursor Into @RateLocationSetID,
				@KmCap,
				@PerKmCharge,
				@FlatSurcharge,
				@DailySurcharge,
				@AllowAllValidDropOffLocs
While (@@Fetch_Status = 0)
	Begin
		Set Identity_Insert Rate_Location_Set On
		Insert Into Rate_Location_Set
			(Rate_ID,Effective_Date,Termination_Date,
			Rate_Location_Set_ID,Km_Cap,Per_Km_Charge,
			Flat_Surcharge,Daily_Surcharge,
			Allow_All_Auth_Drop_Off_Locs)
		Values
			(@NewRateID,@thisDate,'Dec 31 2078 23:59',
			@RateLocationSetID,@KmCap,@PerKmCharge,
			@FlatSurcharge,@DailySurcharge,
			@AllowAllValidDropOffLocs)
		Set Identity_Insert Rate_Location_Set Off
		Fetch Next From thisCursor Into @RateLocationSetID,
						@KmCap,
						@PerKmCharge,
						@FlatSurcharge,
						@DailySurcharge,
						@AllowAllValidDropOffLocs
	End

Close thisCursor
Deallocate thisCursor

Return 1














GO
