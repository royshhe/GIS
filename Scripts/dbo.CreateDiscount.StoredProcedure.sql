USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateDiscount]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into Contract_Reimbur_And_Discount table.
MOD HISTORY:
Name    Date        Comments
*/

-- Don K - May 7 1999 - Hacked entered_on to avoid PK violation because
--			somebody put a time field in the PK
-- Don K - Jun 25 1999 - added business_transaction_id param
CREATE PROCEDURE [dbo].[CreateDiscount]
@ContractNumber	varchar(20),
@DiscountType	varchar(20),
@Reason		varchar(255),
@EnteredBy 	varchar(20),
@FlatAmount 	varchar(20),
@Percentage 	varchar(20),
@VSISeq		varchar(10),
@BusTrxID	varchar(11)
AS
Declare @thisFlatAmount decimal(9,2)
Declare @thisPercentage decimal(5,2)
Declare @thisDate datetime,
	@prevDate datetime,
	@nCtrctNum int
SELECT	@nCtrctNum = CAST(NULLIF(@ContractNumber, '') AS int)

-- Get the previous maximum entered data
Select 	@prevDate =
		(
		SELECT	MAX(entered_on)
		  FROM	contract_reimbur_and_discount
		 WHERE	contract_number = @nCtrctNum
		),
	@thisDate = getDate()
IF @prevDate >= @thisDate
	SELECT	@thisDate = DATEADD(ms, 10, @prevDate)
If @FlatAmount = ''
	Select @thisFlatAmount = (null)
Else
	Select @thisFlatAmount = Convert(decimal(9,2), @FlatAmount)
If @Percentage = ''
	Select @thisPercentage = (null)
Else
	Select @thisPercentage = Convert(decimal(5,2), @Percentage)
If @VSISeq = ''
	Select @VSISeq = Null
Insert Into Contract_Reimbur_And_Discount
	(Contract_Number,
	Entered_On,
	Type,
	Entered_By,
	Flat_Amount,
	Percentage,
	Vehicle_Support_Incident_Seq,
	Business_Transaction_ID)
Values
	(Convert(int, @ContractNumber),
	@thisDate,
	@DiscountType,
	@EnteredBy,
	@thisFlatAmount,
	@thisPercentage,
	Convert(Int, @VSISeq),
	Convert(int, NULLIF(@BusTrxID, '')))

-- Update the discount/reimbursement reason
If @DiscountType = 'Discount'
	Begin
		Update
			Contract_Reimbur_And_Discount
		Set
			Discount_Reason = NULLIF(@Reason,'')
		Where
			Contract_Number = Convert(int, @ContractNumber)
			And Entered_On = @thisDate

			And Type = @DiscountType
	End
Else
	Begin
		Update
			Contract_Reimbur_And_Discount
		Set
			Reimbursement_Reason = NULLIF(@Reason,'')
		Where
			Contract_Number = Convert(int, @ContractNumber)
			And Entered_On = @thisDate
			And Type = @DiscountType
	End
Return 1













GO
