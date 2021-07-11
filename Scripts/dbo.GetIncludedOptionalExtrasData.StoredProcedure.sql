USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedOptionalExtrasData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To retrieve a list of optional extras included in a rate.
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added price and included amounts.
*/
CREATE PROCEDURE [dbo].[GetIncludedOptionalExtrasData]
@RateID varchar(20)
AS
Set Rowcount 2000

DECLARE	@dtNow datetime
SELECT	@dtNow = GETDATE()

Select
	IOE.Optional_Extra_ID,
	IOE.Optional_Extra_ID,
	oep.daily_rate,
	ioe.included_daily_amount,
	oep.weekly_rate,
	ioe.included_weekly_amount,
	IOE.Quantity
From
	Included_Optional_Extra IOE
JOIN	Optional_Extra OE
  ON	IOE.Optional_Extra_ID = OE.Optional_Extra_ID
LEFT
JOIN	optional_extra_price oep
  ON	oe.optional_extra_id = oep.optional_extra_id
 AND	@dtNow
	BETWEEN oep.optional_extra_valid_from AND ISNULL(oep.valid_to, @dtNow)
Where
	IOE.Rate_ID = Convert(int, @RateID)
	And IOE.Termination_Date = 'Dec 31 2078 11:59PM'
Order By
	OE.Optional_Extra

Return 1








GO
