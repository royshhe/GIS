USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateFinalAmountAdj]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: CreateFinalAmountAdj
PURPOSE: If this isn't called for an adjustment, we move the amounts from
        expected_open_contract charges to daily_contract_total in
        AR_Credit_Authorization.
        In either case, we make the totals in the Contract_Payment_Item/AR_Payment
        tables match the Contract_Billing_Party.amt_removed_from_avail_credit
AUTHOR: Dan McMechan?
DATE CREATED: ?
CALLED BY: ?
MOD HISTORY:
Name    Date        Comments
Don K   Mar 19 1999 Made AR_Payment record use the same sequence number as
                        Contract_Payment_Item. Also changed = (null) to IS NULL
Don K   Apr 5 1999  Stop setting Contract_Billing_Party.Amt_Removed_From_Avail_Credit to 0
Don K   Apr 6 1999  Added @IsAdjustment param, and made it only insert the differences into
                Contract_Payment_Item
CPY     5/11/99     Specified cursor as Fast_foward; close cursor
Don K	May 17 1999 Only move outstanding amount from expected_open_contract
		charges to daily_contract_total.
Don K	Jun 22 1999 Add business_transaction_id
NP - Jul 26 1999 - Removed summing up total amount already billed (@ExistingAmount).
		 -  @ExistingAmount is not included when updating AR_Credit_Authorization.
		 -  @ExistingAmount is not included when updating Contract_Payment_Item.
NP - Aug 25 1999 - Added summing up total amount already billed (@ExistingAmount).
		 -  included @ExistingAmount when updating AR_Credit_Authorization.
NP - Sep 08 1999 - Changed  IF @thisAmount  != 0 to  IF @thisAmount - @ExistingAmount != 0
*/
CREATE PROCEDURE [dbo].[CreateFinalAmountAdj]
        @UserName varchar(50),
        @Location varchar(35),
        @ContractNumber varchar(35),
        @IsAdjustment varchar(1),
	@BusTrxID varchar(11)
AS
Declare @thisBillingPartyId int
Declare @thisCustCode varchar(8)
Declare @thisAmount decimal(9,2), @ExistingAmount decimal(9,2), @nContractNumber int
Declare @lastSeq int
Declare @thisRBRDate datetime
Declare @thisLocationID int
DECLARE @bIsAdjustment bit
Select @thisRBRDate =
        (Select
                Max(RBR_Date)
        From
                RBR_Date)
Select @thisLocationID =
        (Select
                Location_ID
        From
                Location
        Where
                Location = @Location)
SELECT	@bIsAdjustment = CAST(@IsAdjustment AS bit),
	@nContractNumber = CAST(NULLIF(@ContractNumber, '') AS int)

Declare tempCursor Cursor FAST_FORWARD
For
        (
        SELECT  cbp.contract_billing_party_id,
                cbp.customer_code,
                cbp.amt_removed_from_avail_credit
          FROM  contract_billing_party cbp
         WHERE  cbp.contract_number = @nContractNumber
           AND  cbp.billing_method In ('Direct Bill', 'Loss Of Use', 'Voucher')
        )


Open tempCursor
Fetch Next From tempCursor Into @thisBillingPartyID, @thisCustCode, @thisAmount
While (@@Fetch_Status = 0)
        Begin
	SELECT	@ExistingAmount = 0
                SELECT  @ExistingAmount = SUM(cpi.amount)
                  FROM  ar_payment ap
                  JOIN  contract_payment_item cpi
                    ON  ap.contract_number = cpi.contract_number
                   AND  ap.sequence = cpi.sequence
		 WHERE	ap.contract_number = @nContractNumber
                   AND	ap.contract_billing_party_id = @thisBillingPartyID
                 GROUP
                    BY  ap.contract_number,
                        ap.contract_billing_party_id
	
                IF @bIsAdjustment = 0
			Update
				AR_Credit_Authorization
			Set
				Expected_Open_Contract_Charges =
					Expected_Open_Contract_Charges
					- @thisAmount + @ExistingAmount,
				Daily_Contract_Total =
					Daily_Contract_Total
					+ @thisAmount - @ExistingAmount
			Where
				Customer_Code = @thisCustCode

                IF @thisAmount - @ExistingAmount != 0
                BEGIN
                        Select @lastSeq =
                                (Select
                                        Max(Sequence)
                                From
                                        Contract_Payment_Item
                                Where
                                        Contract_Number=Convert(int,@ContractNumber))
                        If @lastSeq IS NULL
                                Begin
                                        Select @lastSeq = -1
                                End
                        Insert Into Contract_Payment_Item
                                (Contract_Number, Sequence,
                                Payment_Type, Amount, Collected_On, Collected_By,
                                Collected_At_Location_ID, RBR_Date, Business_Transaction_ID)
                        Values
                                (Convert(int,@ContractNumber), (@lastSeq + 1),
                                'A/R', @thisAmount - @ExistingAmount,
                                getDate(), @UserName,
                                @thisLocationID, @thisRBRDate, Convert(int, NULLIF(@BusTrxID, '')))

                        Insert Into AR_Payment
                                (Contract_Number, Sequence,
                                Contract_Billing_Party_ID)
                        Values
                                (Convert(int,@ContractNumber), (@lastSeq + 1),
                                @thisBillingPartyID)
                END


                Fetch Next From tempCursor Into @thisBillingPartyID, @thisCustCode, @thisAmount
        End

Close tempCursor
Deallocate tempCursor

Return 1












GO
