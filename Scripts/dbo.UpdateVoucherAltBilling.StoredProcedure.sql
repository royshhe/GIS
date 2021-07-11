USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVoucherAltBilling]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PROCEDURE NAME: UpdateVoucherAltBilling
PURPOSE: To update the Direct_Bill_Alternate_Billing table
AUTHOR: Don Kirkby (Adapted from CreateVoucherAltBilling by Dan McMechan)
DATE CREATED: Mar 16, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */ 
CREATE PROCEDURE [dbo].[UpdateVoucherAltBilling]
	@ContractNumber varchar(20),
	@BillingPartyID varchar(20),
	@CurrencyID varchar(20),
	@MaximumPayment varchar(20),
	@ForeignCurrencyMaxPayment varchar(20),
	@ExchangeRate varchar(10),
	@GSTIncluded varchar(20),
	@PSTIncluded varchar(20),
	@PVRTIncluded varchar(20),
	@Description varchar(255)
AS
Declare	@nContractNumber Integer
Declare	@nBillingPartyID Integer

Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))
Select		@nBillingPartyID = Convert(int, NULLIF(@BillingPartyID, ''))

If @GSTIncluded = 'True'
	Select @GSTIncluded = '1'
If @GSTIncluded = 'False'
	Select @GSTIncluded = '0'
If @PSTIncluded = 'True'
	Select @PSTIncluded = '1'
If @PSTIncluded = 'False'
	Select @PSTIncluded = '0'

If @PVRTIncluded = 'True'
	Select @PVRTIncluded = '1'
If @PVRTIncluded = 'False'
	Select @PVRTIncluded = '0'
	UPDATE	Voucher_Alternate_Billing
	   SET	Currency_ID = Convert(tinyint, NULLIF(@CurrencyID, '')),
		Maximum_Payment = Convert(decimal(9,2), NULLIF(@MaximumPayment, '')),
		Foreign_Currency_Max_Payment =
			Convert(decimal(9,2), NULLIF(@ForeignCurrencyMaxPayment, '')),
		Exchange_Rate = Convert(decimal(9,4), NULLIF(@ExchangeRate, '')),
		GST_Included = Convert(bit,@GSTIncluded),
		PST_Included = Convert(bit,@PSTIncluded),
		PVRT_Included = Convert(bit,@PVRTIncluded),
		Description = @Description

	 WHERE	Contract_Number 		= @nContractNumber
	   AND		Contract_Billing_Party_ID 	= @nBillingPartyID











GO
