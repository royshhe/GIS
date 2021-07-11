USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVoucherStandardDescrip]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateVoucherStandardDescrip    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherStandardDescrip    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherStandardDescrip    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateVoucherStandardDescrip    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Voucher_Alt_Billing_Std_Des table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateVoucherStandardDescrip]
@ContractNumber varchar(20), @OrgID varchar(35),
@VoucherStandardDescripID varchar(35)
AS
Declare @thisBillingPartyID int
Select @thisBillingPartyID =
	(Select
		Contract_Billing_Party_ID
	From
		Contract_Billing_Party
	Where
		Contract_Number = Convert(int,@ContractNumber)
		And Billing_Type = 'a'
		And Billing_Method = 'Voucher'
		And Customer_Code = @OrgID)
Insert Into Voucher_Alt_Billing_Std_Des
	(Contract_Number, Contract_Billing_Party_ID, Voucher_Std_Des_ID)
Values
	(Convert(int,@ContractNumber), @thisBillingPartyID,
	Convert(smallint,@VoucherStandardDescripID))
Return 1













GO
