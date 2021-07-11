USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAmountBilled]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PURPOSE: 	To retrieve the sum of contract payment items for the contract and party id.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAmountBilled]
	@ContractNumber 	varchar(20),
	@BillingPartyID 		varchar(20)
AS
	/* 10/06/99 - do type conversion and nullif outside of select */
DECLARE @iCtrctNum Int,
	@iBillingPartyID Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, '')),
		@iBillingPartyID = CONVERT(Int, NULLIF(@BillingPartyID, ''))

	SELECT 	SUM(cpi.amount)

 	FROM 		AR_Payment AP,
			Contract_Payment_Item CPI

	WHERE	AP.Contract_Number = CPI.Contract_Number
	AND		AP.Sequence = CPI.Sequence	
	AND		AP.Contract_Number = @iCtrctNum
	AND		AP.Contract_Billing_Party_ID = @iBillingPartyID

	GROUP BY 	AP.Contract_Number,
			AP.Contract_Billing_Party_ID

RETURN @@ROWCOUNT










GO
