USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRenterPrimaryBilling]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRenterPrimaryBilling    Script Date: 2/18/99 12:12:20 PM ******/
/*
PURPOSE: To update a record in Renter_Primary_Billing table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateRenterPrimaryBilling]
@ContractNumber varchar(20), @BillingPartyID varchar(20),
@AuthorizationMethod varchar(20), @CreditCardKey varchar(11)

AS

Declare	@nContractNumber Integer
Declare	@nBillingPartyID Integer

Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Select		@nBillingPartyID = Convert(int, NULLIF(@BillingPartyID, ''))

Update
	Renter_Primary_Billing
Set
	Renter_Authorization_Method = @AuthorizationMethod,
	Credit_Card_Key = CONVERT(int, NULLIF(@CreditCardKey, ''))
Where
	Contract_Number = @nContractNumber
And	Contract_Billing_Party_ID = @nBillingPartyID

Return 1













GO
