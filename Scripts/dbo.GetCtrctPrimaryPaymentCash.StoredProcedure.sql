USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrimaryPaymentCash]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentCash    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentCash    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the primary billing party id for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrimaryPaymentCash]
	@CtrctNum	VarChar(10)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Contract_Billing_Party_ID
	FROM	Contract_Billing_Party CBP
	
	WHERE	Contract_Number = @nCtrctNum
	AND	CBP.Billing_Type = 'p'
	AND	CBP.Billing_Method = 'Cash'
	RETURN @@ROWCOUNT















GO
