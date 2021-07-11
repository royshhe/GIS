USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateARTransaction]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into ARTransaction table.
MOD HISTORY:
Name    Date        Comments
*/

-- Don K - May 5 1999 - Don't create a record for a 0 amount
CREATE PROCEDURE [dbo].[CreateARTransaction]
	@BusinessTransactionID	VarChar(10),
	@CustomerAccount	VarChar(12),
	@Amount			VarChar(10),
	@PurchaseOrderNumber	VarChar(20),
	@InvoiceFlag		VarChar(1),
	@CreditCardKey		VarChar(12),
	@LOUClaimNumber		VarChar(15),
	@AdjusterLastName	VarChar(20),
	@AdjusterFirstName	VarChar(20),
	@AuthorizationNumber	VarChar(20),
	@TotalContractAmount	VarChar(10),
	@TotalContractTaxes	VarChar(10),
	@BudgetClaimNumber	VarChar(20),
	@TicketNumber		VarChar(20),
	@IssuingJurisdiction	VarChar(20)
AS
DECLARE @iBusTrxId Int

	/* 9/27/99 - do type conversions outside of the SQL statements */
	/* 10/05/99 - @AuthorizationNumber varchar(12) -> 20 
			to handle saving cash payment identification_numbers */

	DECLARE @NextSequence	TinyInt,
		@rAmount	decimal(9,2)

	SELECT	@rAmount = CAST(NULLIF(@Amount, '') AS decimal(9,2)),
		@iBusTrxId = CONVERT(Int, NULLIF(@BusinessTransactionID, ''))
	
	IF ISNULL(@rAmount, 0) != 0
	BEGIN
		-- get the current max sequence number
		SELECT	@NextSequence =	(	SELECT	MAX(Sequence)
						FROM	AR_Transactions
						WHERE	Business_Transaction_ID = @iBusTrxId
					)
		If @NextSequence IS NULL
			SELECT @NextSequence = 1
		Else
			SELECT @NextSequence = @NextSequence + 1
		INSERT INTO AR_Transactions
			(
				Business_Transaction_ID,
				Sequence,
				Customer_Account,
				Amount,
				Purchase_Order_Number,
				Must_Be_Invoice,
				Credit_Card_Key,
				Loss_Of_Use_Claim_Number,
				Adjuster_First_Name,
				Adjuster_Last_Name,
				Authorization_Number,
				Total_Contract_Amount,
				Total_Contract_Taxes,
				Budget_Claim_Number,
				Ticket_Number,
				Issuing_Jurisdiction
			)
		VALUES	
			(
				@iBusTrxId,
				@NextSequence,
				NULLIF(@CustomerAccount, ''),
				CONVERT(Decimal(9, 2), NULLIF(@Amount, '')),
				NULLIF(@PurchaseOrderNumber, ''),
				Convert(bit, ISNULL(@InvoiceFlag, '0')),
				CONVERT(Int, NULLIF(@CreditCardKey, '')),
				NULLIF(@LOUClaimNumber, ''),
				NULLIF(@AdjusterFirstName, ''),
				NULLIF(@AdjusterLastName, ''),
				NULLIF(@AuthorizationNumber, ''),
				CONVERT(Decimal(9, 2), NULLIF(@TotalContractAmount, '')),
				CONVERT(Decimal(9, 2), NULLIF(@TotalContractTaxes, '')),
				NULLIF(@BudgetClaimNumber, ''),
				NULLIF(@TicketNumber, ''),
				NULLIF(@IssuingJurisdiction, '')
			)
	END
RETURN 1























GO
