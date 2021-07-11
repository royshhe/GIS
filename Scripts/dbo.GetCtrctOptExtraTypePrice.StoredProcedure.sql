USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtraTypePrice]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypePrice    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypePrice    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypePrice    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtraTypePrice    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctOptExtraTypePrice
PURPOSE: To retrieve the price of an optional extra
AUTHOR: Don Kirkby
DATE CREATED: Aug 10, 1998
CALLED BY: Contract
REQUIRES: There is only one optional extra with the requested type.
ENSURES: returns daily and weekly rate for an optional extra.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctOptExtraTypePrice]
	@Type		varchar(20),
	@VehicleClassCode varchar(1),
	@ValidOn 	varchar(24)
AS
	DECLARE @dValidOn datetime
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	daily_rate,
		weekly_rate,
		gst_exempt = CONVERT(int, gst_exempt),
		HST2_exempt = CONVERT(int, HST2_exempt),
		pst_exempt = CONVERT(int, pst_exempt),
		bRestricted = (SELECT COUNT(oer.optional_extra_id)
		   FROM	optional_extra_restriction oer
		  WHERE	vehicle_class_code = @VehicleClassCode
		    AND	oer.optional_extra_id = oe.optional_extra_id
		),
		oe.Optional_Extra_ID
	  FROM	optional_extra_price oep,
		optional_extra oe
	 WHERE	oep.optional_extra_id = oe.optional_extra_id
	   AND	oe.type = @Type
	   AND	oe.delete_flag = 0
	   AND	@dValidOn
		BETWEEN oep.optional_extra_valid_from
		    AND ISNULL(oep.valid_to, @dValidOn)
	RETURN @@ROWCOUNT
GO
