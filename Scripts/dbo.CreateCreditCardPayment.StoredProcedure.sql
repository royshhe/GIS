USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCreditCardPayment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateCreditCardPayment    Script Date: 2/18/99 12:12:19 PM ******/

/*
PURPOSE: To insert a record into Credit_Card_Payment table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateCreditCardPayment]
	@ContractNumber 	varchar(20),
	@SequenceNumber 	varchar(20),
	@AuthorizationNumber 	varchar(20),
	@SwipedFlag 		char(1),
	@TerminalID 		varchar(20),
	@CCKey 			varchar(11),
	@TrxReceiptRefNum 	Char(20),
	@TrxISORespCode		Char(2),
	@TrxRemarks		Varchar(90)

AS

	/* 6/22/99 - added params @ReceiptRefNum, @ISORespCode, @TrxRemarks for saving
		   - added NULLIF check */

Declare @thisCreditCardKey int
Select @thisCreditCardKey = CONVERT(int, NULLIF(@CCKey, ''))

Insert Into Credit_Card_Payment
	(Contract_Number,
	 Sequence,
	 Credit_Card_Key,
	 Authorization_Number,
	 Swiped_Flag,
	 Terminal_ID,
	 Trx_Receipt_Ref_Num,
	 Trx_ISO_Response_Code,
	 Trx_Remarks)
Values
	(Convert(int, NULLIF(@ContractNumber,'')),
	 Convert(int, NULLIF(@SequenceNumber,'')),
	 @thisCreditCardKey,
	 NULLIF(@AuthorizationNumber,''),
	 Convert(bit, @SwipedFlag),
	 NULLIF(@TerminalID, ''),
	 NULLIF(@TrxReceiptRefNum, ''),
	 NULLIF(@TrxISORespCode,''),
	 NULLIF(@TrxRemarks,''))

Return 1
GO
