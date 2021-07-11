USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateExchangeRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateExchangeRate    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CreateExchangeRate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateExchangeRate    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateExchangeRate    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Exchange_Rate table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateExchangeRate]
	@CurrencyID VarChar(10),
	@Rate VarChar(10),
	@ValidFrom VarChar(24),
	@ValidTo VarChar(24),
	@ChangedBy VarChar(20)
AS
	If @ValidFrom = ''	
		Select @ValidFrom = NULL
	If @ValidTo = ''	
		Select @ValidTo = NULL
	INSERT INTO	Exchange_Rate
		(	
			Currency_ID,
			Rate,
			Exchange_Rate_Valid_From,
			Valid_To,
			Last_Changed_By,
			Last_Changed_On
		)
	VALUES
		(
			CONVERT(SmallInt, @CurrencyID),

			CONVERT(Decimal(9, 4), @Rate),
			CONVERT(DateTime, @ValidFrom),
			CONVERT(DateTime, @ValidTo),
			@ChangedBy,
			GetDate()
		)
Return 1













GO
