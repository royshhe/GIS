USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLossOfUseAltBilling]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLossOfUseAltBilling    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.CreateLossOfUseAltBilling    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLossOfUseAltBilling    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLossOfUseAltBilling    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Loss_Of_Use_Alternate_Billing table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLossOfUseAltBilling]
@ContractNumber varchar(20),
@BillingPartyID varchar(20),
@ClaimNumber varchar(20),
@AdjusterLastName varchar(20),
@AdjusterFirstName varchar(20),
@PhoneNumber varchar(35),
@AdjusterResourceNumber varchar(20)
AS
Insert Into Loss_Of_Use_Alternate_Billing
	(Contract_Number, Contract_Billing_Party_ID,
	Claim_Number, Adjuster_Last_Name, Adjuster_First_Name,
	Phone_Number, Adjuster_Resource_Number)
Values
	(Convert(int,@ContractNumber), Convert(int,@BillingPartyID),
	@ClaimNumber, @AdjusterLastName,
	@AdjusterFirstName, @PhoneNumber, @AdjusterResourceNumber)
Return 1













GO
