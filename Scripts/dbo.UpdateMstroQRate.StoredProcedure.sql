USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateMstroQRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdateMstroQRate    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.UpdateMstroQRate    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateMstroQRate    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: UpdateMstroQRate
PURPOSE: To update a record in the Quoted_Vehicle_Rate table
AUTHOR: Don Kirkby
DATE CREATED: Nov 25, 1998
CALLED BY: MaestroBatch
REQUIRES:
MOD HISTORY:
Name    Date        Comments
CPY     Mar 12 1999 Added OtherInclusions
Don K	Aug 10 1999 Added CorporateResponsibility
np	Oct 28 1999 Moved data conversion code out of the where clause.
*/
CREATE PROCEDURE [dbo].[UpdateMstroQRate]
	@QRateId varchar(10),
	@RateName varchar(25),
	@RPurposeId varchar(6),
	@RateStruct varchar(1),
	@DOCharge varchar(9),
	@TaxIncl varchar(1),
	@GSTIncl varchar(1),
	@PSTIncl varchar(1),
	@PVRTIncl varchar(1),
	@LocFeeIncl varchar(1),
	@LicFeeIncl varchar(1),
	@ERFIncl varchar(1),
	@PerKmCharge varchar(9),
	@CalendarDayRate varchar(1),
	@FPOPurchased varchar(1),
	@OtherInclusions Varchar(255),
	@CorporateResponsibility varchar(11)
AS
	Declare	@nQRateId Integer
	Select		@nQRateId = CONVERT(int, NULLIF(@QRateId, ''))

	UPDATE	quoted_vehicle_rate
	   SET	rate_name = NULLIF(@RateName, ''),
		rate_purpose_id =
			CONVERT(smallint, NULLIF(@RPurposeId, '')),
		rate_structure = NULLIF(@RateStruct, ''),
		authorized_do_charge =
			CONVERT(decimal(7,2), NULLIF(@DOCharge, '')),
		tax_included = CONVERT(bit, NULLIF(@TaxIncl, '')),
		gst_included = CONVERT(bit, NULLIF(@GSTIncl, '')),
		pst_included = CONVERT(bit, NULLIF(@PSTIncl, '')),
		pvrt_included = CONVERT(bit, NULLIF(@PVRTIncl, '')),
		location_fee_included =
			CONVERT(bit, NULLIF(@LocFeeIncl, '')),
		License_Fee_Included=
			CONVERT(bit, NULLIF(@LicFeeIncl, '')),
		ERF_Included=
			CONVERT(bit, NULLIF(@ERFIncl, '')),
		per_km_charge = CONVERT(decimal(7,2), NULLIF(@PerKmCharge, '')),
		calendar_day_rate =
			CONVERT(bit, NULLIF(@CalendarDayRate, '')),
		fpo_purchased = CONVERT(bit, @FPOPurchased),
		other_inclusions = NULLIF(@OtherInclusions,''),
		corporate_responsibility =
			CONVERT(decimal(9,2), NULLIF(@CorporateResponsibility, ''))
	 WHERE	quoted_rate_id = @nQRateId and Rate_Source in ('RentBack', 'Maestro')



--select distinct Rate_Source from quoted_vehicle_rate
GO
