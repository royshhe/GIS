USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCreditCardInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: 	To retrieve credit card information for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCreditCardInfo]
	@ContractNumber	Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, ''))

SELECT	CCT.Credit_Card_Type, CCT.Credit_Card_Type_ID, CC.Credit_Card_Number, Left(CC.Expiry, 2) + '/' + Right(CC.Expiry, 2)
FROM	Renter_Primary_Billing RPB,
	Credit_Card CC,
	Credit_Card_Type CCT
WHERE	RPB.Contract_Number = @iCtrctNum
AND	RPB.Credit_Card_Key = CC.Credit_Card_Key
AND	CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
RETURN 1















GO
