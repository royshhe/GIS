USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCTARPaymentAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCCTARPaymentAccount    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetCCTARPaymentAccount    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve the AR Payment Account for the given credit card type id.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCCTARPaymentAccount]
	@CreditCardTypeID	VarChar(4)
AS
	SELECT	CCT.AR_Payment_Account
	FROM	Credit_Card_Type CCT
	WHERE	CCT.Credit_Card_Type_ID = @CreditCardTypeID
RETURN 1













GO
