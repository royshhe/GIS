USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctOptExtra]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtra    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtra    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtra    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtra    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: UpdateCtrctOptExtra
PURPOSE: To change an optional extra on a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 19, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been changed in contract_optional_extra
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
Don K	Oct  6 1998 Added @OldIncludedInRate
Roy H	Dec 04 2012 Added Returned Location
*/
CREATE PROCEDURE [dbo].[UpdateCtrctOptExtra]
	@CtrctNum	varchar(11),
	@OldOptExtraId	varchar(6),
	@NewOptExtraId	varchar(6),
	@OldIncludedInRate	varchar(1),
	@NewIncludedInRate	varchar(1),
	@SoldAtLocation varchar(10),
	@Daily		varchar(8),
	@Weekly		varchar(8),
	@NoGST		varchar(1),
	@NoHST2		Varchar(1),
	@NoPST		varchar(1),
	@Qty		varchar(6),
	@UnitNumber	varchar(20),
	@CouponCode	varchar(20),
	@RentFromDate	varchar(11),
	@RentFromTime	varchar(5),
	@RentToDate	varchar(11),
	@RentToTime	varchar(5),
	@Flat		varchar(8),
	@SoldBy		varchar(20),
	@status		varchar(2)='',
	@ReturnLocID varchar(10)='',
	@Sequence	Varchar(6)='1'
AS
	/* 10/14/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iCtrctNum Int,
		@iOldOptExtraId SmallInt

	SELECT 	@iCtrctNum = CONVERT(int, NULLIF(@CtrctNum, '')),
		@iOldOptExtraId = CONVERT(smallint, NULLIF(@OldOptExtraId, '')),
		@OldIncludedInRate = NULLIF(@OldIncludedInRate, ''),			
		@Sequence	= CONVERT(smallint, NULLIF(@Sequence, ''))
		 
	if	@Sequence is null 
		Select @Sequence=1

	UPDATE	contract_optional_extra
	   SET	optional_extra_id =
			CONVERT(smallint, NULLIF(@NewOptExtraId, '')),
		included_in_rate = NULLIF(@NewIncludedInRate, ''),
		sold_at_location_id =
			CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		daily_rate =
			CONVERT(decimal(7,2), isnull(NULLIF(@Daily, ''),0)),
		weekly_rate =
			CONVERT(decimal(7,2), isnull(NULLIF(@Weekly, ''),0)),
		GST_exempt =
			CONVERT(bit, isnull(NULLIF(@NoGST, ''),0)),
		HST2_exempt =
			CONVERT(bit, isnull(NULLIF(@NoHST2, ''),0)),
		PST_exempt =
			CONVERT(bit, isnull(NULLIF(@NoPST, ''),0)),

		quantity =
			CONVERT(smallint, isnull(NULLIF(@Qty, ''),0)),

		Unit_Number = 
			NULLIF(@UnitNumber, ''),

		Coupon_Code = 
			NULLIF(@CouponCode, ''),

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
		Flat_rate =Nullif(@Flat,''),
		sold_on = GETDATE(),
		status=@status,
		sold_by = @SoldBy,
		Return_Location_ID=	CONVERT(smallint, NULLIF(@ReturnLocID, ''))
	 WHERE	contract_number = @iCtrctNum
	   AND	optional_extra_id = @iOldOptExtraId
	   AND	included_in_rate = @OldIncludedInRate
	   AND	termination_date = 'Dec 31 2078 23:59'
	   And Sequence= @Sequence
	RETURN @@ROWCOUNT




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
