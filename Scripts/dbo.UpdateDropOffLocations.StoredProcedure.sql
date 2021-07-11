USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDropOffLocations]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/****** Object:  Stored Procedure dbo.UpdateDropOffLocations    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDropOffLocations    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDropOffLocations    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDropOffLocations    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Rate_Drop_Off_Location table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateDropOffLocations]
	@RateID varchar(25),
	@RateLocationSetID varchar(25),
	@OldLocationId varchar(25),
	@NewLocationId varchar(25),
	@IncludeInRate char(1),
	@ChangedBy varchar(20)
AS
	/* 10/26/99 - @OldLocation param changed to @OldLocationId, 
			@NewLocation param changed to @NewLocationId 
			(pass ID instead of name) */

Declare @thisDate datetime
Declare @iOldLocationId smallint,
	@iNewLocationId smallint,
	@iRateId Int,
	@iRateLocationSetID Int,
	@dTermDate Datetime

	If @ChangedBy = ''
		Select @ChangedBy = 'No name provided'

	Select 	@thisDate = getDate(),
		@iOldLocationId = Convert(SmallInt, NULLIF(@OldLocationId,'')),
		@iNewLocationId = Convert(SmallInt, NULLIF(@NewLocationId,'')),
		@iRateId = Convert(Int, NULLIF(@RateID,'')),
		@iRateLocationSetID = Convert(int, NULLIF(@RateLocationSetID,'')),
		@dTermDate = Convert(Datetime, 'Dec 31 2078 11:59PM')

	Update 	Rate_Drop_Off_Location
	Set	Termination_Date = @thisDate
	Where	Rate_ID = @iRateId
	And 	Location_ID = @iOldLocationId
	And 	Rate_Location_Set_ID = @iRateLocationSetID
	And 	Termination_Date = @dTermDate

	--Create a new Rate_Drop_Off_Location record because the current one has expired
	Insert Into Rate_Drop_Off_Location
		(Effective_Date,
		 Termination_Date,
		 Location_ID,
		 Rate_ID,
		 Rate_Location_Set_ID,
		 Included_In_Rate)
	Values
		(DateAdd(second,1,@thisDate),
		 @dTermDate,
		 @iNewLocationId,
		 @iRateId,
		 @iRateLocationSetID,
		 Convert(bit,@IncludeInRate))

	-- Update Vehicle Rate Audit Info
	Update	Vehicle_Rate
	Set	Last_Changed_By = @ChangedBy,
		Last_Changed_On = @thisDate
	Where	Rate_ID = @iRateId
	And 	Termination_Date = @dTermDate

	Return @iRateId














GO
