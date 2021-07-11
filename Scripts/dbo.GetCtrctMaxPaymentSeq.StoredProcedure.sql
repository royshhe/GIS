USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctMaxPaymentSeq]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetCtrctMaxPaymentSeq
PURPOSE: To retrieve the highest sequence number currently in the
	contract_payment_item table for a contract.
AUTHOR: Don Kirkby
DATE CREATED: May 4, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctMaxPaymentSeq]
	@ContractNumber varchar(11)
AS
	/* 10/2/99 - do type conversion and nullif outside of select */
DECLARE @iCtrctNum Int
	SELECT @iCtrctNum = CAST(NULLIF(@ContractNumber, '') AS int)

	SELECT	MAX(sequence)
	  FROM	contract_payment_item
	 WHERE	contract_number = @iCtrctNum

	RETURN 1








GO
