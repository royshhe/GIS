USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintSignatureBox]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  PURPOSE:		To return 0 or 1 depending on whether or not signature box should be printed.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintSignatureBox]
	@ContractNum Varchar(10)
AS
DECLARE @iContractNum Int,
	@dLastPrintDate Datetime,
	@sLastPrintDate Varchar(30),
	@iCollectedBeforePrint Int,
	@iPrintBox Int,
	@iCCKey Int

	/* 2/27/99 - cpy created - return 0 or 1 depending on whether or not
				signature box should be printed */
	/* 3/30/99 - cpy bug fix - not checking for auth/payments on a per CC Key basis */
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

	SELECT 	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

DECLARE CCKeyCur CURSOR FAST_FORWARD FOR
	SELECT	Credit_Card_Key
	FROM	Credit_Card_Authorization
	WHERE	Contract_Number = @iContractNum
	UNION
	SELECT	Credit_Card_Key
	FROM	Credit_Card_Payment
	WHERE	Contract_Number = @iContractNum
	
	-- Get last print datetime for contract
	SELECT	@dLastPrintDate = MAX(Printed_On)
	FROM	Contract_Print
	WHERE	Contract_Number = @iContractNum

	SELECT 	@sLastPrintDate = ISNULL(@dLastPrintDate, 'Jan 01 1900'),
		@iPrintBox = 0

	-- Get all CC Keys for contract
	OPEN CCKeyCur
	FETCH NEXT FROM CCKeyCur INTO @iCCKey

	WHILE @@FETCH_STATUS = 0 AND @iPrintBox <> 1
	BEGIN

--SELECT @iCCKey, @dLastPrintDate

		/* Check if credit card is new */
		-- Cc is 'new' if no authorizations or payments have been
		-- collected on it at a BRAC location prior to the last print date

		-- Check if an auth record exists for this contract and CC key that
		-- that was authorized before sLastPrintDate
		EXEC @iCollectedBeforePrint = GetCtrctPrintCheckAuthExist
						@ContractNum,
						@sLastPrintDate,
						@iCCKey,
						'0'
--SELECT @iCollectedBeforePrint
		IF @iCollectedBeforePrint = 1
		BEGIN
			-- CC auth has been authorized on this card prior to
			-- last print date, so Signature Box has already been
			-- printed last time for this card, so do not print now
			SELECT @iPrintBox = 0
		END

		ELSE
		BEGIN
			-- Check if a payment record exists for this contract and
			-- CC key that was authorized before sLastPrintDate
			EXEC @iCollectedBeforePrint = GetCtrctPrintCheckPaymentExist
						@ContractNum,
						@sLastPrintDate,
						@iCCKey,
						'0'
--SELECT @iCollectedBeforePrint

			-- CC payment has been collected on this card prior to
			-- last print date, so Signature Box has already been
			-- printed last time for this card, so do not print now	
					
			IF @iCollectedBeforePrint = 1
			BEGIN
				SELECT @iPrintBox = 0
			END

			ELSE
			BEGIN
				/* This CC is new */

				-- Check for new payments at Brac locs since last print
				EXEC @iPrintBox = GetCtrctPrintCheckPaymentExist
							@ContractNum,
							@sLastPrintDate,
							@iCCKey,
							'1'
				IF @iPrintBox <> 1
					BEGIN
						-- Check for new auths at Brac locs since last print
						EXEC @iPrintBox = GetCtrctPrintCheckAuthExist
								@ContractNum,
								@sLastPrintDate,
								@iCCKey,
								'1'
								IF @iPrintBox=1
									BEGIN
										insert into Contract_Print_Signature_Log
														( Contract_Number,
														  Credit_Card_Key,
														  Last_Print_Date,
														  Current_Print_Date,
														  Remarks		
															)
												VALUES	( @ContractNum,
														  @iCCKey,	
														  CONVERT(datetime, NULLIF(@sLastPrintDate, '')),
														  getdate(),
														  'New Authorization'			
															)	
									END

					END
					 ELSE
						BEGIN
							insert into Contract_Print_Signature_Log
											( Contract_Number,
											  Credit_Card_Key,
											  Last_Print_Date,
											  Current_Print_Date,
											  Remarks		
												)
									VALUES	( @ContractNum,
											  @iCCKey,	
											  CONVERT(datetime, NULLIF(@sLastPrintDate, '')),
											  getdate(),
											  'New Credit Card Payment'			
												)	
						END

			END
		END	

		FETCH NEXT FROM CCKeyCur INTO @iCCKey
		
	END -- while

	-- no new items collected since last print
	
 
	SELECT @iPrintBox
	
	WHERE @iPrintBox IS NOT NULL

	CLOSE CCKeyCur
	DEALLOCATE CCKeyCur

	RETURN @iPrintBox

GO
