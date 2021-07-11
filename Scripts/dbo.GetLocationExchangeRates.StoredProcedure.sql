USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationExchangeRates]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocationExchangeRates    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationExchangeRates    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationExchangeRates    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationExchangeRates    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationExchangeRates]
	@LocationID VarChar(10)
AS
	Set Rowcount 2000
	SELECT	LER.ID,
		LER.Currency_ID,
		LER.Rate,
		CONVERT(VarChar, LER.Valid_From, 111) Valid_From,
		CONVERT(VarChar, LER.Valid_To, 111) Valid_To,
		LER.Created_By,
		CONVERT(VarChar, LER.Created_On, 111) Created_On
	FROM	Location_exchange_Rate LER,
		Lookup_Table LT
	WHERE	LER.Location_ID = CONVERT(SmallInt, @LocationID)
	AND	LER.Currency_ID = CONVERT(TinyInt, LT.Code)
	AND	LT.Category IN ('Currency', 'Voucher Currency')
	ORDER BY
		LT.Value,
		LER.Valid_From DESC
Return 1












GO
