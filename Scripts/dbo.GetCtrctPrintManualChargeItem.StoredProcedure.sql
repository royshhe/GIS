USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintManualChargeItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*  PURPOSE:		To retrieve a list of manual charge items for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintManualChargeItem]
	@CtrctNum	VarChar(10)
AS
	/* 2/25/99 - cpy created - copied from GetCtrctManualChargeItem
				but return tax included flags */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	Rental_Charge_Split_ID,
		Charge_Type,
		Charge_Description,
		Unit_Type,
		Unit_Amount,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Contract_Billing_Party_ID,
		Convert(Char(1), GST_Exempt),
		Convert(Char(1), PST_Exempt),
		Convert(Char(1), PVRT_Exempt),
		PVRT_Days,
		Convert(Char(1), GST_Included),
		Convert(Char(1), PST_Included),
		Convert(Char(1), PVRT_Included)
		
	FROM	Contract_Charge_Item
	
	WHERE	Contract_Number = @iCtrctNum
	And 	Charge_Item_Type = 'm'

RETURN @@ROWCOUNT
















GO
