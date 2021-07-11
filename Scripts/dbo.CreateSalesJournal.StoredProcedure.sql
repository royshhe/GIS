USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesJournal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To insert a record into Sales_Journal table.
MOD HISTORY:
Name    Date        Comments
 */

-- Don K - May 5 1999 - Don't create a record for a 0 amount
-- Don K - Sep 6 1999 - Allow sequence to be specified.
-- 9/30/99 - do type conversion and nullif outside of SQL statements */
CREATE PROCEDURE [dbo].[CreateSalesJournal]
	@BusinessTransactionID	VarChar(10),
	@GLAccount		VarChar(32),
	@Amount			VarChar(24),
	@Sequence		varchar(4) = ''
AS
	DECLARE @iSequence	TinyInt,
		@rAmount	decimal(9,2), 
		@iBusTrxId	Int

	SELECT	@rAmount = CAST(NULLIF(@Amount, '') AS decimal(9,2)),
		@iBusTrxId = CONVERT(Int, NULLIF(@BusinessTransactionID, '')),
		@GLAccount = NULLIF(@GLAccount,'')
	
	IF ISNULL(@rAmount, 0) != 0
	BEGIN
		IF @Sequence != ''
			SELECT	@iSequence = CAST(@Sequence AS tinyint)
		ELSE
		BEGIN
			SELECT	@iSequence =(	SELECT	MAX(Sequence)
						FROM	Sales_Journal WITH (UPDLOCK, ROWLOCK)
						WHERE	Business_Transaction_ID = @iBusTrxId
					    )
			If @iSequence IS NULL
				SELECT @iSequence = 1
			Else
				SELECT @iSequence = @iSequence + 1
		END

		INSERT INTO Sales_Journal
			(
				Business_Transaction_ID,
				Sequence,
				GL_Account,
				AMount
			)
		VALUES	
			(
				@iBusTrxId,
				@iSequence,
				@GLAccount,
				CONVERT(Decimal(9, 2), NULLIF(@Amount, ''))
			)
	END
RETURN 1
























GO
