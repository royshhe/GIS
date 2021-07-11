USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintDepRefCA]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  PURPOSE:		To retrieve a list of cash payments and refunds for the given contract. 
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintDepRefCA]
	@CtrctNum	VarChar(10)
AS
	/* 6/24/99 - created - copied from GetCtrctDepRefCA, but returns
			Cash_Payment_Type */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))
			
	SELECT	'Transaction_Type' =
			Case
				When CPI.Amount < 0 Then
					'Refund'
				Else
					'Deposit'
			End,
		CPI.Collected_At_Location_Id,
		LT.Value AS Payment_Type,
		CP.Foreign_Currency_Amt_Collected,
		CP.Currency_ID,

		CP.Exchange_Rate,
		ABS(CPI.Amount),
		CP.Identification_Number,
		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113) AS Collected_On,
		CP.Trx_Receipt_Ref_Num,
		CP.Authorization_Number,		
		Terminal_ID,		
		CP.Trx_ISO_Response_Code,
		CP.Trx_Remarks
	FROM	Cash_Payment CP,
		Contract_Payment_Item CPI,
		Lookup_Table LT
	WHERE	CP.Contract_Number = @iCtrctNum
	AND	CPI.Contract_Number = CP.Contract_Number
	AND	CPI.Sequence = CP.Sequence
	AND	LT.Category IN ('Cash Payment Method','Cash Refund Method')
	AND	LT.Code = CP.Cash_Payment_Type
	ORDER BY Collected_On

	RETURN @@ROWCOUNT
GO
