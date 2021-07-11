USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccSaleItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Sales_Accessory_Sale_Item table.
MOD HISTORY:
Name    Date        Comments
 */
-- Don K - Jun 22 1999 - Add business_transaction_id
CREATE PROCEDURE [dbo].[CreateSalesAccSaleItem]
	@SalesContractNumber	VarChar(20),
	@SalesAccessoryID	VarChar(20),
	@Quantity		VarChar(20),
	@Price			Varchar(20),
        @GSTExempt		VarChar(20),
        @PSTExempt		VarChar(20),
        @GSTAmount		VarChar(20),
        @PSTAmount		VarChar(20),
	@ValidFrom		Varchar(20),
	@LocationID		Varchar(20),
	@BusTrxID		Varchar(11)
AS
	DECLARE @iSequence smallint

If @GSTExempt = 'True'
	Select @GSTExempt = '1'
If @GSTExempt = 'False'
	Select @GSTExempt = '0'
If @PSTExempt = 'True'
	Select @PSTExempt = '1'
If @PSTExempt = 'False'
	Select @PSTExempt = '0'
	
	SELECT	@iSequence =(	SELECT	MAX(Sequence_Number)
						FROM	Sales_Accessory_Sale_Item WITH (UPDLOCK, ROWLOCK)
						WHERE	Sales_Contract_Number=@SalesContractNumber
									 and Sales_Accessory_ID = @SalesAccessoryID
					    )
	If @iSequence IS NULL
			SELECT @iSequence = 1
		Else
			SELECT @iSequence = @iSequence + 1
	
	
	
	INSERT INTO Sales_Accessory_Sale_Item
		(
		Sales_Contract_Number,
		Sales_Accessory_ID,
		Sequence_Number ,
		Quantity,
		Amount,
		GST_Exempt,
		PST_Exempt,
		GST_Amount,
		PST_Amount,
		Valid_From,
		Location_ID,
		Business_Transaction_ID)
	VALUES
		(
		Convert(int,@SalesContractNumber),
		Convert(int, @SalesAccessoryID),
		@iSequence,
		Convert(int,@Quantity),
		Convert(decimal(9,2), @Price),
		Convert(bit, @GSTExempt),
		Convert(bit, @PSTExempt),
		Convert(decimal(9,2), @GSTAmount),
		Convert(decimal(9,2), @PSTAmount),
		Convert(datetime,@ValidFrom),
		Convert(int,@LocationID),
		Convert(int, NULLIF(@BusTrxID, '')))
RETURN 1
GO
