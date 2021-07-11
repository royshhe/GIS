USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtrasByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctOptExtrasByCtrct
PURPOSE: To retrieve all optional extras for a contract
	except LDW, LDW Buydown, PAI, PEC, and Cargo Insurance.
AUTHOR: Don Kirkby
DATE CREATED: Aug 11, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each optional extra on the contract with details
PARAMETERS:
	CtrctNum
MOD HISTORY:
Name    Date        Comments
Don K	Sep 3 1998  Filtered out optional extras that are included in rate.
Don K	Oct 6 1998  Use optional_extra_other view
		    Filtered out history records.
CPY     Mar 11 1999  use 0/1 instead of N/Y for Included_In_Rate
*/
CREATE PROCEDURE [dbo].[GetCtrctOptExtrasByCtrct] --'3019267'
	@CtrctNum	varchar(11)
AS
	/* 3/11/99 - cpy modified - use 0/1 instead of N/Y for Included_In_Rate */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	coe.optional_extra_id,
		coe.optional_extra_id,
		coe.daily_rate,
		coe.weekly_rate,
		CONVERT(int, coe.gst_exempt),
		CONVERT(int, coe.HST2_exempt),
		CONVERT(int, coe.pst_exempt),
		coe.quantity,
		0, /* for Amount. Gets calulated by front end. */
		coe.Unit_Number,
		CONVERT(varchar, coe.rent_from, 106),
		CONVERT(varchar(5), coe.rent_from, 8),
		CONVERT(varchar, coe.rent_to, 106),
		CONVERT(varchar(5), coe.rent_to, 8),
		coe.sold_by,
		coe.Coupon_Code,
		coe.Flat_rate,
		coe.status,
		coe.Sequence,
		coe.contract_number
	  FROM	optional_extra_other oeo,
		contract_optional_extra coe
	 WHERE	coe.optional_extra_id = oeo.optional_extra_id
	   AND	coe.contract_number = @nCtrctNum
	   AND	coe.included_in_rate = '0'	-- previously 'N'
	   AND	coe.termination_date = 'Dec 31 2078 23:59'
	 ORDER
	    BY	oeo.optional_extra, coe.rent_from, coe.rent_to
	RETURN @@ROWCOUNT

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
