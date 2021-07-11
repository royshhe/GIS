USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateRateLocationSet]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To insert a record into Rate_Location_Set table.
MOD HISTORY:
Name    Date        Comments
CPY	Jan 12 2000	Save the @@IDENTITY value right after the insert
*/
CREATE PROCEDURE [dbo].[CreateRateLocationSet]
	@RateID 	varchar(7),
	@AllowAll 	varchar(25),
	@KmCap 		varchar(25),
	@KmCharge 	varchar(25),
	@FlatSurcharge 	varchar(25),
	@DailySurcharge varchar(25),
	@ChangedBy 	varchar(20),
	@OverrideFlag 	char(1)
AS
Declare @thisDate datetime
Declare @thisKmCharge decimal(7,2)
DECLARE @iRateLocSetId Int

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()
If @KmCharge <> ''
	Select @thisKmCharge = Convert(decimal(7,2), @KmCharge)
Insert Into Rate_Location_Set
	(Effective_Date,
	Termination_Date,
	Rate_ID,
	Km_Cap,
	Per_Km_Charge,
	Flat_Surcharge,
	Daily_Surcharge,
	Allow_All_Auth_Drop_Off_Locs,
	Override_Km_Cap_Flag)
Values
	(@thisDate,
	'Dec 31 2078 11:59PM',
	Convert(int, @RateID),
	Convert(smallint, NULLIF(@KmCap, '')),
	@thisKmCharge,
	Convert(decimal(7,2), @FlatSurcharge),
	Convert(decimal(7,2), @DailySurcharge),
	Convert(bit, @AllowAll),
	Convert(bit, @OverrideFlag))

SELECT	@iRateLocSetId = @@IDENTITY

-- update vehicle audit info.
Update
	Vehicle_Rate
Set
	Last_Changed_By = @ChangedBy,
	Last_Changed_On = @thisDate
Where
	Rate_ID = Convert(int, @RateID)
	And Termination_Date = 'Dec 31 2078 11:59PM'

Return @iRateLocSetId














GO
