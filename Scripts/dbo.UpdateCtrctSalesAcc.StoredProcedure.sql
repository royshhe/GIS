USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctSalesAcc]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateCtrctSalesAcc    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctSalesAcc    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctSalesAcc    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctSalesAcc    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: UpdateCtrctSalesAcc
PURPOSE: To change a sales accessory on a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 17, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been updated in contract_sales_accessory
MOD HISTORY:
Name    Date        Comments
Don K	Aug 28 1998 Added included_in_rate
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCtrctSalesAcc]
	@CtrctNum	varchar(11),
	@OldSalesAccId	varchar(6),
	@NewSalesAccId	varchar(6),
	@IncludedInRate varchar(1),
	@SoldAtLocation varchar(10),
	@Qty		varchar(6),
	@Price		varchar(10),
	@NoGST		varchar(1),
	@NoPST		varchar(1)
AS
	Declare	@nCtrctNum Integer
	Declare	@nOldSalesAccId SmallInt

	Select		@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))
	Select		@nOldSalesAccId = CONVERT(smallint, NULLIF(@OldSalesAccId, ''))
	Select		@IncludedInRate = NULLIF(@IncludedInRate, '')

	UPDATE	contract_sales_accessory
	   SET	sales_accessory_id =
			CONVERT(smallint, NULLIF(@NewSalesAccId, '')),
		sold_at_location_id = CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		quantity = CONVERT(smallint, NULLIF(@Qty, '')),
		price = CONVERT(decimal(9,2), NULLIF(@Price, '')),
		gst_exempt = CONVERT(bit, NULLIF(@NoGST, '')),
		pst_exempt = CONVERT(bit, NULLIF(@NoPST, ''))
	 WHERE	contract_number = @nCtrctNum
	   AND		sales_accessory_id = @nOldSalesAccId
	   AND		included_in_rate = @IncludedInRate

	RETURN @@ROWCOUNT













GO
