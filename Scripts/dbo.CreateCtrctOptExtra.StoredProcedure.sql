USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctOptExtra]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateCtrctOptExtra    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtra    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtra    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtra    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateCtrctOptExtra
PURPOSE: To add an optional extra to a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 18, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been created in contract_optional_extra
PARAMETERS:
	CtrctNum: Contract number
	OptExtraId
	IncludedInRate: Y/N
	SoldAtLocation
	Daily:	Rate
	Weekly:	Rate
	NoGST
	NoPST
	Qty
	RentFromDate
	RentFromTime
	RentToDate
	RentToTime
	SoldBy:	user id
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
*/
CREATE PROCEDURE [dbo].[CreateCtrctOptExtra]
	@CtrctNum	varchar(11),
	@OptExtraId	varchar(6),
	@IncludedInRate	varchar(1),
	@SoldAtLocation	varchar(10),
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
	@status     varchar(2)='',
	@ReturnLocID varchar(10)=''
AS
	Declare @iCount Smallint
	
	Select @iCount=count(*) from contract_optional_extra 
	where   contract_number=   @CtrctNum
		And	optional_extra_id =	@OptExtraId
		And	included_in_rate =	@IncludedInRate	
		And	included_in_rate =	@IncludedInRate		
	
	INSERT	
	  INTO	contract_optional_extra
		(
		contract_number,
		optional_extra_id,
		included_in_rate,
		sold_at_location_id,
		daily_rate,
		weekly_rate,
		GST_exempt,
		HST2_exempt,
		PST_exempt,
		quantity,
		Unit_Number,
		Coupon_Code,
		rent_from,
		rent_to,
		sold_on,
		sold_by,
		effective_date,
		termination_date,
		Flat_rate,
		status,
		Return_Location_ID,
		Sequence
		)
	VALUES	(
		CONVERT(int, NULLIF(@CtrctNum, '')),
		CONVERT(smallint, NULLIF(@OptExtraId, '')),
		NULLIF(@IncludedInRate, ''),
		CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		CONVERT(decimal(7,2), isnull(NULLIF(@Daily, ''),0)),
		CONVERT(decimal(7,2), isnull(NULLIF(@Weekly, ''),0)),
		CONVERT(bit, isnull(NULLIF(@NoGST, ''),0)),
		CONVERT(bit, isnull(NULLIF(@NoHST2, ''),0)),
		CONVERT(bit, isnull(NULLIF(@NoPST, ''),0)),
		CONVERT(smallint, isnull(NULLIF(@Qty, ''),0)),
		NULLIF(@UnitNumber, ''),
		NULLIF(@CouponCode, ''),
		CASE WHEN @RentFromDate = '' THEN NULL
		  ELSE CONVERT(datetime,
		    @RentFromDate + ' ' + @RentFromTime)
		  END,
		CASE WHEN @RentToDate = '' THEN NULL
		  ELSE CONVERT(datetime,
		    @RentToDate + ' ' + @RentToTime)
		  END,
		GETDATE(),
		NULLIF(@SoldBy, ''),
		GETDATE(),
		'Dec 31 2078 23:59',
		nullif(@Flat, ''),
		@status,
		CONVERT(smallint, NULLIF(@ReturnLocID, '')),
      	@iCount+1	
		
		)
	RETURN @@ROWCOUNT
GO
