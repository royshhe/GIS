USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreatePrepayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateCreditCardPayment    Script Date: 2/18/99 12:12:19 PM ******/

/*
PURPOSE: To insert a record into Prepayment  table.
MOD HISTORY:
Name    Date        Comments
*/


CREATE PROCEDURE [dbo].[CreatePrepayment]
	@ContractNumber 	varchar(20),
	@SequenceNumber 	varchar(20),
	@PaymentType varchar(20), 
	@IssuerID varchar(50) ,
	@ForeignAmountCollected varchar(20),
	@CurrencyID varchar(20), 
	@ExchangeRate varchar(20),
	@PP_Number 	varchar(20)
--- Add New Colums for Debit Card Transaction
AS

Insert Into Prepayment
	(Contract_Number,
	 Sequence,	 
	 Payment_Type,
	 Issuer_ID,	
	 Currency_ID,
	 Foreign_Currency_Amt_Collected,
	 Exchange_Rate,
	 PP_Number
	 )
Values
(  Convert(int,@ContractNumber), 
	Convert(int,@SequenceNumber),
	@PaymentType, 
	@IssuerID,
	Convert(tinyint,@CurrencyID),
	Convert(decimal(9,2),@ForeignAmountCollected),
	Convert(decimal(9,4),@ExchangeRate),
    @PP_Number		
	
)

Return 1
GO
