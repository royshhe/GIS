USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrimaryPaymentMethod]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentMethod    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentMethod    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentMethod    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrimaryPaymentMethod    Script Date: 11/23/98 3:55:33 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the primary billing method and primary billing party id for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetCtrctPrimaryPaymentMethod]
	@CtrctNum	VarChar(10)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Billing_Method,
		CBP.Contract_Billing_Party_ID
	FROM	Contract_Billing_Party CBP
	
	WHERE	Contract_Number = @nCtrctNum
	AND	CBP.Billing_Type = 'p'
	RETURN @@ROWCOUNT















GO
