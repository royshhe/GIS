USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctAuthorization]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCtrctAuthorization    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctAuthorization    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve the credit card information that is used for authorization for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctAuthorization]
	@CtrctNum	VarChar(10)
AS
	/* 3/08/99 - cpy bug fix - was not returning anything if pre-authorization was Cash
				- made RPB, CC use outer join */
	-- Don K Mar 10 1999 Added CCSeqNum
	/* 10/12/99 - do type conversion and nullif outside of SQL statement */
	-- Roy He Updated for MS SQL server 2008
DECLARE @iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT
		"",
		C.Pre_Authorization_Method,
		CC.Credit_Card_Type_ID,
		CC.Credit_Card_Number,
		CC.Last_Name,
		CC.First_Name,
		CC.Expiry,
		CC.Sequence_Num,
		CC.Short_Token
	FROM
		Contract C 
Inner Join  Renter_Primary_Billing RPB
		  On C.Contract_Number = RPB.Contract_Number
Left Join Credit_Card CC
		  On RPB.Credit_Card_Key = CC.Credit_Card_Key
		--Contract C, Renter_Primary_Billing RPB, Credit_Card CC
	WHERE
		C.Contract_Number = @iCtrctNum
		--And C.Contract_Number = RPB.Contract_Number
		And RPB.Contract_Billing_Party_ID = -1
		--And RPB.Credit_Card_Key *= CC.Credit_Card_Key

	RETURN @@ROWCOUNT
GO
