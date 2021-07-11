USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintEnergyRecoveryFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/*  PURPOSE:		To retrieve the location fee for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintEnergyRecoveryFee] --'900957'
	@CtrctNum Varchar(10)
AS
	/* 7/14/99 - return location fee for contract */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	SELECT	Unit_Type, Unit_Amount, Amount
	FROM		Contract_Charge_Item
	WHERE	Contract_Number = @iCtrctNum
	AND		Charge_Type = 46

	RETURN @@ROWCOUNT


















GO
