USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtra    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtra    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtra    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctOptExtra    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctOptExtra
PURPOSE: To delete an optional extra from a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 19, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been deleted from contract_optional_extra
MOD HISTORY:
Name    Date        Comments
Don K	Sep 24 1998 Added effective/termination dates
*/
CREATE PROCEDURE [dbo].[DeleteCtrctOptExtra]
	@CtrctNum	varchar(11),
	@OptExtraId	varchar(6),
	@IncludedInRate	varchar(1),
	@Sequence varchar(6)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int,
	@iOptExtraId SmallInt

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,'')),
		@iOptExtraId = CONVERT(smallint, NULLIF(@OptExtraId, '')),
		@IncludedInRate = NULLIF(@IncludedInRate, ''),
		@Sequence	= CONVERT(smallint, NULLIF(@Sequence, '')) 

	DELETE
	  FROM	contract_optional_extra
	 WHERE	contract_number = @iCtrctNum
	   AND	optional_extra_id = @iOptExtraId
	   AND	included_in_rate = @IncludedInRate
	   AND	termination_date = 'Dec 31 2078 23:59'
	   And	Sequence=@Sequence
	RETURN @@ROWCOUNT
GO
