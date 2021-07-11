USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCCanBeElectronicAuthorized]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCCCanBeElectronicAuthorized    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetCCCanBeElectronicAuthorized    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCCCanBeElectronicAuthorized    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To determin if the credit card type can be electronic authorized. If not, return 0 and non-zero otherwise.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCCCanBeElectronicAuthorized]
	@CreditCardTypeID	Varchar(10)
AS
	SELECT Count(*)
	FROM	Credit_Card_Type
	WHERE	Credit_Card_Type_ID = @CreditCardTypeID
	AND	Electronic_Authorization = 1
	RETURN @@ROWCOUNT













GO
