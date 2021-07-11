USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctLDWDetail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctLDWDetail    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWDetail    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWDetail    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWDetail    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctLDWDetail
PURPOSE: To retrieve the cost of a specific LDW
AUTHOR: Don Kirkby
DATE CREATED: Aug 10, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns deductible, daily rate, and weekly rate
PARAMETERS:
	VehicleClassCode
	OptExtraId
	ValidOn: Date to get the rates for.
MOD HISTORY:
Name    Date        Comments
*/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetCtrctLDWDetail]
	@VehicleClassCode  	varchar(1),
	@OptExtraId  		varchar(20),
	@ValidOn 		varchar(24)
AS
	DECLARE 	@dValidOn datetime
	DECLARE	@nOptExtraId SmallInt
 
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	@nOptExtraId  = CONVERT(smallint, NULLIF(@OptExtraId, ''))

	SELECT	ldw_deductible,
		daily_rate,
		weekly_rate,
		CONVERT(int, gst_exempt),
		CONVERT(int, HST2_exempt),
		CONVERT(int, pst_exempt)
	  FROM	ldw_deductible ld,
		optional_extra_price oep
	 WHERE	oep.optional_extra_id = ld.optional_extra_id
	   AND	vehicle_class_code = @VehicleClassCode
	   AND	ld.optional_extra_id = @nOptExtraId
	   AND	@dValidOn
		BETWEEN oep.optional_extra_valid_from
		    AND ISNULL(oep.valid_to, @dValidOn)
	RETURN @@ROWCOUNT
GO
