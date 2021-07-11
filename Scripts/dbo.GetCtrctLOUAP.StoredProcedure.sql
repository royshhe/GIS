USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctLOUAP]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To retrieve the loss of use info associated with a contract
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 6 2000	- removed Where criteria "Status_Type = 1"; return AR customer 
			info even if the direct bill org has been inactivated
*/
CREATE PROCEDURE [dbo].[GetCtrctLOUAP]
	@CtrctNum	VarChar(10)
AS
	DECLARE	@nCtrctNum Integer
	SELECT	@nCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	CBP.Customer_Code,
		AM.Address_Name,
		LOU.Claim_Number,
		LOU.Adjuster_Last_Name,
		LOU.Adjuster_First_Name,
		LOU.Phone_Number,
		LOU.Adjuster_Resource_Number
	FROM	Loss_Of_Use_Alternate_Billing LOU,
		ARMaster AM,
		Contract_Billing_Party CBP
	
	WHERE	CBP.Contract_Number = @nCtrctNum
	AND	LOU.Contract_Number = @nCtrctNum
	AND	CBP.Billing_Type = 'a'
	AND	CBP.Billing_Method = 'Loss Of Use'
	AND	CBP.Contract_Billing_Party_ID = LOU.Contract_Billing_Party_ID
	AND	CBP.Customer_Code = AM.Customer_Code
	AND	AM.Address_Type = 0
	--AND	AM.Status_Type = 1
	RETURN @@ROWCOUNT














GO
