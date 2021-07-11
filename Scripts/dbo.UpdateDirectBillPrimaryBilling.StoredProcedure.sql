USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDirectBillPrimaryBilling]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateDirectBillPrimaryBilling    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDirectBillPrimaryBilling    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDirectBillPrimaryBilling    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateDirectBillPrimaryBilling    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Direct_Bill_Primary_Billing table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateDirectBillPrimaryBilling]
@ContractNumber varchar(20), @PONumber varchar(20),
@IssueInterimBill varchar(20)
AS
Declare	@nContractNumber Integer

Select		@nContractNumber = Convert(int, NULLIF(@ContractNumber, ''))

Update
	Direct_Bill_Primary_Billing
Set
	PO_Number = @PONumber,
	Issue_Interim_Bills = Convert(bit,@IssueInterimBill)
Where
	Contract_Number = @nContractNumber
	And Contract_Billing_Party_ID = -1
Return 1














GO
