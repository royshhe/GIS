USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintAgreeChargeItems]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  PURPOSE:		To return print agreement charge items (FPO, discounts, upgrades, reimbursements)
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintAgreeChargeItems] --1257451
	@ContractNum Varchar(10)
AS
	/* 6/24/99 - return print agreement charge items (FPO, discounts,
			upgrades, reimbursements) */
	/* 7/08/99 - modified additional driver SELECT to return quantity
			and gst/pst flags
		   - return reimbursement amounts as negative amounts */
	/* 7/09/99 - return upgrade charge as daily charge
		   - return percentage discount in the Flat field as
			a percent, not amount */
	/* 7/30/99 - added all manual charge items, necessary calculated
			charge items, all discounts and reimbursements
		   - necessary calc charge items include: upgrade, addnl driver,
		     loc surcharge, member/flex/ctrct discounts, FPO, and fuel charge */
	/* 8/12/99 - check Contract_additional_driver.no_charge before
			returning Qty of additional driver charge
		   - disregard location fees added to manual charges (charge type 35)
		   - only get reimbursements from contract_reimbur_and_discount */
	/* 8/16/99 - return manual charges with Qty = 1 */
	/* 8/17/99 - exclude manual drop charges (33) */
       /*  6/28/04 - Add max Addtional Driver Charge Amt */

DECLARE @iContractNum Int

	SELECT	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	-- Charge type 14=FPO, 18=Fuel Charge, 20=Upgrade
	-- 31=Loc surcharge, 34=additional driver, 50,51,52 = discounts,
	SELECT	distinct Contract_Billing_Party_ID,
		Charge_Item_Description = CASE
			WHEN Charge_Type IN (50, 51, 52)
				THEN Charge_Description + ' - ' + Unit_Type
			WHEN Charge_Type = 34
				THEN 'Additional Driver'
			ELSE
				Charge_Description
		END,
		Unit_Type,
		PVRT_Days,
		GST_Exempt = Convert(Char(1), GST_Exempt),
		PST_Exempt = Convert(Char(1), PST_Exempt),
		PVRT_Exempt = Convert(Char(1), PVRT_Exempt),
		GST_Include = Convert(Char(1), GST_Included),
		PST_Include = Convert(Char(1), PST_Included),
		PVRT_Include = Convert(Char(1), PVRT_Included),
		Qty = CASE Charge_Type
			WHEN 20 THEN 1
         
			WHEN 34 THEN (	SELECT 	Count(*)

			 	      	FROM	Contract_Additional_Driver
					WHERE	Contract_Number = @iContractNum
--					AND	Addition_Type = 'Other'
					AND	No_Charge = 0
					and termination_date>='2078-12-31 23:59')
			ELSE Quantity
		END,
		Flat = CASE
			WHEN Charge_Type IN (20,34) THEN NULL
            WHEN Charge_Type=31 and Unit_Type='Flat' THEN Convert(Char(10), Unit_Amount)
            WHEN Charge_Type=31 and Unit_Type='Day' THEN NULL
			WHEN Charge_Type IN (50, 51, 52)
			 AND Unit_Type LIKE '%Percent%' THEN Unit_Type
			ELSE Convert(Char(10), Amount)
		END, 	
		Daily = CASE 
			WHEN Charge_Type=20 THEN Unit_Amount
			WHEN Charge_Type=31 and Unit_Type='Day' THEN Unit_Amount
			WHEN Charge_Type=34 THEN ( 	SELECT	Convert(decimal(9,2), Value)
			 		FROM	Lookup_Table
			 		WHERE	Category = 'AddnDriverRate'
			 		AND	Code = 'DAILY')
			ELSE NULL
		END,
		Weekly = CASE Charge_Type
			WHEN 34 THEN ( 	SELECT 	Convert(decimal(9,2), Value)
			  		FROM	Lookup_Table
			  		WHERE	Category = 'AddnDriverRate'
			  		AND	Code = 'WEEKLY')
			ELSE NULL
		END,
                Maximum = CASE Charge_Type
			WHEN 34 THEN ( 	SELECT 	Convert(decimal(9,2), Value)
			  		FROM	Lookup_Table
			  		WHERE	Category = 'AddnDriverRate'
			  		AND	Code = 'Max')
			ELSE NULL
		END,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Charge_type
	FROM	Contract_Charge_Item
	WHERE	Contract_Number = @iContractNum
	AND	Charge_Item_Type = 'c'
	AND	(Charge_Type IN (14, 31, 34, 50, 51, 52)
		 OR	
		(Charge_Type in ( 18,20) AND Amount > 0))


	UNION ALL

	-- Get manual charge items for GIS and Rentback (foreign) contracts
	SELECT	Contract_Billing_Party_ID,
		Charge_Item_Description = CASE
			WHEN NULLIF(C.Foreign_Contract_Number,'') IS NOT NULL THEN
				(	SELECT 	LT.Value
					FROM	Lookup_Table LT
		  			WHERE   LT.Code = CCI.Charge_Type
					AND	LT.Category = 'Charge Type Rentback')
			ELSE 	(	SELECT 	LT.Value
					FROM	Lookup_Table LT
		  			WHERE   LT.Code = CCI.Charge_Type
					AND	LT.Category = 'Charge Type Manual')
			END,
		Unit_Type,
		PVRT_Days,
		GST_Exempt = Convert(Char(1), GST_Exempt),
		PST_Exempt = Convert(Char(1), PST_Exempt),
		PVRT_Exempt = Convert(Char(1), PVRT_Exempt),
		GST_Include = Convert(Char(1), GST_Included),
		PST_Include = Convert(Char(1), PST_Included),
		PVRT_Include = Convert(Char(1), PVRT_Included),
		Qty = 1,
		Flat = CASE Unit_Type
			WHEN 'Flat' THEN Convert(Char(10), Amount)
		END,
		Daily = CASE
			WHEN Unit_Type IN ('Daily','Day') THEN Unit_Amount
		END,
		Weekly = CASE
			WHEN Unit_Type IN ('Weekly','Week') THEN Unit_Amount
		END,
                Maximum = CASE
			WHEN Unit_Type IN ('Person Max') THEN Unit_Amount
		END,
		GST_Amount,
		PST_Amount,

		PVRT_Amount,
		Charge_type
	FROM	Contract_Charge_Item CCI
		JOIN Contract C
		  ON CCI.Contract_Number = C.Contract_Number
	WHERE	CCI.Contract_Number = @iContractNum
	AND	CCI.Charge_Item_Type = 'm'
	AND	Charge_Type NOT IN (33, 35,96)   -- exclude drop charges, location fees, License fee

	UNION ALL

	-- all reimbursements
	SELECT	Contract_Billing_Party_Id = -1,
		Charge_Item_Description = Reimbursement_Reason,
		Unit_Type	= 'Flat',
		PVRT_Days	= 0,
		GST_Exempt	= '1',
		PST_Exempt	= '1',
		PVRT_Exempt	= '1',
		GST_Include	= '0',
		PST_Include	= '0',
		PVRT_Include	= '0',
		Total_Qty	= 1,
		Flat		= Convert(Char(10), Flat_Amount * -1),
		Daily		= NULL,
		Weekly		= NULL,
                Maximum		= NULL,
		Total_GST	= 0,
		Total_PST	= 0,
		Total_PVRT	= 0,
		Charge_Type	= NULL
	FROM	Contract_Reimbur_And_Discount
	WHERE	Contract_Number = @iContractNum
	AND	Type = 'Reimbursement'
	ORDER BY Charge_Type, Charge_Item_Description

	RETURN @@ROWCOUNT
GO
