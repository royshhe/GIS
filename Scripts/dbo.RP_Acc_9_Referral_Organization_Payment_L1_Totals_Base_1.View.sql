USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1
PURPOSE: Calculate contract time and kilometers charges and Optional Extra contract
	 charges for ('LDW','CARGO','PAI','PEC')

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: View RP_Acc_9_Referral_Organization_Payment_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1]
AS
SELECT 	Contract_Charge_Item.Contract_Number,
	SUM(	
		CASE
			WHEN 	Optional_Extra.Type = 'LDW' THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
				    	- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS LDW_Total,
	SUM(	
		CASE
			WHEN 	(Optional_Extra.Type in ( 'PAI','PAE')) THEN
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
			WHEN 	(Optional_Extra.Type IN ('PEC', 'CARGO','RSN')) THEN
					Contract_Charge_Item.Amount 
					- Contract_Charge_Item.GST_Amount_Included
			    		- Contract_Charge_Item.PST_Amount_Included 
					- Contract_Charge_Item.PVRT_Amount_Included
			ELSE
				0
		END
	) AS PEC_Cargo_Total,
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
	) AS Time_Km_Total		
FROM 	Contract_Charge_Item  WITH(NOLOCK) 		
	LEFT OUTER JOIN
	Optional_Extra 
		ON Optional_Extra.Optional_Extra_ID = Contract_Charge_Item.Optional_Extra_ID
WHERE 	(Contract_Charge_Item.Charge_Type IN ('10','11','50','51','52')
	 OR 
	 Optional_Extra.Type IN ('LDW','CARGO','PAI','PEC','PAE','RSN')
	)
	AND 
	Contract_Charge_Item.Charge_Item_Type ='c'
GROUP BY Contract_Charge_Item.Contract_Number
GO
