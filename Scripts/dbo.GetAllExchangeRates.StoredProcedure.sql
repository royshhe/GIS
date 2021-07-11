USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllExchangeRates]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllExchangeRates    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllExchangeRates    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllExchangeRates    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllExchangeRates    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of exchange rate info.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllExchangeRates]
AS
	/* 10/21/99 - exclude CDN currency (currency_id 1) from being returned */

   SELECT	Exchange_Rate_ID,
		Currency_ID,
		Rate,
		CONVERT(varChar, Exchange_Rate_Valid_From, 111) Exchange_Rate_Valid_From,
		CONVERT(varChar, Valid_To, 111) Valid_To,
		Last_Changed_By,
		CONVERT (VarChar, Last_Changed_On, 111) Last_Changed_On
   FROM   	Exchange_Rate ER,
		Lookup_Table LT
   WHERE	ER.Currency_ID = CONVERT(TinyInt, LT.Code)
   AND		ER.Currency_ID > 1
   AND		LT.Category IN ('Currency', 'Voucher Currency')
   ORDER BY 	LT.Value,
		ER.Exchange_Rate_Valid_From DESC
   RETURN 1














GO
