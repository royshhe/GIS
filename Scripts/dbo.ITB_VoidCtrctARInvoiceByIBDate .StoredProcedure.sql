USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ITB_VoidCtrctARInvoiceByIBDate ]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Void specific Contract Interim Billing entry
create procedure [dbo].[ITB_VoidCtrctARInvoiceByIBDate ]-- '1741398','2014-01-26'

 @ContractNumber Varchar(35),
 @InterimBillDate Varchar(30)

as

Declare @BusinessTransID int
Declare @RBRDate Datetime
Declare @Amount as decimal(9,2)
Declare @lastSeq int
declare @iSequence int
declare @BillingPartyID int
declare @GLAccount varchar(32)
DECLARE	@CustomerCode VarChar(8)



	   Select  @RBRDate=max(RBR_date) from RBR_Date where  Budget_Close_Datetime is null

--Create Business_transaction
		INSERT INTO Business_Transaction
			(
				RBR_Date,
				Transaction_Date,
				Transaction_Description,
				Contract_Number,
				Confirmation_Number,
				Transaction_Type,
				Location_ID,
				User_ID,
				Sales_Contract_Number,
				Entered_On_Handheld,
				Signature_Required,
				IBX_Send
			)
		VALUES	
			(
				CONVERT(DateTime, NULLIF(@RBRDate, '')),
				GetDate(),
				'Void Interim Billing',
				@ContractNumber,
				NULL,
				'Con',
				'1',			
				'Interim Bill',
				NULL,
				0,
				0,
				0
			)
	        
			Select @BusinessTransID=@@Identity
			
--CreateContractPaymentItem
Select	
	@Amount=Contract_Payment_Item.Amount*(-1),
	@BillingPartyID=AR_Payment.Contract_Billing_Party_ID
From
	Contract_Payment_Item
		INNER JOIN
		  AR_Payment ON
		    Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
		    And Contract_Payment_Item.Sequence = AR_Payment.Sequence
		  RIGHT OUTER JOIN
		      Interim_Bill ON
		        AR_Payment.Contract_Number = Interim_Bill.Contract_Number
			And AR_Payment.Contract_Billing_Party_ID = Interim_Bill.Contract_Billing_Party_ID
			And AR_Payment.Interim_Bill_Date = Interim_Bill.Interim_Bill_Date
Where
	Interim_Bill.Contract_Number = Convert(int,@ContractNumber)
	and Interim_Bill.Interim_Bill_Date=	 Convert(datetime, @InterimBillDate)	
			
	Select 	@lastSeq = Max(Sequence)
	From	Contract_Payment_Item
	Where	Contract_Number = @ContractNumber

	If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End


	Insert Into Contract_Payment_Item
		(Contract_Number, Sequence,
		Payment_Type, Amount, Collected_On, Collected_By,
		Collected_At_Location_ID, RBR_Date, Business_Transaction_ID, 
		Copied_Payment)
	Values
		(@ContractNumber, (@lastSeq + 1),
		'A/R', Convert(decimal(9,2), @Amount),
		getdate(), 'GIS',
		'1', @RBRDate, Convert(int, NULLIF(@BusinessTransID, '')), 
		'0')			


print 	@Amount
	
--CreateARPayment
Insert Into AR_Payment
	(Contract_Number, Sequence,
	Contract_Billing_Party_ID, Interim_Bill_Date)
Values
	(Convert(int,@ContractNumber), (@lastSeq + 1),
	Convert(int,@BillingPartyID), Convert(datetime, @InterimBillDate))		
	

-- Updating the AR Credit Authorization

-- Get The Customer Code
SELECT	@CustomerCode = Customer_Code
--select *
FROM	Contract_Billing_Party
WHERE	Contract_Number = @ContractNumber
AND	Contract_Billing_Party_ID = @BillingPartyID

-- Updating the AR Credit Authorization
UPDATE	AR_Credit_Authorization
SET	Daily_Contract_Total = Daily_Contract_Total +@Amount,
	Expected_Open_Contract_Charges = Expected_Open_Contract_Charges -  @Amount
WHERE	Customer_Code = @CustomerCode


--CreateSalesJournal
	--SELECT	 GL_Receivables_Clear_Acct From System_Values
	SELECT	@GLAccount = GL_Receivables_Clear_Acct From System_Values
	IF ISNULL(@Amount, 0) != 0
	BEGIN
			SELECT	@iSequence =(	SELECT	MAX(Sequence)
						FROM	Sales_Journal WITH (UPDLOCK, ROWLOCK)
						WHERE	Business_Transaction_ID = @BusinessTransID
					    )
			If @iSequence IS NULL
				SELECT @iSequence = 1
			Else
				SELECT @iSequence = @iSequence + 1

		INSERT INTO Sales_Journal
			(
				Business_Transaction_ID,
				Sequence,
				GL_Account,
				AMount
			)
		VALUES	
			(
				@BusinessTransID,
				@iSequence,
				@GLAccount,
				@Amount
			)
	END
	
	--SELECT	 GL_Deposit_Account From System_Values
	SELECT	@GLAccount = GL_Deposit_Account From System_Values
	IF ISNULL(@Amount, 0) != 0
	BEGIN
			SELECT	@iSequence =(	SELECT	MAX(Sequence)
						FROM	Sales_Journal WITH (UPDLOCK, ROWLOCK)
						WHERE	Business_Transaction_ID = @BusinessTransID
					    )
			If @iSequence IS NULL
				SELECT @iSequence = 1
			Else
				SELECT @iSequence = @iSequence + 1

		INSERT INTO Sales_Journal
			(
				Business_Transaction_ID,
				Sequence,
				GL_Account,
				AMount
			)
		VALUES	
			(
				@BusinessTransID,
				@iSequence,
				@GLAccount,
				 (-1)*@Amount
			)
	END	
	
--CreateARTransaction
	IF ISNULL(@Amount, 0) != 0
	BEGIN
		-- get the current max sequence number
		SELECT	@iSequence =	(	SELECT	MAX(Sequence)
						FROM	AR_Transactions
						WHERE	Business_Transaction_ID = @BusinessTransID
					)
		If @iSequence IS NULL
			SELECT @iSequence = 1
		Else
			SELECT @iSequence = @iSequence + 1
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
				@BusinessTransID,
				@iSequence,
				NULLIF(@CustomerCode, ''),
				 @Amount,
				null,
				Convert(bit,  '0'),
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null
			)
	END	
	

GO
