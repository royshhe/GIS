USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintRefCA]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/****** Object:  Stored Procedure dbo.GetCtrctPrintRefCA    Script Date: 2/18/99 12:12:20 PM ******/
/*  PURPOSE:		To retrieve the cash refund amount outstanding since last print for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintRefCA]
	@ContractNum Varchar(10)
AS
DECLARE @iContractNum  Int
DECLARE @LastPrintDate Datetime

	/* 2/18/99 - cpy created - return cash refund amount outstanding since last print */

	SELECT 	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT	@LastPrintDate = (SELECT Max(Printed_On)
				  FROM	Contract_Print
				  WHERE	Contract_Number = @iContractNum)

	SELECT	SUM(Amount) * -1
	FROM	Cash_Payment CP,
		Contract_Payment_Item CPI
	WHERE	CPI.Contract_Number = CP.Contract_Number
	AND	CPI.Sequence = CP.Sequence
	AND	CP.Cash_Payment_Type = '-2'	-- 'Direct Refund'
	AND	CPI.Amount < 0
	AND	CPI.Payment_Type = 'Cash'
 	AND	CPI.Collected_On > ISNULL(@LastPrintDate, DATEADD(day, -1, CPI.Collected_On))
	AND	CPI.Contract_Number = @iContractNum

	RETURN @@ROWCOUNT












GO
