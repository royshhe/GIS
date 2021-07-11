USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrepayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctPrepayment    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrepayment    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrepayment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrepayment    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve a list of Pre-payment (deposit, refund) details for a contract 
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrepayment] --'1344871'
	@CtrctNum	VarChar(10)
AS
	/* 3/08/99 - cpy modified - format Collected_On before returning */
	/* 3/17/99 - np - removed DISTINCT */
	/* 10/14/99 - do type conversion and nullif outside of SQL statement */
DECLARE	@iCtrctNum Int
	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))
	SELECT	
		
		PP.Payment_Type,
		CPI.Collected_At_Location_Id,
		PP.Issuer_ID,
		PP.Foreign_Currency_Amt_Collected,
		PP.Currency_ID,
		PP.Exchange_Rate,
		CPI.Amount,
		PP.PP_Number,
		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113)
	FROM	Prepayment PP,
		Contract_Payment_Item CPI
	WHERE	PP.Contract_Number = @iCtrctNum
	AND	CPI.Contract_Number = @iCtrctNum
	AND	CPI.Sequence = PP.Sequence
	RETURN @@ROWCOUNT
GO
