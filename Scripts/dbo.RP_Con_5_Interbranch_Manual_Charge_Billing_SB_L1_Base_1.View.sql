USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Manual_Charge_Billing_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Con_5_Interbranch_Manual_Charge_Billing_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Manual Charge Billing Items Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Manual Charge Billing Items Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/25	display 'Undefined' when the charge type
				is not defined in the lookup table.
Joseph Tseung	1999/12/02	Include RentBack charge items besides manual
Joseph Tseung	2000/01/24      Fix the double inclusion for manual or rentback charge
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Manual_Charge_Billing_SB_L1_Base_1]
AS
SELECT 	
	Contract_Charge_Item.Business_Transaction_ID, 
   	Charge = CASE WHEN lt.Value IS NOT NULL
		 THEN lt.Value
		 ELSE '*** Undefined ***'
		 END, 
   	Contract_Charge_Item.Charge_description, 
   	Contract_Charge_Item.Unit_Type, 
   	Contract_Charge_Item.Unit_Amount, 
   	Contract_Charge_Item.Quantity, 
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
	Contract_Charge_Item.Sequence,
	1 AS Sort_Sequence_Number
FROM 	Contract_Charge_Item WITH(NOLOCK)
	INNER 
	JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
		AND Contract_Charge_Item.Charge_Item_Type in ('m')
   	LEFT 
	JOIN
	Lookup_Table lt
		ON Contract_Charge_Item.Charge_Type = lt.Code
		AND lt.Category = (SELECT MIN(lt2.Category) 
						FROM Lookup_Table lt2
						WHERE lt.Code = lt2.Code
						AND lt2.Category in ('Charge Type Manual', 'Charge Type Rentback'))	


UNION ALL

SELECT 	
	Contract_Charge_Item_Audit.Business_Transaction_ID, 
   	Charge = CASE WHEN lt.Value IS NOT NULL
		 THEN lt.Value
		 ELSE '*** Undefined ***'
		 END, 
   	Contract_Charge_Item_Audit.Charge_description, 
   	Contract_Charge_Item_Audit.Unit_Type, 
   	Contract_Charge_Item_Audit.Unit_Amount, 
   	Contract_Charge_Item_Audit.Quantity, 
   	Contract_Charge_Item_Audit.Amount 
		- Contract_Charge_Item_Audit.GST_Amount_Included
    		- Contract_Charge_Item_Audit.PST_Amount_Included 
		- Contract_Charge_Item_Audit.PVRT_Amount_Included AS Amount, 
   	Contract_Charge_Item_Audit.GST_Amount, 
   	Contract_Charge_Item_Audit.PST_Amount, 
   	Contract_Charge_Item_Audit.PVRT_Amount, 
   	Contract_Charge_Item_Audit.Amount 
		+ Contract_Charge_Item_Audit.GST_Amount
    		+ Contract_Charge_Item_Audit.PST_Amount 
		+ Contract_Charge_Item_Audit.PVRT_Amount AS Total, 
	Contract_Billing_Party.Billing_Method,
	Contract_Charge_Item_Audit.Sequence,
	2 AS Sort_Sequence_Number
FROM 	Contract_Charge_Item_Audit 
	INNER 
	JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item_Audit.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item_Audit.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
		AND Contract_Charge_Item_Audit.Charge_Item_Type in ('m')
    	LEFT 
	JOIN
   	Lookup_Table lt
		ON Contract_Charge_Item_Audit.Charge_Type = lt.Code
		AND lt.Category = (SELECT MIN(lt2.Category) 
						FROM Lookup_Table lt2
						WHERE lt.Code = lt2.Code
						AND lt2.Category in ('Charge Type Manual', 'Charge Type Rentback'))	























GO
