USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctIncludedSalesAccs]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedSalesAccs    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedSalesAccs    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedSalesAccs    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctIncludedSalesAccs    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctIncludedSalesAccs
PURPOSE: To delete all included sales accessories on a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 6, 1998
CALLED BY: Contract
ENSURES: records have been deleted in contract_sales_accessory
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteCtrctIncludedSalesAccs]
	@CtrctNum	varchar(11)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	DELETE
	  FROM	contract_sales_accessory
	 WHERE	contract_number = @iCtrctNum
	   AND	included_in_rate = 'Y'
	RETURN @@ROWCOUNT













GO
