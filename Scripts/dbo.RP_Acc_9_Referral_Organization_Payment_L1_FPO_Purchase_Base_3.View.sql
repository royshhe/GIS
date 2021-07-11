USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3
PURPOSE: Get the information about FPO Purchase

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: View RP_Acc_9_Referral_Organization_Payment_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3]
AS
SELECT Contract_Number, SUM(CAST(FPO_Purchased AS INT))  AS FPO_Purchase
FROM 	Vehicle_On_Contract WITH(NOLOCK)
GROUP BY 
	Contract_Number


















GO
