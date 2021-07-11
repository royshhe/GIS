USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtraTypeByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypeByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypeByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypeByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypeByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctOptExtraTypeByCtrct
PURPOSE: To retrieve the coverage of a given type attached to a
	contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 20, 1998
CALLED BY: Contract
REQUIRES:
ENSURES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctOptExtraTypeByCtrct]
	@CtrctNum	varchar(11),
	@Type		varchar(20)
AS
	/* 10/14/99 - do type conversion and nullif outside of SQL statement */

	DECLARE	@iCtrctNum	Int

	SELECT 	@iCtrctNum = CONVERT(int, NULLIF(@CtrctNum, '')),
		@Type = NULLIF(@Type, '')

	SELECT	coe.included_in_rate,
		coe.included_in_rate,
		coe.daily_rate,
		coe.weekly_rate,
		CONVERT(int, coe.gst_exempt),
		CONVERT(int, coe.pst_exempt),
		CONVERT(varchar, coe.rent_from, 106),
		CONVERT(varchar(5), coe.rent_from, 8),
		CONVERT(varchar, coe.rent_to, 106),
		CONVERT(varchar(5), coe.rent_to, 8),
		oe.optional_extra_id
	  FROM	optional_extra oe,
		contract_optional_extra coe
	 WHERE	oe.type = @Type
	   AND	coe.optional_extra_id = oe.optional_extra_id
	   AND	coe.contract_number = @iCtrctNum
	   AND	coe.termination_date = 'Dec 31 2078 23:59'
	RETURN @@ROWCOUNT
















GO
