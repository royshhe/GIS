USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOptExtrasByRes]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByRes    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByRes    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByRes    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOptExtrasByRes    Script Date: 11/23/98 3:55:33 PM ******/
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve a list optional extras for the given confirmation number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctOptExtrasByRes]
	@ConfirmNum	varchar(11),
	@CurrDate	Varchar(24)
AS
	DECLARE @dCurrDate Datetime
	DECLARE @dLastDatetime Datetime
	DECLARE @nConfirmNum Integer

	SELECT @dCurrDate = Convert(Datetime,
			ISNULL(NULLIF(@dCurrDate,''), GetDate()) ),
		@dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59'),
		@nConfirmNum = CONVERT(int, NULLIF(@ConfirmNum, ''))

	SELECT	RRA.optional_extra_id,
		RRA.optional_extra_id,
		OEP.daily_rate,
		OEP.weekly_rate,
		CONVERT(Char(1), OEP.gst_exempt),
		CONVERT(Char(1), OEP.HST2_exempt),
		CONVERT(Char(1), OEP.pst_exempt),
		RRA.quantity,
		0,
		'','', '', '', '', '',rra.Coupon,rra.Flat_Rate,'CO','' Sequence,'' contract_number
	  FROM	Optional_Extra OE,
		Optional_Extra_Price OEP,
		Reserved_Rental_Accessory RRA
	 WHERE	RRA.Optional_Extra_Id = OEP.Optional_Extra_ID
	   AND	OE.type NOT IN
			('LDW', 'Buydown', 'PAI', 'PEC', 'CARGO','ELI','PAE','RSN')
	   AND	RRA.optional_extra_id = OE.optional_extra_id
	   AND	@dCurrDate BETWEEN OEP.Optional_Extra_Valid_From AND
			ISNULL(OEP.Valid_To, @dLastDatetime)
	   AND	RRA.confirmation_number =	@nConfirmNum
	 ORDER BY OE.optional_extra
	RETURN @@ROWCOUNT




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
