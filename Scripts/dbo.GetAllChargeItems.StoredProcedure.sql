USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllChargeItems]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: GetAllChargeItems
PURPOSE: To retrieve all charge items on a contract
AUTHOR: Dan McMechan?
DATE CREATED: ?
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K	Apr 28 1999 return included taxes if they exist. Remove included taxes
			from amount.
*/
CREATE PROCEDURE [dbo].[GetAllChargeItems] --1358743
@ContractNum Varchar(10)
AS
Set Rowcount 2000
SELECT
	Charge_Type, 
	ISNULL(Amount, 0) - ISNULL(gst_amount_included, 0)
	- ISNULL(PST_Amount_included, 0)
	- ISNULL(PVRT_Amount_included, 0) 
	- ISNULL(CRF_Amount_Included, 0)
	- ISNULL(VLF_Amount_Included, 0)
	- ISNULL(ERF_Amount_Included, 0) 
	- ISNULL(CFC_Amount_Included, 0) Amount,
	ISNULL(GST_Amount, 0) + ISNULL(gst_amount_included, 0) GSTAmountIncl,
	ISNULL(PST_Amount, 0) + ISNULL(PST_Amount_included, 0) PSTAmountIncl,
	ISNULL(PVRT_Amount, 0) + ISNULL(PVRT_Amount_included, 0) PVRTAmountIncl,

	ISNULL(CRF_Amount_Included, 0) CRFAmtIncl,
	ISNULL(VLF_Amount_Included, 0) VLFAmtIncl,
	ISNULL(ERF_Amount_Included, 0) ERFAmtIncl,

	GST_Included, 
    PST_Included, 
	PVRT_Included,
	CRF_Included, 
	VLF_Included, 

	ERF_Included,
	GST_Exempt, 
	PST_Exempt, 
	PVRT_Exempt,
	 ISNULL(PVRT_Days, 0),
	Optional_Extra_ID, 
	Sales_Accessory_ID,
	ISNULL(CFC_Amount_Included, 0) CFCAmtIncl,
	CFC_Included
	
FROM
	Contract_Charge_Item
WHERE
	Contract_Number = Convert(int, @ContractNum)
RETURN 1




SET ANSI_NULLS ON
GO
