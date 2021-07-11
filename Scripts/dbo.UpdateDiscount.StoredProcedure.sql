USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDiscount]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To update a record in Contract_Reimbur_And_Discount table .
MOD HISTORY:
Name    Date        Comments
*/
-- Don K - Jun 22 1999 - Add business_transaction_id
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateDiscount]
@ContractNumber varchar(20),
@EnteredOn	varchar(24),
@DiscountType	varchar(20),
@Reason		varchar(255),
@EnteredBy	varchar(20),
@FlatAmount	varchar(20),
@Percentage	varchar(20),
@BusTrxID	varchar(11)

AS
Declare 	@thisFlatAmount decimal(9,2)
Declare 	@thisPercentage decimal(5,2)
Declare	@nContractNumber Integer
Declare	@dEnteredOn DateTime

Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Select		@dEnteredOn = Convert(DateTime, NULLIF(@EnteredOn, ''))

If @FlatAmount = ''
	Select @thisFlatAmount = (null)
Else
	Select @thisFlatAmount = Convert(decimal(9,2), @FlatAmount)
If @Percentage = ''
	Select @thisPercentage = (null)
Else
	Select @thisPercentage = Convert(decimal(5,2), @Percentage)

IF @FlatAmount='' and @DiscountType = 'Reimbursement'
  BEGIN
	DELETE
		FROM Contract_Reimbur_And_Discount
	WHERE 
		Contract_Number = @nContractNumber
		--And 	Entered_On = @dEnteredOn
		And 	Type = @DiscountType
		AND Reimbursement_Reason=@Reason
  END
  ELSE	
	BEGIN	
		Update
			Contract_Reimbur_And_Discount
		Set
			Entered_By = @EnteredBy,
			Flat_Amount = @thisFlatAmount,
			Percentage = @thisPercentage,
			Business_Transaction_ID = Convert(int, NULLIF(@BusTrxID, ''))
		Where
			Contract_Number = @nContractNumber
			--And 	Entered_On = @dEnteredOn
			And 	Type = @DiscountType

		If @DiscountType = 'Discount'
			Begin
				Update
					Contract_Reimbur_And_Discount
				Set
					Discount_Reason = @Reason
				Where
					Contract_Number = @nContractNumber
			--		And 	Entered_On = @dEnteredOn
					And 	Type = @DiscountType
			End
		Else
			Begin
				Update
					Contract_Reimbur_And_Discount
				Set
					Reimbursement_Reason = @Reason
				Where
					Contract_Number = @nContractNumber
			--		And 	Entered_On = @dEnteredOn
					And 	Type = @DiscountType
			End	
	END
Return 1
GO
