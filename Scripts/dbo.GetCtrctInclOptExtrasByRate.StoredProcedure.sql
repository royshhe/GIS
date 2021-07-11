USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctInclOptExtrasByRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByRate    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByRate    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByRate    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInclOptExtrasByRate    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctInclOptExtrasByRate
PURPOSE: To retrieve all optional extras 
	that are included in a rate except coverages.
AUTHOR: Don Kirkby
DATE CREATED: Aug 28, 1998
CALLED BY: Contract
REQUIRES: 
ENSURES: returns the optional extras with details
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctInclOptExtrasByRate]
	@RateId			varchar(11),
	@VehicleClassCode	varchar(1),
	@RentFromDate	varchar(12),
	@RentFromTime	varchar(10),
	@RentToDate		varchar(12),
	@RentToTime		varchar(10)
AS
	/* 3/22/99 - cpy modified - return '0' instead of 'N' */
	/* 10/5/99 - NP - @RentFromTime, @RentToTime varchar(5) -> varchar(10) */
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iRateId Int
	SELECT @iRateId = CONVERT(int, NULLIF(@RateId, ''))

	DECLARE	@dRentFrom	datetime
	SELECT	@dRentFrom = 
		CASE WHEN @RentFromDate = '' THEN
		  NULL
		ELSE
		  CONVERT(datetime, @RentFromDate + ' ' + @RentFromTime)
		END
	
	SELECT	oeo.optional_extra,
		oeo.optional_extra_id,
		ioe.quantity included_qty,
		ioe.quantity qty,
		'0' coe_exists,
		CONVERT(varchar(11), @RentFromDate) rent_from_date,
		CONVERT(varchar(5), @RentFromTime) rent_from_time,
		CONVERT(varchar(11), @RentToDate) rent_to_date,
		CONVERT(varchar(5), @RentToTime) rent_to_time,
		'',
		oeo.type
	  FROM	optional_extra_other oeo,
		included_optional_extra ioe
	 WHERE	ioe.optional_extra_id = oeo.optional_extra_id
	   AND	ioe.rate_id = @iRateId
	   AND	@dRentFrom
		BETWEEN	ioe.effective_date
		    AND	ioe.termination_date
	   AND	oeo.optional_extra_id NOT IN
			(
			SELECT	optional_extra_id
			  FROM	optional_extra_restriction
			 WHERE	vehicle_class_code = @VehicleClassCode
			)
	 ORDER
	    BY	oeo.optional_extra
	RETURN @@ROWCOUNT
GO
