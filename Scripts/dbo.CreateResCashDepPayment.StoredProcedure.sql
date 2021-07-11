USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResCashDepPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateResCashDepPayment    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateResCashDepPayment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResCashDepPayment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResCashDepPayment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Reservation_Cash_Dep_Payment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateResCashDepPayment]

	@ConfirmNum 	Varchar(10),
	@CollectedOn 	Varchar(24),
	@CashPaymentType Varchar(20),
	@CurrencyId 	Varchar(3),
	@ForeignAmount 	Varchar(10),
	@ExchangeRate  	Varchar(10),
	@IdNumber 	Varchar(20),
-- Add New Colums for Debit Card Transaction
	@AuthorizationNumber varchar(20)='',	
	@SwipedFlag 		char(1)='',
	@TerminalID 		varchar(20)='',	
	@TrxReceiptRefNum 	Char(20)='',
	@TrxISORespCode		Char(2)='',
	@TrxRemarks		Varchar(90)=''

AS
	Declare @lastSeq int 
	
	--When Cash and Credit card collected happened at sametime, need to
	--get Cash sequence number from Reservation_Dep_Payment table. 
	--otherwise will cause sequence number matching problem. Peter Ni 2013/10/16
	select 	@lastSeq = Max(Sequence)
		from Reservation_Dep_Payment
		where confirmation_number=@ConfirmNum 
				and Collected_On=Convert(Datetime, NULLIF(@CollectedOn,''))
				and Amount=@ForeignAmount and Payment_Type='Cash'

	If @lastSeq IS NULL
		Begin
			-- get the current max sequence number
			Select 	@lastSeq = Max(Sequence)
			From	Reservation_Cash_Dep_Payment
			Where	Confirmation_Number = @ConfirmNum and Collected_On=Convert(Datetime, NULLIF(@CollectedOn,''))


			If @lastSeq IS NULL
			Begin
				Select @lastSeq = -1
			End
		End
	  Else
	    Begin
			Select @lastSeq=@lastSeq-1
	    End	
	    
	INSERT INTO Reservation_Cash_Dep_Payment
	       (Confirmation_Number,
		Collected_On,
		Sequence,
		Cash_Payment_Type,
		Currency_ID,
		Foreign_Currency_Amt_Collected,
		Exchange_Rate,
		Identification_Number,
		Authorization_Number,
		 Swiped_Flag,
		 Terminal_ID,
		 Trx_Receipt_Ref_Num,
		 Trx_ISO_Response_Code,
		 Trx_Remarks)
 
	VALUES (Convert(Int, NULLIF(@ConfirmNum,'')),
		Convert(Datetime, NULLIF(@CollectedOn,'')),
		(@lastSeq+1),
		NULLIF(@CashPaymentType,''),
		Convert(TinyInt, NULLIF(@CurrencyId,'')),
		Convert(Decimal(9,2), NULLIF(@ForeignAmount,'')),
		Convert(Decimal(9,4), NULLIF(@ExchangeRate,'')),
		NULLIF(@IdNumber,''),
		NULLIF(@AuthorizationNumber,''),
		 Convert(bit, @SwipedFlag),
		 NULLIF(@TerminalID, ''),
		 NULLIF(@TrxReceiptRefNum, ''),
		 NULLIF(@TrxISORespCode,''),
		 NULLIF(@TrxRemarks,'')

)
	RETURN @@ROWCOUNT
GO
