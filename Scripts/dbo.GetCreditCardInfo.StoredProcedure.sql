USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCreditCardInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCreditCardInfo    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCreditCardInfo    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCreditCardInfo    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve the credit card information for the given credit card key.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCreditCardInfo]
	@CreditCardKey	Varchar(10)
AS
	/* 8/10/99 - added LastName, FirstName */
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCreditCardKey Int
	SELECT @iCreditCardKey = CONVERT(Int, NULLIF(@CreditCardKey, ''))

	SELECT	Credit_Card_Type_Id,
		Credit_Card_Number,
		Expiry,
		Last_Name,
		First_Name,
		Short_Token
	FROM	Credit_Card
	WHERE	Credit_Card_Key = @iCreditCardKey
	RETURN @@ROWCOUNT
GO
