USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctSalesAcc]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateCtrctSalesAcc    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctSalesAcc    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctSalesAcc    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctSalesAcc    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateCtrctSalesAcc
PURPOSE: To add a sales accessory to a contract
AUTHOR: Don Kirkby
DATE CREATED: Aug 17, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: record has been created in contract_sales_accessory
MOD HISTORY:
Name    Date        Comments
Don K	Aug 28 1998 Added included_in_rate
*/
CREATE PROCEDURE [dbo].[CreateCtrctSalesAcc]
	@CtrctNum	varchar(11),
	@SalesAccId	varchar(6),
	@IncludedInRate	varchar(1),
	@SoldAtLocation varchar(10),
	@Qty		varchar(6),
	@Price		varchar(10),
	@NoGST		varchar(1),
	@NoPST		varchar(1)
AS
	DECLARE @iSequence smallint
	SELECT	@iSequence =(	SELECT	MAX(Sequence)
						FROM	contract_sales_accessory WITH (UPDLOCK, ROWLOCK)
						WHERE	contract_number=@CtrctNum
									 and sales_accessory_id = @SalesAccId
					    )
	If @iSequence IS NULL
			SELECT @iSequence = 0
		Else
			SELECT @iSequence = @iSequence + 1


	INSERT	
	  INTO	contract_sales_accessory
		(
		contract_number,
		sales_accessory_id,
		sequence,
		included_in_rate,
		Sold_At_Location_ID,
		quantity,

		price,
		gst_exempt,
		pst_exempt
		)
	VALUES	(
		CONVERT(int, NULLIF(@CtrctNum, '')),
		CONVERT(smallint, NULLIF(@SalesAccId, '')),
		@iSequence,
		NULLIF(@IncludedInRate, ''),
		CONVERT(smallint, NULLIF(@SoldAtLocation, '')),
		CONVERT(smallint, NULLIF(@Qty, '')),
		CONVERT(decimal(9,2), NULLIF(@Price, '')),
		CONVERT(bit, NULLIF(@NoGST, '')),
		CONVERT(bit, NULLIF(@NoPST, ''))
		)
	RETURN @@ROWCOUNT
GO
