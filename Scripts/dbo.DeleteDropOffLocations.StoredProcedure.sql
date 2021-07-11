USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDropOffLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteDropOffLocations    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDropOffLocations    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDropOffLocations    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteDropOffLocations    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record from Rate_Drop_Off_Location and Vehicle_Rate table by setting the Termination Date
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteDropOffLocations]
	@RateID varchar(25),
	@RateLocationSetID varchar(25),
	@LocationId varchar(25),
	@ChangedBy varchar(20)
AS
	/* 10/26/99 - @Location param changed to @LocationId (pass ID instead of name) */

Declare @thisDate datetime
Declare @iLocationId smallint,
	@iRateId Int,
	@iRateLocationSetID Int,
	@dTermDate Datetime

	If @ChangedBy = ''
		Select @ChangedBy = 'No name provided'

	Select 	@thisDate = getDate(),
		@iLocationId = Convert(SmallInt, NULLIF(@LocationId,'')),
		@iRateId = Convert(Int, NULLIF(@RateID,'')),
		@iRateLocationSetID = Convert(int, NULLIF(@RateLocationSetID,'')),
		@dTermDate = Convert(Datetime, 'Dec 31 2078 11:59PM')

	Update 	Rate_Drop_Off_Location
	Set	Termination_Date = @thisDate
	Where	Rate_ID = @iRateId
	And 	Location_ID = @iLocationId
	And 	Rate_Location_Set_ID = @iRateLocationSetID
	And 	Termination_Date = @dTermDate

	Update	Vehicle_Rate
	Set	Last_Changed_By = @ChangedBy,
		Last_Changed_On = @thisDate
	Where	Rate_ID = @iRateId
	And 	Termination_Date = @dTermDate

	Return @iLocationId














GO
