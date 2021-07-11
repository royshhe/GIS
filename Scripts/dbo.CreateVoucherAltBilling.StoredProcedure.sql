USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVoucherAltBilling]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVoucherAltBilling    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherAltBilling    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherAltBilling    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherAltBilling    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Voucher_Alternate_Billing table.
MOD HISTORY:
Name    Date        Comments
 */

-- Don K - Mar 16 1999 - Converted empty string to NULL on most fields.
CREATE PROCEDURE [dbo].[CreateVoucherAltBilling]
@ContractNumber varchar(20), @BillingPartyID varchar(20),
@CurrencyID varchar(20), @MaximumPayment varchar(20),
@ForeignCurrencyMaxPayment varchar(20), @ExchangeRate varchar(10),
@GSTIncluded varchar(20), @PSTIncluded varchar(20),
@PVRTIncluded varchar(20), @Description varchar(255)
AS
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
Insert Into Voucher_Alternate_Billing
	(Contract_Number, Contract_Billing_Party_ID,
	Currency_ID, Maximum_Payment, Foreign_Currency_Max_Payment,
	Exchange_Rate, GST_Included, PST_Included, PVRT_Included,
	Description)
Values
	(Convert(int, NULLIF(@ContractNumber, '')), Convert(int, NULLIF(@BillingPartyID, '')),
	Convert(tinyint, NULLIF(@CurrencyID, '')), Convert(decimal(9,2), NULLIF(@MaximumPayment, '')),
	Convert(decimal(9,2), NULLIF(@ForeignCurrencyMaxPayment, '')),
	Convert(decimal(9,4), NULLIF(@ExchangeRate, '')), Convert(bit,@GSTIncluded),
	Convert(bit,@PSTIncluded), Convert(bit,@PVRTIncluded),
	@Description)
Return 1
















GO
