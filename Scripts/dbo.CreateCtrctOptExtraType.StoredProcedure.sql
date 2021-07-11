USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctOptExtraType]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateCtrctOptExtraType    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtraType    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtraType    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctOptExtraType    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateCtrctOptExtraType
PURPOSE: To add coverage of a given type to a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 20, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been created in contract_optional_extra
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
*/
CREATE PROCEDURE [dbo].[CreateCtrctOptExtraType]
	@Type		varchar(20),
	@CtrctNum	varchar(11),
	@IncludedInRate	varchar(1),
	@SoldAtLocation varchar(10),
	@Daily		varchar(8),
	@Weekly		varchar(8),
	@NoGST		varchar(1),
	@NoHST2		Varchar(1),
	@NoPST		varchar(1),
	@RentFromDate	varchar(11),
	@RentFromTime	varchar(5),
	@RentToDate	varchar(11),
	@RentToTime	varchar(5),
	@SoldBy		varchar(20)
AS
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
		rent_from,
		rent_to,
		Flat_rate,
		sold_on,
		sold_by,
		effective_date,
		termination_date,
		Sequence
		)
	SELECT	CONVERT(int, NULLIF(@CtrctNum, '')),
		optional_extra_id,
		NULLIF(@IncludedInRate, ''),
		CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		isnull(CONVERT(decimal(7,2), NULLIF(@Daily, '')),0),
		isnull(CONVERT(decimal(7,2), NULLIF(@Weekly, '')),0),
		CONVERT(bit, isnull(@NoGST, 0)),
		CONVERT(bit, isnull(@NoHST2, 0)),
		CONVERT(bit, isnull(@NoPST, 0)),
		1,
		CASE WHEN @RentFromDate = '' THEN NULL
		  ELSE CONVERT(datetime,
		    @RentFromDate + ' ' + @RentFromTime)
		  END,
		CASE WHEN @RentToDate = '' THEN NULL
		  ELSE CONVERT(datetime,
		    @RentToDate + ' ' + @RentToTime)
		  END,
		 null,--for default Flat_rate
		GETDATE(),
		NULLIF(@SoldBy, ''),
		GETDATE(),
		'Dec 31 2078 23:59',
		1
	  FROM	optional_extra
	 WHERE	type = @Type
	   AND	delete_flag = 0
	RETURN @@ROWCOUNT



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
