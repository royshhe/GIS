USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintDropCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*  PURPOSE:		To retrieve the sum of charge items for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintDropCharge]
	@CtrctNum Varchar(10)
AS
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	SELECT	SUM(Amount)
	FROM	Contract_Charge_Item
	WHERE	Contract_Number = @iCtrctNum
	AND	Charge_Type = 33	-- Drop Charge

	RETURN 1





GO
