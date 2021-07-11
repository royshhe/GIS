USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCreditCardType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctCreditCardType    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCreditCardType    Script Date: 2/16/99 2:05:41 PM ******/
/*
PURPOSE: 	To retrieve credit card type information for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCreditCardType]
	@ContractNumber	Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, ''))

SELECT	CCT.Credit_Card_Type, CCT.Credit_Card_Type_ID
FROM	Renter_Primary_Billing RPB,
	Credit_Card CC,
	Credit_Card_Type CCT
WHERE	RPB.Contract_Number = @iCtrctNum
AND	RPB.Credit_Card_Key = CC.Credit_Card_Key
AND	CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
RETURN 1













GO
