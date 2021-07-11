USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateDropOffLocations]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/****** Object:  Stored Procedure dbo.CreateDropOffLocations    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateDropOffLocations    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateDropOffLocations    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateDropOffLocations    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Rate_Drop_Off_Location table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateDropOffLocations]
	@RateID varchar(25),
	@RateLocationSetID varchar(25),
	@LocationId varchar(25),
	@IncludeInRate char(1),
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

	Insert Into Rate_Drop_Off_Location
		(Effective_Date,
		 Termination_Date,
		 Location_ID,
		 Rate_ID,
		 Rate_Location_Set_ID,
		 Included_In_Rate)
	Values
		(@thisDate,
		 @dTermDate,
		 @iLocationId,
		 @iRateId,
		 @iRateLocationSetID,
		 Convert(bit,@IncludeInRate))

	-- Update the audit info
	Update	Vehicle_Rate
	Set	Last_Changed_By = @ChangedBy,
		Last_Changed_On = @thisDate
	Where	Rate_ID = @iRateId
	And 	Termination_Date = @dTermDate

	Return 1














GO
