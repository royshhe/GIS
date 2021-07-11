USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctSalesAcc]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCtrctSalesAcc    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctSalesAcc    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctSalesAcc    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctSalesAcc    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctSalesAcc
PURPOSE: To delete a sales accessory on a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 17, 1998
CALLED BY: Contract
REQUIRES: records exist in sales_accessory_price and
	location_sales_accessory that match the id and have
	a date range that includes contract.pick_up_on
ENSURES: record has been deleted in contract_sales_accessory
MOD HISTORY:
Name    Date        Comments
Don K	Aug 28 1998 Added included_in_rate
*/
CREATE PROCEDURE [dbo].[DeleteCtrctSalesAcc]
	@CtrctNum	varchar(11),
	@SalesAccId	varchar(6),
	@IncludedInRate	varchar(1)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int,
	@iSalesAccId SmallInt

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,'')),
		@iSalesAccId = CONVERT(smallint, NULLIF(@SalesAccId, '')),
		@IncludedInRate = NULLIF(@IncludedInRate, '')

	DELETE
	  FROM	contract_sales_accessory
	 WHERE	contract_number = @iCtrctNum
	   AND	sales_accessory_id = @iSalesAccId
	   AND	included_in_rate = @IncludedInRate
	RETURN @@ROWCOUNT













GO
