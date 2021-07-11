USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccSaleCashPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCashPayment    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCashPayment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCashPayment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCashPayment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Sales_Accessory_Cash_Payment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSalesAccSaleCashPayment]
	@SalesContractNumber	VarChar(20),
	@CurrencyID		VarChar(20),
	@CashPaymentType	VarChar(10),
	@Amount			Varchar(20),
	@ExchangeRate		Varchar(20),
	@ApprovalNumber		Varchar(20),
--- Add New Colums for Debit Card Transaction
	@AuthorizationNumber varchar(20)='',	
	@SwipedFlag 		char(1)='0',
	@TerminalID 		varchar(20)='',	
	@TrxReceiptRefNum 	Char(20)='',
	@TrxISORespCode		Char(2)='',
	@TrxRemarks		Varchar(90)=''
AS
	/* 10/5/99 - approvalnumber varchar(10) -> varchar(20) */

	INSERT INTO Sales_Accessory_Cash_Payment
		(
		Sales_Contract_Number,
		Currency_ID,
		Cash_Payment_Type,
		Foreign_Money_Collected,
		Exchange_Rate,
		Identification_Number,
		Authorization_Number,
		Swiped_Flag,
		Terminal_ID,
		Trx_Receipt_Ref_Num,
		Trx_ISO_Response_Code,
		Trx_Remarks)
	VALUES
		(
		Convert(int,@SalesContractNumber),
		Convert(int, NULLIF(@CurrencyID, '')),
		@CashPaymentType,
		Convert(decimal(9,2), NULLIF(@Amount, '')),
		Convert(decimal(9,4), NULLIF(@ExchangeRate, '')),
		@ApprovalNumber,		
		NULLIF(@AuthorizationNumber,''),
		Convert(bit, @SwipedFlag),
		NULLIF(@TerminalID, ''),
		NULLIF(@TrxReceiptRefNum, ''),
		NULLIF(@TrxISORespCode,''),
		NULLIF(@TrxRemarks,''))
RETURN 1
GO
