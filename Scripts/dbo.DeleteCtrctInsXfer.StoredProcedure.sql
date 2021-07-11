USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCtrctInsXfer]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteCtrctInsXfer    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctInsXfer    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctInsXfer    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteCtrctInsXfer    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: DeleteCtrctInsXfer
PURPOSE: To delete an insurance_transfer record
AUTHOR: Don Kirkby
DATE CREATED: Aug 14, 1998
CALLED BY: Contract
REQUIRES: a record exists with the contract number
ENSURES: the record is deleted. returns 1 for success, else 0
PARAMETERS:
	CtrctNum: Contract number
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteCtrctInsXfer]
	@CtrctNum	varchar(11)
AS
	DELETE
	  FROM	insurance_transfer
	 WHERE	contract_number = CONVERT(int, @CtrctNum)
	RETURN @@ROWCOUNT












GO
