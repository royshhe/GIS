USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateARPayment]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateARPayment    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.CreateARPayment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateARPayment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateARPayment    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into AR_Payment table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateARPayment]
	@ContractNumber varchar(35), 
	@SequenceNumber varchar(35),
	@BillingPartyID varchar(35), 
	@InterimBillDate varchar(24)=NULL
AS
Insert Into AR_Payment
	(Contract_Number, Sequence,
	Contract_Billing_Party_ID, Interim_Bill_Date)
Values
	(Convert(int,@ContractNumber), Convert(int,@SequenceNumber),
	Convert(int,@BillingPartyID), Convert(datetime, @InterimBillDate))
Return 1



Select * from AR_Payment












GO
