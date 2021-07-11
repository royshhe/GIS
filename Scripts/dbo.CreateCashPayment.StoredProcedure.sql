USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCashPayment]    Script Date: 2021-07-10 1:50:47 PM ******/
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
--exec CreateCashPayment 
--'1256129',
-- '0',
-- '2', 
--'750', 
--'1', 
--'1', 
--'4506364400038106', 
--'449727', 
--'0',
-- 'EIGEN',
-- '00100100',
-- '00',
-- 'APPROVED'
CREATE PROCEDURE [dbo].[CreateCashPayment]
	@ContractNumber 	varchar(20),
	@SequenceNumber 	varchar(20),
	@PaymentType varchar(10), 
	@ForeignAmountCollected varchar(20),
	@CurrencyID varchar(20), 
	@ExchangeRate varchar(20),
	@Identification_Number 	varchar(20),
--- Add New Colums for Debit Card Transaction
	@AuthorizationNumber varchar(20),	
	@SwipedFlag 		char(1),
	@TerminalID 		varchar(20),	
	@TrxReceiptRefNum 	Char(20),
	@TrxISORespCode		Char(2),
	@TrxRemarks		Varchar(90)

AS

	/* 6/22/99 - added params @ReceiptRefNum, @ISORespCode, @TrxRemarks for saving
		   - added NULLIF check */



Insert Into Cash_Payment
	(Contract_Number,
	 Sequence,	 
	 Cash_Payment_Type,	
	 Currency_ID,
	 Foreign_Currency_Amt_Collected,
	 Exchange_Rate,
	Identification_Number,
	 Authorization_Number,
	 Swiped_Flag,
	 Terminal_ID,
	 Trx_Receipt_Ref_Num,
	 Trx_ISO_Response_Code,
	 Trx_Remarks)
Values
(  Convert(int,@ContractNumber), 
	Convert(int,@SequenceNumber),
	@PaymentType, 
	Convert(tinyint,@CurrencyID),
	Convert(decimal(9,2),@ForeignAmountCollected),
	Convert(decimal(9,4),@ExchangeRate),
    @Identification_Number,		
	 NULLIF(@AuthorizationNumber,''),
	 Convert(bit, @SwipedFlag),
	 NULLIF(@TerminalID, ''),
	 NULLIF(@TrxReceiptRefNum, ''),
	 NULLIF(@TrxISORespCode,''),
	 NULLIF(@TrxRemarks,'')
)

Return 1
GO
