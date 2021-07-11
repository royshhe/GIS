USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateRenterPrimaryBilling]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateRenterPrimaryBilling    Script Date: 2/18/99 12:12:19 PM ******/
/*
PURPOSE: To insert a record into Renter_Primary_Billing table.
MOD HISTORY:
Name    Date        Comments
 * Don K Feb 19 1999	Accepts CreditCardKey instead of individual fields
 */

CREATE PROCEDURE [dbo].[CreateRenterPrimaryBilling]
@ContractNumber varchar(20), @BillingPartyID varchar(20),
@AuthorizationMethod varchar(20), @CreditCardKey varchar(11)

AS

Insert Into Renter_Primary_Billing
	(Contract_Number, Contract_Billing_Party_ID,
	Renter_Authorization_Method, Credit_Card_Key)
Values

	(Convert(int,@ContractNumber), Convert(int,@BillingPartyID),
	@AuthorizationMethod, CONVERT(int, NULLIF(@CreditCardKey,'')))
Return 1












GO
