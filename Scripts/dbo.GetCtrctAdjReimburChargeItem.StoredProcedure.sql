USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctAdjReimburChargeItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetCtrctAdjReimburChargeItem    Script Date: 2/18/99 12:12:22 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctAdjReimburChargeItem    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctAdjReimburChargeItem    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve a list of contract charge items for both type of 'a' or 'r' for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctAdjReimburChargeItem]
	@CtrctNum	VarChar(10)
AS
	/* 3/18/99 - cpy modified - format Charged_On */
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT	Adjustment_Type =
		CASE Charge_Item_Type
			WHEN 'a' THEN 'Adjustment'
			WHEN 'r' THEN 'Reimbursement'
		END,													--0
		Contract_Charge_Item.Charge_Type,										--1
		Charge_Description,								--2
		Unit_Type,											--3
		Quantity,												--4
		Unit_Amount,										--5
		Amount,												--6
		GST_Amount,										--7
		--Convert(Char(1), GST_Exempt),			-- 
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST_Exempt)
				 Else '1'
		End) HST_Exempt,								--8		 
		(Case When GST_Exempt=0 Then Convert(Char(1),Charge_Parameter.HST2_Exempt)
				 Else '1'
		End)  HST2Exempt,								--09
		Convert(Char(1), GST_Included),			--10
		PST_Amount,										--11
		Convert(Char(1), Contract_Charge_Item.PST_Exempt),			--12
		Convert(Char(1), PST_Included),			--13
		PVRT_Days,										--14
		PVRT_Amount,									--15
		Convert(Char(1), PVRT_Exempt),			--16	
		Convert(Char(1), PVRT_Included),		--17

		CONVERT(Char(1), ISNULL(CRF_Included,0)),			--18
		CONVERT(Char(1), ISNULL(VLF_Included,0)),	--19
		ISNULL(VLF_Days,0) VLF_Days,									--20
		CONVERT(Char(1), ISNULL(ERF_Included,0)),    --21		
		ISNULL(ERF_Days,0) ERF_Days,						 --22  	 
		Contract_Billing_Party_ID ,					--23
		Charged_By, 		
		Convert(Varchar(17), Charged_On, 113),
		Ticket_Number,
		Issuer,
		Issuing_Date,
		License_Number, --29
		CONVERT(Char(1), ISNULL(CFC_Included,0)),    --30	
		ISNULL(CFC_Days,0) CFC_Days					 --22  	 	
											
		
	FROM	Contract_Charge_Item 
	LEFT JOIN  Charge_Parameter  WITH(NOLOCK) 
		On Contract_Charge_Item.Charge_Type=Charge_Parameter.Charge_Type
	
	WHERE	Contract_Number = @iCtrctNum
	AND	Charge_Item_Type IN ('a', 'r')
	ORDER BY Charged_On DESC
	RETURN @@ROWCOUNT


SET ANSI_NULLS ON
GO
