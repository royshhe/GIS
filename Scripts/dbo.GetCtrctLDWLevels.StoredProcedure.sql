USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctLDWLevels]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctLDWLevels    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWLevels    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWLevels    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctLDWLevels    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctLDWLevels
PURPOSE: To retrieve all LDW Levels for a vehicle class
AUTHOR: Don Kirkby
DATE CREATED: Aug 10, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each optional extra name and its id.
PARAMETERS:
	VehicleClassCode: extras are available for this class
	ValidOn:	on this date
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctLDWLevels]
	@VehicleClassCode varchar(1),
	@ValidOn	varchar(24)
AS
	DECLARE @dValidOn datetime
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	oe.optional_extra,
		oe.optional_extra_id,
		ld.ldw_deductible,
		oep.daily_rate,
		oep.weekly_rate,
		CONVERT(int, oep.gst_exempt) gst_exempt,
		CONVERT(int, oep.HST2_exempt) HST2_exempt,
		CONVERT(int, oep.pst_exempt) pst_exempt
	  FROM	optional_extra oe,
		ldw_deductible ld,
		optional_extra_price oep
	 WHERE	oe.type = 'LDW'
	   AND	oe.delete_flag = 0
	   AND	ld.optional_extra_id = oe.optional_extra_id
	   AND	ld.vehicle_class_code = @VehicleClassCode
	   AND	oep.optional_extra_id = oe.optional_extra_id
	   AND	@dValidOn
		BETWEEN oep.optional_extra_valid_from
		    AND ISNULL(oep.valid_to, @dValidOn)
	   AND	oe.optional_extra_id NOT IN
			(
			SELECT	optional_extra_id
			  FROM	optional_extra_restriction
			 WHERE	vehicle_class_code = @VehicleClassCode
			)
	 ORDER
	    BY	optional_extra
	RETURN @@ROWCOUNT
GO
