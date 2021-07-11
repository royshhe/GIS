USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccSalePayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into Sales_Accessory_Sale_Payment table.
MOD HISTORY:
Name    Date        Comments
 */
-- Don K - Jun 22 1999 - Add business_transaction_id
CREATE PROCEDURE [dbo].[CreateSalesAccSalePayment]
	@SalesContractNumber	VarChar(20),
	@PaymentType		VarChar(20),
	@Amount			VarChar(20),
	@BusTrxID		VarChar(11)
AS
Declare @thisRBRDate datetime
Select @thisRBRDate =
	(SELECT
		Max(RBR_Date)
	FROM
		RBR_Date)
	
	INSERT INTO Sales_Accessory_Sale_Payment
		(
		Sales_Contract_Number,
		RBR_Date,
		Collected_On,
		Payment_Type,
		Amount,
		Business_Transaction_ID)
	VALUES
		(
		Convert(int,@SalesContractNumber),
		@thisRBRDate,
		getDate(),
		@PaymentType,
		Convert(decimal(9,2),NULLIF(@Amount, '')),
		Convert(int, NULLIF(@BusTrxID, '')))
RETURN 1
















GO
