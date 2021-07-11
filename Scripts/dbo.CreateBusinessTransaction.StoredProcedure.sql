USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateBusinessTransaction]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into Business_Transaction table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateBusinessTransaction]
	@RBRDate		VarChar(24),
	@TransactionDescription	VarChar(20),
	@ContractNumber		VarChar(10),
	@ConfirmationNumber	VarChar(10),
	@TransactionType	VarChar(3),
	@LocationID		VarChar(10),
	@UserID			VarChar(20),
	@SalesContractNumber	Varchar(10) = NULL,
	@SignatureReq		Varchar(1) = '0',
	@EnteredOnHH		Varchar(1) = '0'
AS
	/* 6/30/99 - added Entered_On_Handheld param and column
		   - default value for param is "0" (not entered on HH) */
	/* 9/27/99 - do type conversion outside of insert */

DECLARE @iContractNum Int,
	@iResvnNum Int

	SELECT	@iContractNum = CONVERT(Int, NULLIF(@ContractNumber, '')),
		@iResvnNum = CONVERT(Int, NULLIF(@ConfirmationNumber, ''))

	INSERT INTO Business_Transaction
		(
			RBR_Date,
			Transaction_Date,
			Transaction_Description,
			Contract_Number,
			Confirmation_Number,
			Transaction_Type,
			Location_ID,
			User_ID,
			Sales_Contract_Number,
			Entered_On_Handheld,
			Signature_Required
		)
	VALUES	
		(
			CONVERT(DateTime, NULLIF(@RBRDate, '')),
			GetDate(),
			NULLIF(@TransactionDescription, ''),
			@iContractNum,
			@iResvnNum,
			NULLIF(@TransactionType, ''),
			CONVERT(SmallInt, NULLIF(@LocationID, '')),
			NULLIF(@UserID, ''),
			Convert(Int, NULLIF(@SalesContractNumber, '')),
			Convert(Bit, @EnteredOnHH),
			Convert(Bit, @SignatureReq)
		)
RETURN @@IDENTITY




















GO
