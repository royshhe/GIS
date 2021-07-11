USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctManualChargeItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetCtrctManualChargeItem    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctManualChargeItem    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctManualChargeItem    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctManualChargeItem    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the manual charge items  for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctManualChargeItem] --2165658
	@CtrctNum	VarChar(10),
	@VSISeq		VarChar(10) = Null
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
	/* modified the if statement to compare with @iVSISeq instead of @VSISeq */
DECLARE	@iCtrctNum Int, 
	@iVSISeq Int

	SELECT 	@iCtrctNum = Convert(Int, NULLIF(@CtrctNum,'')), 
		@iVSISeq = CONVERT(Int, NULLIF(@VSISeq,''))

  If @iVSISeq IS NULL
	SELECT	Rental_Charge_Split_ID,
		Contract_Charge_Item.Charge_Type,
		Charge_Description,
		Unit_Type,
		Unit_Amount,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		'0',
		Contract_Billing_Party_ID,
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST_Exempt)
				 Else '1'
		End) HST_Exempt,		 
		Convert(Char(1), Contract_Charge_Item.PST_Exempt) PSTExempt,
		Convert(Char(1), PVRT_Exempt) PVRTExempt,
		PVRT_Days,
        (Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST2_Exempt)
				 Else '1'
		End)  HST2Exempt,
		CONVERT(Char(1), GST_Included),		
		CONVERT(Char(1), PST_Included),
		CONVERT(Char(1), PVRT_Included),
		CONVERT(Char(1), ISNULL(CRF_Included,0)),		
		CONVERT(Char(1), ISNULL(VLF_Included,0)),
		CONVERT(Char(1), ISNULL(ERF_Included,0)),
		 ISNULL(VLF_Days,0) VLF_Days,
		 ISNULL(ERF_Days,0) ERF_Days,
		'',
		Ticket_Number,
		Issuer,
		Issuing_Date,
		License_Number,
		Manual_Qty_Copy,
		CONVERT(Char(1), ISNULL(CFC_Included,0)), 
		ISNULL(CFC_Days,0) CFC_Days
		
	FROM	Contract_Charge_Item
	LEFT JOIN  Charge_Parameter  WITH(NOLOCK) 
		On Contract_Charge_Item.Charge_Type=Charge_Parameter.Charge_Type
	
	WHERE	Contract_Number = @iCtrctNum
		And Charge_Item_Type = 'm'
  Else
	SELECT	Rental_Charge_Split_ID,
		Contract_Charge_Item.Charge_Type,
		Charge_Description,
		Unit_Type,
		Unit_Amount,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		'0',
		Contract_Billing_Party_ID,
		Contract_Billing_Party_ID,
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST_Exempt)
				 Else '1'
		End) HST_Exempt,		 		
		Convert(Char(1), Contract_Charge_Item.PST_Exempt),   --12
		Convert(Char(1), PVRT_Exempt),
		PVRT_Days,
        (Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST2_Exempt)
				 Else '1'
		End)  HST2Exempt,
		CONVERT(Char(1), GST_Included),		
		CONVERT(Char(1), PST_Included),
		CONVERT(Char(1), PVRT_Included),
		CONVERT(Char(1), ISNULL(CRF_Included,0)),		
		CONVERT(Char(1), ISNULL(VLF_Included,0)),
		CONVERT(Char(1), ISNULL(ERF_Included,0)),
		 ISNULL(VLF_Days,0) VLF_Days,
		 ISNULL(ERF_Days,0) ERF_Days,
		'',
		Ticket_Number,
		Issuer,
		Issuing_Date,
		License_Number,
		Manual_Qty_Copy,
		CONVERT(Char(1), ISNULL(CFC_Included,0)), 
		ISNULL(CFC_Days,0) CFC_Days
		
	FROM	Contract_Charge_Item
	LEFT JOIN  Charge_Parameter  WITH(NOLOCK) 
		On Contract_Charge_Item.Charge_Type=Charge_Parameter.Charge_Type
	
	WHERE	Contract_Number = @iCtrctNum
		And Charge_Item_Type = 'm'
		And Vehicle_Support_Incident_Seq = @iVSISeq
RETURN @@ROWCOUNT

--select top 1000 * from Contract_Charge_Item where charge_item_type='m'
--order by contract_number desc
GO
