USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateMstroQRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/****** Object:  Stored Procedure dbo.CreateMstroQRate    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CreateMstroQRate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateMstroQRate    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateMstroQRate
PURPOSE: To create a record in the Quoted_Vehicle_Rate table
AUTHOR: Don Kirkby
DATE CREATED: Nov 25, 1998
CALLED BY: MaestroBatch
REQUIRES:
MOD HISTORY:
Name    Date        Comments
Don K	Jan 21 1999 Added CommissionPaid and FFPH
CPY     Mar 12 1999 added OtherInclusions
Don K	Aug 10 1999 added CorporateResponsibility
*/
CREATE PROCEDURE [dbo].[CreateMstroQRate]
	@RateSource varchar(10),
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
	@CommissionPaid varchar(1),
	@FFPH varchar(1),
	@OtherInclusions Varchar(255),
	@CorporateResponsibility varchar(11)
AS

	if @FFPH='' 
	select @FFPH='0'

	INSERT
	  INTO	quoted_vehicle_rate
		(
		Rate_Source,
		Rate_Name,

		Rate_Purpose_ID,
		Rate_Structure,
		Authorized_DO_Charge,
		Tax_Included,
		GST_Included,
		PST_Included,
		PVRT_Included,
		Location_Fee_Included,
		License_Fee_Included,
		ERF_Included,
		Per_KM_Charge,
		Calendar_Day_Rate,
		FPO_Purchased,
		commission_paid,
		frequent_flyer_plans_honoured,
		other_inclusions,
		Corporate_Responsibility
		)
	VALUES	(
		NULLIF(@RateSource, ''),
		NULLIF(@RateName, ''),
		CONVERT(smallint, NULLIF(@RPurposeId, '')),
		NULLIF(@RateStruct, ''),
		CONVERT(decimal(7,2), NULLIF(@DOCharge, '')),
		CONVERT(bit, NULLIF(@TaxIncl, '')),
		CONVERT(bit, NULLIF(@GSTIncl, '')),
		CONVERT(bit, NULLIF(@PSTIncl, '')),
		CONVERT(bit, NULLIF(@PVRTIncl, '')),
		CONVERT(bit, NULLIF(@LocFeeIncl, '')),
		CONVERT(bit, NULLIF(@LicFeeIncl, '')),
		CONVERT(bit, NULLIF(@ERFIncl, '')),
		CONVERT(decimal(7,2), NULLIF(@PerKmCharge, '')),
		CONVERT(bit, NULLIF(@CalendarDayRate, '')),
		CONVERT(bit, NULLIF(@FPOPurchased, '')),
		CONVERT(bit, NULLIF(@CommissionPaid, '')),
		CONVERT(bit, NULLIF(@FFPH, '')),
		NULLIF(@OtherInclusions,''),
		CONVERT(decimal(9,2), NULLIF(@CorporateResponsibility, ''))
		)
	RETURN @@IDENTITY

























GO
