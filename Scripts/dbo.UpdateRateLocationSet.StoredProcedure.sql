USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRateLocationSet]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRateLocationSet    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateLocationSet    Script Date: 2/16/99 2:05:44 PM ******/
/*
PURPOSE: To update a record in Rate_Location_Set table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateRateLocationSet]
@RateID varchar(7),
@RateLocationSetID varchar(25),
@AllowAll varchar(25),
@KmCap varchar(25),
@KmCharge varchar(25),
@FlatSurcharge varchar(25),
@DailySurcharge varchar(25),
@ChangedBy varchar(20),
@OverrideFlag char(1)
AS
Declare @thisDate datetime
Declare @thisKmCharge decimal(7,2)

Declare	@nRateID Integer
Declare	@nRateLocationSetID SmallInt

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nRateLocationSetID = Convert(smallint, NULLIF(@RateLocationSetID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = getDate()

If @KmCharge <> ''
	Select @thisKmCharge = Convert(decimal(7,2), @KmCharge)

Update
	Rate_Location_Set
Set
	Termination_Date = @thisDate
Where
	Rate_ID = @nRateID
And 	Termination_Date = 'Dec 31 2078 11:59PM'
And 	Rate_Location_Set_ID = @nRateLocationSetID

Set Identity_Insert Rate_Location_Set On

--Create a record for Rate Location Set, the current has been expired
Insert Into Rate_Location_Set
	(Effective_Date,
	Termination_Date,
	Rate_ID,
	Rate_Location_Set_ID,
	Km_Cap,
	Per_Km_Charge,
	Flat_Surcharge,
	Daily_Surcharge,
	Allow_All_Auth_Drop_Off_Locs,
	Override_Km_Cap_Flag)
Values
	(DateAdd(second,1,@thisDate),
	'Dec 31 2078 11:59PM',
	@nRateID,
	@nRateLocationSetID,
	Convert(smallint, NULLIF(@KmCap, '')),
	@thisKmCharge,
	Convert(decimal(7,2), @FlatSurcharge),
	Convert(decimal(7,2), @DailySurcharge),
	Convert(bit, @AllowAll),
	Convert(bit, @OverrideFlag))

Set Identity_Insert Rate_Location_Set Off

--update vehicle rate audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By = @ChangedBy,
	Last_Changed_On = @thisDate
Where
	Rate_ID = @nRateID
And 	Termination_Date = 'Dec 31 2078 11:59PM'

Return @nRateLocationSetID














GO
