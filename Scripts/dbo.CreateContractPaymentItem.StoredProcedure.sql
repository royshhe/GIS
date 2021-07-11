USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractPaymentItem]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
PURPOSE: To insert a record into Contract_Payment_Item table.
MOD HISTORY:
Name    Date        Comments
*/

-- Don K - Jun 22 1999 - Added Business_transaction_id
CREATE PROCEDURE [dbo].[CreateContractPaymentItem]
	@ContractNumber varchar(20), 
	@PaymentType 	varchar(20),
	@Amount 	varchar(20), 
	@ProcessedBy 	varchar(20),
	@ProcessedOn 	varchar(24), 
	@Location 	varchar(20),
	@BusTrxID 	varchar(11),
	@CopiedPayment	varchar(1) = NULL
AS
	/* 10/19/99 - added CopiedPayment param */

Declare @thisLocationID int
Declare @thisRBRDate datetime
Declare @lastSeq int, 
	@iCtrctNum Int

	Select 	@thisLocationID = Convert(int, NULLIF(@Location,'')),
		@iCtrctNum = Convert(int, NULLIF(@ContractNumber,'')),
		@CopiedPayment = ISNULL(NULLIF(@CopiedPayment,''), '0')

	-- get the current max sequence number
	Select 	@lastSeq = Max(Sequence)
	From	Contract_Payment_Item
	Where	Contract_Number = @iCtrctNum

	If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End

	Select 	@thisRBRDate = Max(RBR_Date)
	From	RBR_Date

	Insert Into Contract_Payment_Item
		(Contract_Number, Sequence,
		Payment_Type, Amount, Collected_On, Collected_By,
		Collected_At_Location_ID, RBR_Date, Business_Transaction_ID, 
		Copied_Payment)
	Values
		(@iCtrctNum, (@lastSeq + 1),
		@PaymentType, Convert(decimal(9,2), @Amount),
		Convert(datetime, @ProcessedOn), @ProcessedBy,
		@thisLocationID, @thisRBRDate, Convert(int, NULLIF(@BusTrxID, '')), 
		@CopiedPayment)

	Return (@lastSeq + 1)
GO
