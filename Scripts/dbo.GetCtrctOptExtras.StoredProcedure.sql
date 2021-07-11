USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtras]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---=========================================












/****** Object:  Stored Procedure dbo.GetCtrctOptExtras    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtras    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtras    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtras    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctOptExtras
PURPOSE: To retrieve all optional extras for a vehicle class
	except LDW, LDW Buydown, PAI, PEC, and Cargo Insurance.
AUTHOR: Don Kirkby
DATE CREATED: Aug 11, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: returns each optional extra name and its id. optional extras
	listed in optional_extra_restriction are excluded.
PARAMETERS:
	VehicleClassCode: extras are available for this class
	ValidOn:	on this date
	CtrctNum:	if this is passed, then we have to include the
			the optional extras assigned to that contract
			even if they are no longer valid.
MOD HISTORY:
Name    Date        Comments
Don K	Oct 6 1998  Changed to use optional_extra_other view.
CPY     Mar 11 1999  Return 0/1 instead of N/Y for Included_In_Rate
*/
CREATE PROCEDURE [dbo].[GetCtrctOptExtras]
	@VehicleClassCode	varchar(1),
	@ValidOn 		varchar(24),
	@CtrctNum		varchar(11)
AS
	/* 4/06/99 - cpy comment - this SP returns a list of all NON-COVERAGE optional extras
				that are valid on @ValidOn date and are NOT restricted for
				@VehicleClassCode;  also any items that not valid but were
				bought for @CtrctNum are included in this list */

	/* 3/11/99 - cpy modified - Return 0/1 instead of N/Y for Included_In_Rate  */
	/* 3/29/99 - cpy modified - added opt extra type */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE 	@dValidOn datetime
	DECLARE	@nCtrctNum Integer

	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	oeo.optional_extra,
		oeo.optional_extra_id,
		oep.daily_rate,
		oep.weekly_rate,
		CONVERT(int, oep.gst_exempt),
		CONVERT(int, oep.HST2_exempt),
		CONVERT(int, oep.pst_exempt),
		oeo.maximum_quantity,
		oeo.type,
		CONVERT(VarChar(1),oeo.Unit_Required) Unit_Required,
		case when @dValidOn between OEC.Effective_Date and OEC.Termination_date
				then OEC.Coupon_Code
				else Null
		end Coupon_Code,
		CONVERT(VarChar(1), oeo.Addendum_Required) Addendum_Required
--select *
	  FROM	optional_extra_other oeo inner join	optional_extra_price oep
			on oep.optional_extra_id = oeo.optional_extra_id
			left join Optional_Extra_Coupon OEC on oeo.optional_extra_id=OEC.optional_extra_id
	 WHERE	oeo.delete_flag = 0
	   AND	@dValidOn
		BETWEEN oep.optional_extra_valid_from
		    AND ISNULL(oep.valid_to, @dValidOn)
	   AND	oeo.optional_extra_id NOT IN
			(
			SELECT	optional_extra_id
			  FROM	optional_extra_restriction
			 WHERE	vehicle_class_code = @VehicleClassCode
			)
	 UNION
	   ALL
	SELECT	oeo.optional_extra,
		coe.optional_extra_id,
		coe.daily_rate,
		coe.weekly_rate,
		CONVERT(int, coe.gst_exempt),
		CONVERT(int, coe.HST2_exempt),
		CONVERT(int, coe.pst_exempt),
		oeo.maximum_quantity,
		oeo.type,
		CONVERT(VarChar(1),oeo.Unit_Required) Unit_Required,
		case when @dValidOn between OEC.Effective_Date and OEC.Termination_date
				then OEC.Coupon_Code
				else Null
		end Coupon_Code,
		CONVERT(VarChar(1), oeo.Addendum_Required) Addendum_Required

--select *
	  FROM	optional_extra_other oeo inner join contract_optional_extra coe
				on coe.optional_extra_id = oeo.optional_extra_id
			left join Optional_Extra_Coupon OEC on oeo.optional_extra_id=OEC.optional_extra_id
	 WHERE	coe.contract_number = @nCtrctNum
	   AND	coe.included_in_rate = '0'	-- previously 'N'
	   AND	coe.termination_date = 'Dec 31 2078 23:59'
	   AND	coe.optional_extra_id NOT IN
		(
		SELECT	oeo2.optional_extra_id
		  FROM	optional_extra_other oeo2,
			optional_extra_price oep2
		 WHERE	oeo2.delete_flag = 0
		   AND	oep2.optional_extra_id = oeo2.optional_extra_id
		   AND	@dValidOn
			BETWEEN oep2.optional_extra_valid_from
			    AND ISNULL(oep2.valid_to, @dValidOn)

		   AND	oeo2.optional_extra_id NOT IN
				(
				SELECT	optional_extra_id
				  FROM	optional_extra_restriction
				 WHERE	vehicle_class_code = @VehicleClassCode
				)
		)
	 ORDER
	    BY	1
	RETURN @@ROWCOUNT

GO
