USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractBillingParty]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateContractBillingParty    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractBillingParty    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractBillingParty    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateContractBillingParty    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Contract_Billing_Party table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateContractBillingParty]
@ContractNumber varchar(20), @BillingType varchar(20),
@BillingMethod varchar(20), @CustomerCode varchar(20),
@BillingPartyID varchar(20)
AS
Insert Into Contract_Billing_Party
	(Contract_Number, Contract_Billing_Party_ID,
	Billing_Type, Billing_Method, Customer_Code,
	Amt_Removed_From_Avail_Credit)
Values
	(Convert(int,@ContractNumber), Convert(int,@BillingPartyID),
	@BillingType, @BillingMethod, NULLIF(@CustomerCode,""), 0)
Return 1













GO
