USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDirectBillAltBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: UpdateDirectBillAltBilling
PURPOSE: To update the Direct_Bill_Alternate_Billing table
AUTHOR: Don Kirkby
DATE CREATED: Mar 16, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateDirectBillAltBilling]
	@ContractNumber varchar(20),
	@BillingPartyID varchar(20),
	@PONumber varchar(20)
AS
	Declare	@nContractNumber Integer
	Declare	@nBillingPartyID Integer

	Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
	Select		@nBillingPartyID = Convert(int, NULLIF(@BillingPartyID, ''))

	UPDATE	Direct_Bill_Alternate_Billing
	   SET	PO_Number = @PONumber
	 WHERE	Contract_Number = @nContractNumber
	   AND		Contract_Billing_Party_ID = @nBillingPartyID











GO
