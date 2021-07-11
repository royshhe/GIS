USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocationExchangeRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLocationExchangeRate    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationExchangeRate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationExchangeRate    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationExchangeRate    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Location_Exchange_Rate table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLocationExchangeRate]
	
	@LocationID VarChar(10),
	@CurrencyID VarChar(10),
	@Rate VarChar(10),
	@ValidFrom VarChar(24),
	@ValidTo VarChar(24),
	@CreatedBy VarChar(20)
AS
	If @ValidFrom = ''	
		Select @ValidFrom = NULL
	If @ValidTo = ''	
		Select @ValidTo = NULL
	INSERT INTO	Location_Exchange_Rate
		(	
			Location_ID,
			Currency_ID,
			Rate,
			Valid_From,
			Valid_To,
			Created_By,
			Created_On
		)
	VALUES
		(
			CONVERT(SmallInt, @LocationID),
			CONVERT(SmallInt, @CurrencyID),
			CONVERT(Decimal(9, 4), @Rate),
			CONVERT(DateTime, @ValidFrom),
			CONVERT(DateTime, @ValidTo),
			@CreatedBy,
			GetDate()
		)
Return 1













GO
