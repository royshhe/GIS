USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctOptExtraType]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraType    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraType    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraType    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraType    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: UpdateCtrctOptExtraType
PURPOSE: To change the coverage of a specific type on a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 20, 1998
CALLED BY: Contract
REQUIRES:

ENSURES: record has been changed in contract_optional_extra
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCtrctOptExtraType]
	@Type		varchar(20),
	@CtrctNum	varchar(11),
	@OldIncludedInRate	varchar(1),
	@NewIncludedInRate	varchar(1),
	@SoldAtLocation varchar(10),
	@Daily		varchar(8),
	@Weekly		varchar(8),
	@NoGST		varchar(1),
	@NoHST2		varchar(1),
	@NoPST		varchar(1),
	@RentFromDate	varchar(11),
	@RentFromTime	varchar(5),
	@RentToDate	varchar(11),
	@RentToTime	varchar(5),
	@SoldBy		varchar(20)
AS
	Declare	@nCtrctNum Integer

	Select		@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
	Select		@OldIncludedInRate = NULLIF(@OldIncludedInRate, '')
	Select		@Type = NULLIF(@Type, '')

	UPDATE	contract_optional_extra
	   SET	included_in_rate = NULLIF(@NewIncludedInRate, ''),
		daily_rate =
			CONVERT(decimal(7,2), NULLIF(@Daily, '')),
		sold_at_location_id =
			CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		weekly_rate =
			CONVERT(decimal(7,2), NULLIF(@Weekly, '')),
		GST_exempt =
			CONVERT(bit, NULLIF(@NoGST, '')),
		HST2_exempt =
			CONVERT(bit, NULLIF(@NoHST2, '')),
		PST_exempt =
			CONVERT(bit, NULLIF(@NoPST, '')),
		rent_from =
			CASE WHEN @RentFromDate = '' THEN NULL
			  ELSE CONVERT(datetime,
			    @RentFromDate + ' ' + @RentFromTime)
			  END,
		rent_to =
			CASE WHEN @RentToDate = '' THEN NULL
			  ELSE CONVERT(datetime,
			    @RentToDate + ' ' + @RentToTime)
			  END,
		sold_on = GETDATE(),
		sold_by = @SoldBy
	  FROM	optional_extra oe
	 WHERE	contract_number = @nCtrctNum
	   AND	included_in_rate = @OldIncludedInRate
	   AND	contract_optional_extra.optional_extra_id =
			oe.optional_extra_id
	   AND	termination_date = 'Dec 31 2078 23:59'
	   AND	oe.type = @Type

	RETURN @@ROWCOUNT
GO
