USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Rental_Charge_Billing_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_Rental_Charge_Billing_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Rental Charge Billing Items Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Rental Charge Billing Items  Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 8 1999	GST, PST and PVRT fields show included tax if included 
				taxes are present 
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Rental_Charge_Billing_SB_L1_Base_1]
AS
SELECT Contract_Charge_Item.Business_Transaction_ID, 
   	Contract_Charge_Item.Charge_description, 
   	Contract_Charge_Item.Unit_Type, 
   	Contract_Charge_Item.Unit_Amount, 
   	Contract_Charge_Item.Quantity, 
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
	Contract_Charge_Item.Charge_Type,
	Contract_Charge_Item.Sequence,
	1 AS Sort_Sequence_Number
FROM 	Contract_Charge_Item 
	INNER JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
WHERE Contract_Charge_Item.Charge_Item_Type = 'c'

UNION ALL

SELECT Contract_Charge_Item_Audit.Business_Transaction_ID, 
   	Contract_Charge_Item_Audit.Charge_description, 
   	Contract_Charge_Item_Audit.Unit_Type, 
   	Contract_Charge_Item_Audit.Unit_Amount, 
   	Contract_Charge_Item_Audit.Quantity, 
   	Contract_Charge_Item_Audit.Amount 
		- Contract_Charge_Item_Audit.GST_Amount_Included
    		- Contract_Charge_Item_Audit.PST_Amount_Included
		 - Contract_Charge_Item_Audit.PVRT_Amount_Included AS Amount, 
   	GST_Amount = CASE WHEN Contract_Charge_Item_Audit.GST_Amount_Included > 0 
			THEN Contract_Charge_Item_Audit.GST_Amount_Included
			ELSE Contract_Charge_Item_Audit.GST_Amount
			END, 
   	PST_Amount = CASE WHEN Contract_Charge_Item_Audit.PST_Amount_Included > 0 
			THEN Contract_Charge_Item_Audit.PST_Amount_Included
			ELSE Contract_Charge_Item_Audit.PST_Amount
			END, 
   	PVRT_Amount = CASE WHEN Contract_Charge_Item_Audit.PVRT_Amount_Included > 0 
			THEN Contract_Charge_Item_Audit.PVRT_Amount_Included
			ELSE Contract_Charge_Item_Audit.PVRT_Amount
			END, 
	Contract_Charge_Item_Audit.Amount 
		+ Contract_Charge_Item_Audit.GST_Amount 
		+ Contract_Charge_Item_Audit.PST_Amount
		+ Contract_Charge_Item_Audit.PVRT_Amount AS Total,
   	Contract_Billing_Party.Billing_Method,
	Contract_Charge_Item_Audit.Charge_Type,
	Contract_Charge_Item_Audit.Sequence,
	2 AS Sort_Sequence_Number
FROM 	Contract_Charge_Item_Audit WITH(NOLOCK)
	INNER JOIN
   	Contract_Billing_Party 
		ON Contract_Charge_Item_Audit.Contract_Number = Contract_Billing_Party.Contract_Number
    		AND Contract_Charge_Item_Audit.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
WHERE Contract_Charge_Item_Audit.Charge_Item_Type = 'c'





















GO
