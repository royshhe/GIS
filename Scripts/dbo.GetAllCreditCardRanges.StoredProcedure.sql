USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllCreditCardRanges]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllCreditCardRanges    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllCreditCardRanges    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve credit card range for the given credit card type..
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllCreditCardRanges]
AS
SELECT
	ccr.Credit_Card_Type_ID,
	ccr.Lower_Bound,
	ccr.Upper_Bound,
	ccr.Lengths,
	cct.Credit_Card_Type
FROM
	Credit_Card_Range ccr,
	 Credit_Card_Type cct
WHERE
	ccr.Credit_Card_Type_ID = cct.Credit_Card_Type_ID
ORDER BY
	ccr.Credit_Card_Type_ID
RETURN 1











GO
