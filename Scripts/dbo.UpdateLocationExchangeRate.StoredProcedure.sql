USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateLocationExchangeRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateLocationExchangeRate    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateLocationExchangeRate    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateLocationExchangeRate    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateLocationExchangeRate    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Location_Exchange_Rate table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateLocationExchangeRate]
	@ID		VarChar(10),
	@LocationID	VarChar(10),
	@CurrencyID	VarChar(10),
	@Rate		VarChar(10),
	@ValidFrom	VarChar(24),
	@ValidTo	VarChar(24),
	@CreatedBy	VarChar(20)
AS
	Declare	@nID Integer
	Select		@nID = CONVERT(Int, NULLIF(@ID, ''))
	If @ValidTo = ''	
		Select @ValidTo = NULL
	UPDATE	Location_Exchange_Rate
	SET	Location_ID	= CONVERT(SmallInt, @LocationID),
		Currency_ID	= CONVERT(SmallInt, @CurrencyID),
		Rate		= CONVERT(Decimal(9, 4), @Rate),
		Valid_From	= CONVERT(DateTime, @ValidFrom),
		Valid_To	= CONVERT(DateTime, @ValidTo),
		Created_By	= @CreatedBy,
		Created_On	= GetDate()
	WHERE	ID		= @nID
Return 1














GO
