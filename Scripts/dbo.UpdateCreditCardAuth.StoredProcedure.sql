USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCreditCardAuth]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateCreditCardAuth    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCreditCardAuth    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCreditCardAuth    Script Date: 1/11/99 1:03:17 PM ******/
/*
PURPOSE: To update a record in Credit_Card_Authorization table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCreditCardAuth]
@ContractNumber varchar(20),
@Amount varchar(20),
@AuthorizationNumber varchar(12),
@ProcessedBy varchar(20),
@ProcessedOn varchar(20),
@SwipedFlag char(1),
@TerminalID varchar(20),
@Location varchar(20),
@CollectedFlag char(1),
@ContractBillingPartyID varchar(10),
@Sequence varchar(10),
@CreditCardKey varchar(11)
AS
--SET CONCAT_NULL_YIELDS_NULL OFF

	/* 4/08/99 - cpy modified - changed AuthorizationNumber length from 10 to 12 */
	-- Apr 9 1999 - Don K - convert blank to NULL in Terminal ID

Declare @thisLocationID integer
Declare @nContractNumber Integer
Declare @nContractBillingPartyID Integer
Declare @nSequence Integer

Select @thisLocationID = Convert(int, @Location)
Select @nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Select @nContractBillingPartyID = Convert(int, NULLIF(@ContractBillingPartyID, ''))
Select @nSequence = Convert(int, NULLIF(@Sequence, ''))

If @Amount = ''
	Select @Amount = '0'

Update
	Credit_Card_Authorization
Set
	Amount_Authorized = Convert(decimal(9,2), @Amount),
	Authorization_Number = @AuthorizationNumber,
	Authorized_On = Convert(datetime, @ProcessedOn),
	Authorized_By = @ProcessedBy,
	Collected_Flag = Convert(bit, @CollectedFlag),
	Swiped_Flag = Convert(bit,@SwipedFlag),
	Terminal_ID = NULLIF(@TerminalID, ''),
	Authorized_At_Location_ID = @thisLocationID,
	Credit_Card_Key = CONVERT(int, NULLIF(@CreditCardKey, ''))
Where
	Contract_Number = @nContractNumber
	And Contract_Billing_Party_ID = @nContractBillingPartyID
	And Sequence = @nSequence
Return 1


















GO
