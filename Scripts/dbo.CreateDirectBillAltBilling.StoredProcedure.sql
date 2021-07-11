USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateDirectBillAltBilling]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateDirectBillAltBilling    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.CreateDirectBillAltBilling    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateDirectBillAltBilling    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateDirectBillAltBilling    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Direct_Bill_Alternate_Billing table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateDirectBillAltBilling]
@ContractNumber varchar(20), @BillingPartyID varchar(20),
@PONumber varchar(20)
AS
Insert Into Direct_Bill_Alternate_Billing
	(Contract_Number, Contract_Billing_Party_ID,
	PO_Number)
Values
	(Convert(int,@ContractNumber), Convert(int,@BillingPartyID),
	@PONumber)
Return 1













GO
