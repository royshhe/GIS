USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDepRefDB]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetCtrctDepRefDB
PURPOSE: To retrieve direct bill deposits and refunds for a contract
AUTHOR: Kahn Derckbie
DATE CREATED: April Fool's Day 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K	Apr 13 1999 Only return for primary billing party
*/
CREATE PROCEDURE [dbo].[GetCtrctDepRefDB]
	@CtrctNum	VarChar(10)
AS
	/* 10/06/99 - do type conversion and nullif outside of select */
DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	Case When CPI.Amount < 0 Then
			'Refund'
		Else
			'Deposit'
		End Transaction_Type,
		CPI.Collected_At_Location_Id,
		ABS(CPI.Amount),
		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113)
	FROM	AR_Payment AP,
		Contract_Payment_Item CPI
	WHERE	AP.Contract_Number = CPI.Contract_Number
	AND	CPI.Contract_Number = @iCtrctNum
	AND	CPI.Sequence = AP.Sequence
	AND	AP.contract_billing_party_id = -1 -- Primary Billing Party only
	RETURN @@ROWCOUNT













GO
