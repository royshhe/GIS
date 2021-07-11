USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCreditCardAuth]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Credit_Card_Authorization table.
MOD HISTORY:
Name    Date        	Comments
CPY	4/08/99 	- cpy modified - AuthorizationNumber length changed from 10 to 12 
Don K	Apr 8 1999 	- Don K - convert blank to null in @TerminalID
CPY	Jan 12 2000	Added params TrxReceiptRefNum, TrxISORespsCode, and
			TrxRemarks
*/
CREATE PROCEDURE [dbo].[CreateCreditCardAuth]
	@ContractNumber 	varchar(20),
	@Amount 		varchar(20),
	@AuthorizationNumber 	varchar(12),
	@ProcessedBy 		varchar(20),
	@ProcessedOn 		varchar(20),
	@SwipedFlag 		char(1),
	@TerminalID 		varchar(20),
	@Location 		varchar(20),
	@CollectedFlag 		char(1),
	@CreditCardKey 		varchar(11),
	@TrxReceiptRefNum 	Char(20),
	@TrxISORespCode		Char(2),
	@TrxRemarks		Varchar(90)
AS

DECLARE @thisLocationID int
DECLARE @BillingPartyID int
DECLARE @lastSeq int

Select 	@thisLocationID = Convert(int, @Location), 
	@TrxReceiptRefNum = NULLIF(@TrxReceiptRefNum, ''),
	@TrxISORespCode = NULLIF(@TrxISORespCode, ''),
	@TrxRemarks = NULLIF(@TrxRemarks, '')

If @Amount = ''
	Select @Amount = '0'

-- get the current max sequence number
SELECT	@BillingPartyID = -1,
	@lastSeq =
	(Select
		Max(Sequence)
	From
		Credit_Card_Authorization
	Where
		Contract_Number = Convert(int, @ContractNumber)
		And Contract_Billing_Party_ID = -1)
--		And Contract_Billing_Party_ID = @BillingPartyID)

--If @lastSeq = (null)
If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End

Insert Into Credit_Card_Authorization
	(Contract_Number, Contract_Billing_Party_ID,
	Sequence, Amount_Authorized,
	Authorization_Number, Authorized_On,
	Authorized_By, Swiped_Flag,
	Terminal_ID, Authorized_At_Location_ID,
	Collected_Flag, Credit_Card_Key, 
	Trx_Receipt_Ref_Num, Trx_ISO_Response_Code, Trx_Remarks)
Values
	(Convert(int,@ContractNumber), @BillingPartyID,
	(@lastSeq + 1),	Convert(decimal(9,2), @Amount),	
	@AuthorizationNumber, Convert(datetime, @ProcessedOn),
	@ProcessedBy, Convert(bit,@SwipedFlag),
	NULLIF(@TerminalID, ''), @thisLocationID,
	Convert(bit, @CollectedFlag), CONVERT(int, NULLIF(@CreditCardKey, '')), 
	@TrxReceiptRefNum, @TrxISORespCode, @TrxRemarks)

Return 1
GO
