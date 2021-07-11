USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllTaxRates]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllTaxRates    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAllTaxRates    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllTaxRates    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllTaxRates    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of tax rates and types for the given date.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllTaxRates]
	@CurrDatetime Varchar(24)
AS
	/* 9/27/99 - do type conversion outside of select */

DECLARE @dCurrDatetime Datetime
	SELECT	@dCurrDatetime = Convert(Datetime, NULLIF(@CurrDatetime,""))

	SELECT 	Tax_Type, Tax_Rate, Rate_Type
	FROM		Tax_Rate
	WHERE	@dCurrDatetime BETWEEN Valid_From AND Valid_To
	RETURN @@ROWCOUNT














GO
