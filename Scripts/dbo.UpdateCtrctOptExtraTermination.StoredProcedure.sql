USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctOptExtraTermination]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraTermination    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraTermination    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraTermination    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctOptExtraTermination    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in contract_optional_extra table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCtrctOptExtraTermination]
	@CtrctNum	varchar(11),
	@OptExtraId	varchar(6),
	@IncludedInRate	varchar(1),
	@SoldBy		varchar(20),
	@Sequence	varchar(6)=1
AS
	Declare	@nCtrctNum Integer
	Declare	@nOptExtraId SmallInt
	
	Select		@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
	Select		@nOptExtraId = CONVERT(smallint, NULLIF(@OptExtraId, ''))
	Select		@IncludedInRate = NULLIF(@IncludedInRate, '')
	Select		@Sequence = CONVERT(smallint, NULLIF(@Sequence, ''))

	UPDATE	contract_optional_extra
	SET	Termination_Date = GetDate(),
		sold_on = GetDate(),
		sold_by = @SoldBy
	WHERE	contract_number = @nCtrctNum
	AND	optional_extra_id = @nOptExtraId
	AND	included_in_rate = @IncludedInRate
	AND	termination_date = 'Dec 31 2078 23:59'
	AND Sequence= @Sequence

	RETURN @@ROWCOUNT
GO
