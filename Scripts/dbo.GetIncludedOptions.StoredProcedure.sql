USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedOptions]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To retrieve a list of optional extras.
AUTHOR: ?
DATE CREATED: ?
MOD HISTORY:
Name    Date        Comments
Don K	Aug 5 1999  Added price information.
*/
CREATE PROCEDURE [dbo].[GetIncludedOptions]
AS
Set Rowcount 2000

DECLARE	@dtNow datetime
SELECT	@dtNow = GETDATE()

Select
	oe.Optional_Extra,
	oe.Optional_Extra_ID,
	oe.Maximum_Quantity,
	oe.Type,
	oep.daily_rate,
	oep.weekly_rate
From	Optional_Extra oe
LEFT
JOIN	optional_extra_price oep
  ON	oe.optional_extra_id = oep.optional_extra_id
 AND	@dtNow
	BETWEEN oep.optional_extra_valid_from AND ISNULL(oep.valid_to, @dtNow)
Where
	oe.Delete_Flag=0
Order By
	oe.Optional_Extra
	
Return 1







GO
