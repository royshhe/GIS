USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L0_Base_Con_Unit_Number]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_L0_Base_Con_Unit_Number
PURPOSE: Find the matching business transaction in the voc table of a particular
	 business transaction. If not, return the previous business transaction in 
	 the voc table
AUTHOR:	Don Kirkby
DATE CREATED: 2000/01/18
USED BY: View RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con
MOD HISTORY:
Name 		Date		Comments

*/

CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L0_Base_Con_Unit_Number]
AS
SELECT	bt1.Business_Transaction_ID,
	MAX(bt2.business_transaction_id) voc_business_transaction_id
FROM	Business_Transaction bt1 WITH(NOLOCK)
LEFT
JOIN		Business_Transaction bt2
	JOIN	Vehicle_On_Contract voc2
	ON	bt2.Business_Transaction_ID = voc2.Business_Transaction_ID
ON	bt2.Contract_Number = bt1.Contract_Number
WHERE	bt2.business_transaction_id <= bt1.business_transaction_id
	AND bt1.Transaction_Description IN ('Check Out', 'Change', 'Check In', 'Foreign Check In')
GROUP
BY	bt1.business_transaction_id











GO
