USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeDiscounts]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctChangeDiscounts    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeDiscounts    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeDiscounts    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeDiscounts    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the contract discount information for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeDiscounts]
	@ContractNumber VarChar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, ''))

	SELECT	Distinct
		CON.Member_Discount_ID,
		CON.Flex_Discount
	
	FROM	Contract CON
	WHERE	CON.Contract_Number = @iCtrctNum
	
RETURN @@ROWCOUNT














GO
