USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCreditCardTransaction]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To update a record in Credit_Card_Transaction table .
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[UpdateCreditCardTransaction]
	@AuthNum 	Varchar(12),
	@ShortToken		Varchar(20),
	@TrxReceiptRefNum Varchar(20),
--	@Amount		Varchar(12),
--	@RBRDate	Varchar(24),
--	@TerminalId	Varchar(20),
	@AddedToGIS	Varchar(1),
	@CtrctNum 	Varchar(10),
	@ConfirmNum	Varchar(10),
	@SalesCtrctNum	Varchar(10)
AS
	/* 8/05/99 - update the Added_to_Gis flag in Credit_Card_Transaction table */
	/* 8/09/99 - added @CtrctNum, @ConfirmNum, @SalesCtrctNum params
			- if any params are Null, don't update that field */
	/* 11/15/99 - added @Amount, @RBRDate, @TerminalID params */

DECLARE	@dRBRDate Datetime,
	@nAmount Decimal(9,2)

--Log 
--	INSERT into UpdateCCTransactionLog
--	values(@AuthNum, @CCNum, @Amount, 
--			@RBRDate, @TerminalId, @AddedToGIS, 
--			@CtrctNum, @ConfirmNum, @SalesCtrctNum)



	SELECT	@AuthNum = NULLIF(@AuthNum,''),
		@ShortToken = NULLIF(@ShortToken,''),
		@TrxReceiptRefNum= NULLIF(@TrxReceiptRefNum,''),
--		@nAmount = Convert(Decimal(9,2), NULLIF(@Amount,'')),
--		@RBRDate = NULLIF(@RBRDate,''),
--		@TerminalId = NULLIF(@TerminalId,''),
		@AddedToGIS = NULLIF(@AddedToGIS,''),
		@CtrctNum = NULLIF(@CtrctNum,''),
		@ConfirmNum = NULLIF(@ConfirmNum,''),
		@SalesCtrctNum = NULLIF(@SalesCtrctNum,'')
--
--	IF @RBRDate IS NULL
--		SELECT	@dRBRDate = MAX(RBR_Date)
--		FROM	RBR_Date
--	ELSE
--		SELECT	@dRBRDate = Convert(Datetime, @RBRDate)

	-- ensure that at most, only 1 record is updated 
	SET ROWCOUNT 1

	/* if it happens that there is > 1 record with the same auth#, CC#, amount, 
	   rbrdate, and terminalId, then update the record with the latest 
	   system_datetime */

    SELECT  count(*) from Credit_Card_Transaction WITH(UPDLOCK)
	WHERE	Authorization_Number = @AuthNum
			AND	Short_Token = @ShortToken
			AND    Trx_Receipt_Ref_Num= @TrxReceiptRefNum
		 
	UPDATE	Credit_Card_Transaction
	SET	Added_To_GIS = Convert(Bit, @AddedToGIS),
		Contract_Number =
			ISNULL(Convert(Int, @CtrctNum), Contract_Number),
		Confirmation_Number =
			ISNULL(Convert(Int, @ConfirmNum), Confirmation_Number),
		Sales_Contract_Number =
			ISNULL(Convert(Int, @SalesCtrctNum), Sales_Contract_Number)
	WHERE	Authorization_Number = @AuthNum
	AND	Short_Token = @ShortToken
	AND    Trx_Receipt_Ref_Num= @TrxReceiptRefNum
--	AND	Amount = @nAmount
--	AND	RBR_Date = @dRBRDate
--	AND	Terminal_Id = @TerminalId
	AND	Added_To_GIS = 0
--	AND	System_Datetime = (	SELECT	MAX(System_Datetime)
--					FROM	Credit_Card_Transaction
--					WHERE	Authorization_Number = @AuthNum
--					AND	Credit_Card_Number = @CCNum
--					AND	Amount = @nAmount
--					AND	RBR_Date = @dRBRDate
--					AND	Terminal_Id = @TerminalId
--					AND	Added_To_GIS = 0
--				  )

	RETURN @@ROWCOUNT
GO
