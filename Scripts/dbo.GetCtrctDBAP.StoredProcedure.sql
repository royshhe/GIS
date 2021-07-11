USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDBAP]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To retrieve alternate billing info associated with a contract
MOD HISTORY:
Name	Date        	Comments
CPY	10/22/99 	- do nullif outside of SQL statements 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return direct bill 
			info even if the direct bill org has been inactivated
*/
CREATE PROCEDURE [dbo].[GetCtrctDBAP]
	@CtrctNum	VarChar(10)
AS

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Customer_Code,
		AM.Address_Name,
		DBAB.PO_Number
	FROM	Direct_Bill_Alternate_Billing DBAB,
		ARMaster AM,
		Contract_Billing_Party CBP
	WHERE	CBP.Contract_Number = @iCtrctNum
	AND	DBAB.Contract_Number = @iCtrctNum
	AND	CBP.Billing_Type = 'a'
	AND	CBP.Billing_Method = 'Direct Bill'
	AND	CBP.Contract_Billing_Party_ID = DBAB.Contract_Billing_Party_ID
	AND	CBP.Customer_Code = AM.Customer_Code
	AND	AM.Address_Type = 0
	--AND	AM.Status_Type = 1
	RETURN @@ROWCOUNT















GO
