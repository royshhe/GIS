USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCharges]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve a list of existing charges for a contract
AUTHOR:	Don Kirkby
DATE CREATED: Jul 1, 1999 (Oh, Canada)
CALLED BY: Contract
MOD HISTORY:
Name	Date	    Comments
Don K	Jul 16 1999 return Charged_On as a string so you get milliseconds
*/
CREATE PROCEDURE [dbo].[GetCtrctCharges] --2177796,'c',''
	@CtrctNum	varchar(11),
	@ChargeItemType	varchar(1),
	@Sequence	varchar(6)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT 	@iCtrctNum = CAST(NULLIF(@CtrctNum, '') AS int),
		@ChargeItemType = NULLIF(@ChargeItemType, '')

	SELECT	Contract_Number,
		Charge_Item_Type,
		Rental_Charge_Split_ID,
		Sales_Accessory_ID,
		Optional_Extra_ID,
		Charge_Type,
		Charge_description,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		CAST(GST_Included AS tinyint) GST_Included,
		CAST(PST_Included AS tinyint) PST_Included,
		CAST(PVRT_Included AS tinyint)PVRT_Included,
		CAST(GST_Exempt AS tinyint)GST_Exempt,
		CAST(PST_Exempt AS tinyint)PST_Exempt,
		CAST(PVRT_Exempt AS tinyint)PVRT_Exempt,
		Contract_Billing_Party_ID,
		Unit_Amount,
		Unit_Type,
		Quantity,
		Vehicle_Support_Incident_Seq,
		Charged_By,
		CONVERT(varchar, Charged_On, 121),
		PVRT_Days,
		isnull(GST_Amount_Included,'0')GST_Amount_Included,
		isnull(PST_Amount_Included,'0')PST_Amount_Included,
		isnull(PVRT_Amount_Included,'0')PVRT_Amount_Included,
		Business_Transaction_ID,
		VLF_Days,
		ERF_Days,
		CAST(CRF_Included AS tinyint) CRF_Included,
		CAST(VLF_Included AS tinyint) VLF_Included,
		CAST(ERF_Included AS tinyint) ERF_Included,
		isnull(CRF_Amount_Included,'0') CRF_Amount_Included, 
        isnull(VLF_Amount_Included,'0') VLF_Amount_Included, 
        isnull(ERF_Amount_Included,'0') ERF_Amount_Included,
        isnull(CFC_Amount_Included,'0') CFC_Amount_Included,
        CFC_Days,
        CAST(CFC_Included AS tinyint) CFC_Included
        
        
--select *		
	 FROM	contract_charge_item WITH(NOLOCK)
	 WHERE	contract_number = @CtrctNum
	   AND	charge_item_type = @ChargeItemType
	   AND	(  sequence = CAST(@Sequence AS smallint)
		OR @Sequence = ''
		)
GO
