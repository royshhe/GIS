USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
VIEW NAME: RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2
PURPOSE: Get the information about organization commission rate

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: View RP_Acc_9_Referral_Organization_Payment_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2]
AS
SELECT 	
	Business_Transaction.Contract_Number, 
	Business_Transaction.RBR_Date 		AS Check_Out_RBR_Date,
   	Commission_Rate.Flat_Rate, 
	Commission_Rate.Per_day,
   	Commission_Rate.Percentage
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	inner JOIN
   	Commission_Rate 
		ON Contract.Referring_Organization_ID = Commission_Rate.Organization_ID
    		AND Business_Transaction.RBR_Date >= Commission_Rate.Valid_From
    		AND Business_Transaction.RBR_Date <= Commission_Rate.Valid_To
WHERE 	(Business_Transaction.Transaction_Type = 'Con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'Check Out')























GO
