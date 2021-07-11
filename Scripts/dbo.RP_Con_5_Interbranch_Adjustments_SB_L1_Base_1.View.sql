USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Adjustments_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Con_5_Interbranch_Adjustments_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Adjustments Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Adjustments Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/10/08	extract the correct taxes if taxes are included in the charge item.
Joseph T.	1999/10/25	display 'Undefined' when the charge type
				is not defined in the lookup table.
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Adjustments_SB_L1_Base_1]
AS
SELECT 	Contract_Charge_Item.Business_Transaction_ID, 
   	Contract_Charge_Item.Sequence, 
	'Adjustment'  AS Category, 
   	Type = CASE WHEN Lookup_Table.Value IS NOT NULL
		 THEN Lookup_Table.Value
		 ELSE '*** Undefined ***'
		 END, 
	Contract_Charge_Item.Charge_description, 
   	Contract_Charge_Item.Unit_Type AS Period, 
   	Contract_Charge_Item.Quantity, 
   	Contract_Charge_Item.Unit_Amount AS Dollars_Per_Period, 
   	Contract_Charge_Item.Amount 
		- Contract_Charge_Item.GST_Amount_Included
    		- Contract_Charge_Item.PST_Amount_Included 
		- Contract_Charge_Item.PVRT_Amount_Included AS Amount, 
	GST_Amount = CASE WHEN Contract_Charge_Item.GST_Amount_Included > 0
			THEN Contract_Charge_Item.GST_Amount_Included
			ELSE Contract_Charge_Item.GST_Amount
		     END, 
   	PST_Amount = CASE WHEN Contract_Charge_Item.PST_Amount_Included > 0
			THEN Contract_Charge_Item.PST_Amount_Included
			ELSE Contract_Charge_Item.PST_Amount
		     END, 
   	PVRT_Amount = CASE WHEN Contract_Charge_Item.PVRT_Amount_Included > 0
			THEN Contract_Charge_Item.PVRT_Amount_Included
			ELSE Contract_Charge_Item.PVRT_Amount
		     END, 
   	Contract_Charge_Item.Amount 
		+ Contract_Charge_Item.GST_Amount
    		+ Contract_Charge_Item.PST_Amount 
		+ Contract_Charge_Item.PVRT_Amount AS Total, 
	Contract_Billing_Party.Billing_Method,
	Contract_Charge_Item.Charged_By, 
   	Contract_Charge_Item.Charged_On
FROM 	Contract_Charge_Item WITH(NOLOCK)
	INNER 
	JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
		AND Contract_Charge_Item.Charge_Item_Type = 'a'
	LEFT 
	JOIN
   	Lookup_Table 
		ON Contract_Charge_Item.Charge_Type = Lookup_Table.Code
		AND Lookup_Table.Category = 'Charge Type Adjustment'

UNION ALL

SELECT Contract_Charge_Item.Business_Transaction_ID, 
   	Contract_Charge_Item.Sequence, 
	'Reimbursement' AS Category, 
   	Type = CASE WHEN Lookup_Table.Value IS NOT NULL
		 THEN Lookup_Table.Value
		 ELSE '*** Undefined ***'
		 END, 
	Contract_Charge_Item.Charge_description, 
   	Contract_Charge_Item.Unit_Type AS Period, 
   	Contract_Charge_Item.Quantity, 
   	Contract_Charge_Item.Unit_Amount AS Dollars_Per_Period, 
   	Contract_Charge_Item.Amount 
		- Contract_Charge_Item.GST_Amount_Included
    		- Contract_Charge_Item.PST_Amount_Included 
		- Contract_Charge_Item.PVRT_Amount_Included AS Amount, 
	Contract_Charge_Item.GST_Amount, 
   	Contract_Charge_Item.PST_Amount, 
   	Contract_Charge_Item.PVRT_Amount, 
   	Contract_Charge_Item.Amount 
		+ Contract_Charge_Item.GST_Amount
    		+ Contract_Charge_Item.PST_Amount 
		+ Contract_Charge_Item.PVRT_Amount AS Total, 
	Contract_Billing_Party.Billing_Method,
	Contract_Charge_Item.Charged_By, 
   	Contract_Charge_Item.Charged_On
FROM 	Contract_Charge_Item WITH(NOLOCK)
	INNER 
	JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
		AND Contract_Charge_Item.Charge_Item_Type = 'r'
	LEFT 
	JOIN
   	Lookup_Table 
		ON Contract_Charge_Item.Charge_Type = Lookup_Table.Code
		AND Lookup_Table.Category = 'Charge Type Reimbursement'













GO
