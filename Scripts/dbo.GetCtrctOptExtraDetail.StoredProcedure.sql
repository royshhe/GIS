USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtraDetail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctOptExtraDetail    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraDetail    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraDetail    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraDetail    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctOptExtraDetail
PURPOSE: To retrieve details for an optional extra
AUTHOR: Don Kirkby
DATE CREATED: Aug 11, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns daily and weekly charges as well as the maximum quantity
PARAMETERS:
	OptExtraId
	ValidOn: The date that the charges apply to
MOD HISTORY:
Name    Date        Comments
*/
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCtrctOptExtraDetail]
	@OptExtraID	varchar(10),
	@ValidOn 	varchar(24)
AS
	DECLARE	@nOptExtraID SmallInt
	DECLARE 	@dValidOn datetime

	SELECT	@nOptExtraID = CONVERT(smallint, NULLIF(@OptExtraID, ''))
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	oep.daily_rate,
		oep.weekly_rate,
		oe.maximum_quantity
	  FROM	optional_extra_price oep,
		optional_extra oe
	 WHERE	oep.optional_extra_id = oe.optional_extra_id
	   AND	oe.optional_extra_id= @nOptExtraID

	   AND	oe.delete_flag = 0
	   AND	@dValidOn
		BETWEEN oep.optional_extra_valid_from
		    AND ISNULL(oep.valid_to, @dValidOn)
	RETURN @@ROWCOUNT




GO
