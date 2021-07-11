USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVoucherStandardDescrip]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Get the voucher description ids for a contract
MOD HISTORY:
Name	Date		Comment
*/
CREATE PROCEDURE [dbo].[GetVoucherStandardDescrip]
@ContractNumber varchar(20)
AS
Select
	VABSD.Voucher_Std_Des_ID, CBP.Customer_Code
From
	Voucher_Alt_Billing_Std_Des VABSD, Contract_Billing_Party CBP
Where
	VABSD.Contract_Number = Convert(int, @ContractNumber)
	And VABSD.Contract_Number = CBP.Contract_Number
	And VABSD.Contract_Billing_Party_ID = CBP.Contract_Billing_Party_ID
Return 1













GO
