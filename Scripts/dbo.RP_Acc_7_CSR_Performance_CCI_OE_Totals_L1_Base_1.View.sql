USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1
PURPOSE: Calculate Contract Charge Items and Optional Extra totals
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/11/03	Correct Charge Type to calculate CFR Total
Roy  He              2004/05/03      Correct optional extra adjustment
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_CCI_OE_Totals_L1_Base_1]
AS
SELECT 	Contract_Charge_Item.Contract_Number,
	SUM(	
		CASE
			WHEN 	((Optional_Extra.Type IN ('LDW','BUYDOWN'))  OR (Charge_Type = 61 AND Charge_Item_Type = 'a')) THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
				    	- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS LDW_BD_Total,


	SUM(	
		CASE
			WHEN ((Optional_Extra.Type in ( 'PAI','PAE')) OR (Charge_Type = 62 AND Charge_Item_Type = 'a') )THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS PAI_Total,
	SUM(	
		CASE
			WHEN 	((Optional_Extra.Type in ( 'PEC','RSN'))  OR (Charge_Type = 63 AND Charge_Item_Type = 'a'))  THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS PEC_Total,
	SUM(	
		CASE
			WHEN 	Contract_Charge_Item.Charge_Type IN ('50','51','52') THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS Discount_Total,
	SUM(	
		CASE
			WHEN 	Contract_Charge_Item.Charge_Type IN ('10','11') THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS Time_Km_Total,
	SUM(	
		CASE
			WHEN 	Contract_Charge_Item.Charge_Type = '20' THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS Upgrade_Total,
	SUM(	
		CASE
			WHEN 	Contract_Charge_Item.Charge_Type = '30' THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS CFR_Total,
	SUM(	
		CASE
			WHEN 	Contract_Charge_Item.Charge_Type = '14' THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS FPO_Total
FROM 	Contract_Charge_Item   WITH(NOLOCK)
	LEFT OUTER JOIN
	Optional_Extra 
		ON Optional_Extra.Optional_Extra_ID = Contract_Charge_Item.Optional_Extra_ID
WHERE 	(Contract_Charge_Item.Charge_Type IN ('10','11','14','20','30','50','51','52','61','62','63')
	OR 
	Optional_Extra.Type IN ('LDW','BUYDOWN','PAI','PEC','PAE','RSN'))
GROUP BY Contract_Charge_Item.Contract_Number
GO
