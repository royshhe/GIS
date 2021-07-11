USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctIncludedOptExtras]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedOptExtras    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedOptExtras    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedOptExtras    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedOptExtras    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctIncludedOptExtras
PURPOSE: To delete all the included optional extras from a contract
	except the coverages.
AUTHOR: Don Kirkby
DATE CREATED: Oct 6, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been deleted from contract_optional_extra
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteCtrctIncludedOptExtras]
	@CtrctNum	varchar(11)
AS
	/* 3/18/99 - cpy bug fix - changed included_in_rate to use 1, not Y */
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	DELETE
	  FROM	contract_optional_extra
	  FROM	optional_extra_other oeo
	 WHERE	contract_number = @iCtrctNum
	   AND	contract_optional_extra.optional_extra_id =
			oeo.optional_extra_id
	   AND	included_in_rate = '1'
	   AND	termination_date = 'Dec 31 2078 23:59'
	RETURN @@ROWCOUNT














GO
