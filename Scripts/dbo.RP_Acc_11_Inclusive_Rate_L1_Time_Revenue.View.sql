USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L1_Time_Revenue]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L1_Time_Revenue
PURPOSE: Get information about calculated time charges

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L4_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L1_Time_Revenue]
AS
SELECT 	Contract_Number, 
   	SUM(Amount - GST_Amount_Included - PST_Amount_Included - PVRT_Amount_Included)
    	AS Inclusive_Time_Ravenue
FROM 	Contract_Charge_Item WITH(NOLOCK)
WHERE 	(Charge_Type = '10') 
	AND 
	(Charge_Item_Type = 'c')
GROUP BY Contract_Number










GO
