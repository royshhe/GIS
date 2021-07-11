USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVAP]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To retrieve the voucher info associated with a contract
MOD HISTORY:
Name	Date        	Comments
NP	Nov 01 1999	- Moved data conversion code with NULLIF out of the where clause 
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return AR customer
			info even if it has been inactivated
*/
CREATE PROCEDURE [dbo].[GetCtrctVAP]
	@CtrctNum	VarChar(10)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Customer_Code,
		AM.Address_Name,
		VAB.Currency_ID,
		VAB.Maximum_Payment,
		VAB.GST_Included,
		VAB.PST_Included,
		VAB.PVRT_Included,
		VAB.Description,
		VAB.Foreign_Currency_Max_Payment,
		VAB.Exchange_Rate
	FROM	Voucher_Alternate_Billing VAB,
		ARMaster AM,
		Contract_Billing_Party CBP
	WHERE	CBP.Contract_Number = @nCtrctNum
	AND	VAB.Contract_Number = @nCtrctNum
	AND	CBP.Billing_Type = 'a'
	AND	CBP.Billing_Method = 'Voucher'
	AND	CBP.Contract_Billing_Party_ID = VAB.Contract_Billing_Party_ID
	AND	CBP.Customer_Code = AM.Customer_Code
	AND	AM.Address_Type = 0
	--AND	AM.Status_Type = 1
	RETURN @@ROWCOUNT














GO
