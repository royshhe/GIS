USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateLossOfUseAltBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: UpdateLossOfUseAltBilling
PURPOSE: To update the loss_of_use_alternate_billing table
AUTHOR: Don Kirkby
DATE CREATED: Mar 16, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateLossOfUseAltBilling]
	@ContractNumber varchar(20),
	@BillingPartyID varchar(20),
	@ClaimNumber varchar(20),
	@AdjusterLastName varchar(20),
	@AdjusterFirstName varchar(20),
	@PhoneNumber varchar(35),
	@AdjusterResourceNumber varchar(20)
AS
	Declare	@nContractNumber Integer
	Declare	@nBillingPartyID Integer

	Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
	Select		@nBillingPartyID = Convert(int, NULLIF(@BillingPartyID, ''))

	UPDATE	Loss_Of_Use_Alternate_Billing
	   SET	Claim_Number = @ClaimNumber,
		Adjuster_Last_Name = @AdjusterLastName,
		Adjuster_First_Name = @AdjusterFirstName,
		Phone_Number = @PhoneNumber,
		Adjuster_Resource_Number = @AdjusterResourceNumber
	 WHERE	Contract_Number = @nContractNumber
	   AND	Contract_Billing_Party_ID = @nBillingPartyID











GO
