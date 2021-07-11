USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCalculatedChargeItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetCtrctCalculatedChargeItem]  -- 90182
	@CtrctNum	VarChar(10),
	@ReturnAdjReimbur Varchar(1) = '0'
AS
	/* 6/15/99 - added adjustments and reimbursements */
	/* 9/28/99 - added order by; index was changed to non-clustered, so
			items not returned in 'order' any more */
	/* 10/12/99 - do type conversion and nullif outside of SQL statement */

DECLARE	@iCtrctNum Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	Rental_Charge_Split_ID,
		Charge_Description,
		Unit_Type,
		Unit_Amount,
		Quantity,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		'0',
		Contract_Billing_Party_ID,
		CONVERT(Char(1), GST_Included),		
		CONVERT(Char(1), PST_Included),
		CONVERT(Char(1), PVRT_Included),
		--Convert(Char(1), GST_Exempt),
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST_Exempt)
				 Else '1'
		End) HST_Exempt,		 
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST2_Exempt)
				 Else '1'
		End)  HST2Exempt,
		Convert(Char(1), Contract_Charge_Item.PST_Exempt),
		Convert(Char(1), PVRT_Exempt),
		Contract_Charge_Item.Charge_Type,
		Sales_Accessory_ID,
		Optional_Extra_ID,
		PVRT_Days,
		CONVERT(Char(1), ISNULL(CRF_Included,0)),		
		CONVERT(Char(1),  ISNULL(VLF_Included,0)),
		CONVERT(Char(1),  ISNULL(ERF_Included,0)),
		ISNULL(VLF_Days,0) VLF_Days,
		ISNULL(ERF_Days,0) ERF_Days,
		Charge_Parameter.Location_Fee,
		CONVERT(Char(1),  ISNULL(CFC_Included,0)),
		ISNULL(CFC_Days,0) CFC_Days

	FROM	Contract_Charge_Item 
	LEFT JOIN  Charge_Parameter  WITH(NOLOCK) 
		On Contract_Charge_Item.Charge_Type=Charge_Parameter.Charge_Type
	
	WHERE	Contract_Number = @iCtrctNum
	And 	Charge_Item_Type = 'c'

	UNION ALL

	SELECT	Rental_Charge_Split_ID,
		Charge_Description,
		Unit_Type,
		Unit_Amount,
		Quantity,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		'0',
		Contract_Billing_Party_ID,
		CONVERT(Char(1), GST_Included),		
		CONVERT(Char(1), PST_Included),
		CONVERT(Char(1), PVRT_Included),
--		Convert(Char(1), GST_Exempt),
--		'1',
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST_Exempt)
				 Else '1'
		End) HST_Exempt,		 
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST2_Exempt)
				 Else '1'
		End)  HST2Exempt,
		Convert(Char(1), Contract_Charge_Item.PST_Exempt),
		Convert(Char(1), PVRT_Exempt),
		Contract_Charge_Item.Charge_Type,
		Sales_Accessory_ID,
		Optional_Extra_ID,
		PVRT_Days,
		CONVERT(Char(1), ISNULL(CRF_Included,0)),		
		CONVERT(Char(1),  ISNULL(VLF_Included,0)),
		CONVERT(Char(1),  ISNULL(ERF_Included,0)),
		 ISNULL(VLF_Days,0) VLF_Days,
		 ISNULL(ERF_Days,0) ERF_Days,
		Charge_Parameter.Location_Fee,
		CONVERT(Char(1),  ISNULL(CFC_Included,0)),
		ISNULL(CFC_Days,0) CFC_Days
	FROM	Contract_Charge_Item
	LEFT JOIN  Charge_Parameter  WITH(NOLOCK) 
		On Contract_Charge_Item.Charge_Type=Charge_Parameter.Charge_Type
	
	WHERE	Contract_Number = @iCtrctNum
	And 	Charge_Item_Type IN ('a', 'r')
	AND 	@ReturnAdjReimbur = '1'

	ORDER BY
		Rental_Charge_Split_ID

	RETURN @@ROWCOUNT

GO
