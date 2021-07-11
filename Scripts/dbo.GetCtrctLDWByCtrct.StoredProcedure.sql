USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctLDWByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctLDWByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctLDWByCtrct
PURPOSE: To retrieve the LDW attached to a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 20, 1998
CALLED BY: Contract
REQUIRES:
ENSURES:
MOD HISTORY:
Name    Date        Comments
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCtrctLDWByCtrct]
	@CtrctNum	varchar(11)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	coe.optional_extra_id,
		coe.included_in_rate,
		coe.included_in_rate,
		coe.daily_rate,
		coe.weekly_rate,
		CONVERT(int, coe.gst_exempt),
		CONVERT(int, coe.HST2_exempt),
		CONVERT(int, coe.pst_exempt),
		CONVERT(varchar, coe.rent_from, 106),
		CONVERT(varchar(5), coe.rent_from, 8),
		CONVERT(varchar, coe.rent_to, 106),
		CONVERT(varchar(5), coe.rent_to, 8)
	  FROM	optional_extra oe,
		contract_optional_extra coe
	 WHERE	oe.type = 'LDW'
	   AND	coe.optional_extra_id = oe.optional_extra_id
	   AND	coe.contract_number = @nCtrctNum
	   AND	coe.termination_date = '31 Dec 2078 23:59'
	RETURN @@ROWCOUNT
GO
