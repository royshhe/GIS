USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateIncludedOptionalExtras]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To create an optional extra included in a rate
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added IncludedDailyAmount and IncludedWeeklyAmount
*/
CREATE PROCEDURE [dbo].[CreateIncludedOptionalExtras]
	@RateID varchar(7),
	@NewID varchar(25),
	@IncludedDailyAmount varchar(9),
	@IncludedWeeklyAmount varchar(9),
	@Quantity varchar(25),
	@ChangedBy varchar(20)
AS
Declare @thisDate datetime
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getdate()
Insert Into Included_Optional_Extra
	(
	Effective_Date,
	Termination_Date,
	Rate_ID,
	Optional_Extra_ID,
	included_daily_amount,
	included_weekly_amount,
	Quantity)
Values
	(
	@thisDate,
	'Dec 31 2078 11:59PM',
	Convert(int,@RateID),
	Convert(smallint,@NewID),
	CAST(NULLIF(@IncludedDailyAmount, '') AS decimal(7,2)),
	CAST(NULLIF(@IncludedWeeklyAmount, '') AS decimal(7,2)),
	Convert(int,@Quantity)
	)
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Return 1














GO
