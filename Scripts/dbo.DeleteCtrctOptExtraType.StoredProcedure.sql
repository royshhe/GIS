USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctOptExtraType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtraType    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtraType    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtraType    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtraType    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctOptExtraType
PURPOSE: To delete coverage of a specific type from a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 20, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been deleted from contract_optional_extra
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
*/
CREATE PROCEDURE [dbo].[DeleteCtrctOptExtraType]
	@Type		varchar(20),
	@CtrctNum	varchar(11),
	@IncludedInRate	varchar(1)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,'')),
		@IncludedInRate = NULLIF(@IncludedInRate, ''),
		@Type = NULLIF(@Type, '')

	DELETE
	  FROM	contract_optional_extra
	  FROM	optional_extra oe
	 WHERE	contract_number = @iCtrctNum
	   AND	contract_optional_extra.optional_extra_id =
			oe.optional_extra_id
	   AND	included_in_rate = @IncludedInRate
	   AND	oe.type = @Type
	   AND	termination_date = 'Dec 31 2078 23:59'
	RETURN @@ROWCOUNT













GO
