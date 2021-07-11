USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateIncludedOptionalExtras]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To update an optional extra included in a rate
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        	Comments
Don K	Aug 5 1999	Added IncludedDailyAmount and IncludedWeeklyAmount
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateIncludedOptionalExtras]
@RateID varchar(7),@OldID varchar(25),@NewID varchar(25),
@IncludedDailyAmount varchar(9), @IncludedWeeklyAmount varchar(9),
@Quantity varchar(25),@ChangedBy varchar(20)
AS
Declare 	@thisDate datetime
Declare	@nRateID Integer
Declare	@nOldID SmallInt

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nOldID = Convert(smallint, NULLIF(@OldID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = (getDate())

Update
	Included_Optional_Extra
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
And 	Termination_Date='Dec 31 2078 11:59PM'
And 	Optional_Extra_ID=Convert(smallint,@OldID)

Insert Into Included_Optional_Extra
	(Effective_Date,Termination_Date,Rate_ID,Optional_Extra_ID,Quantity,
	Included_Daily_Amount, Included_Weekly_Amount)
Values
	(DateAdd(second,1,@thisDate),'Dec 31 2078 11:59PM',
	@nRateID,Convert(smallint,@NewID),Convert(int,@Quantity),
	CAST(NULLIF(@IncludedDailyAmount, '') AS decimal(7,2)),
	CAST(NULLIF(@IncludedWeeklyAmount, '') AS decimal(7,2)))

Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID = @nRateID
And 	Termination_Date='Dec 31 2078 11:59PM'

Return @nRateID

















GO
