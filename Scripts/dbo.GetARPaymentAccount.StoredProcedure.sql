USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetARPaymentAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.GetARPaymentAccount    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetARPaymentAccount    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve AR Payment Account for the given credit card type id.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetARPaymentAccount]
@CreditCardType varchar(3)
AS
SELECT
	AR_Payment_Account
FROM
	Credit_Card_Type
WHERE
	Credit_Card_Type_ID = @CreditCardType
RETURN 1
GO
