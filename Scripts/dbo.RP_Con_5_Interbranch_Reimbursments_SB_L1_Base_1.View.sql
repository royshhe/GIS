USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Reimbursments_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_Reimbursments_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Reimbursments Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reimbursments Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Reimbursments_SB_L1_Base_1]
AS
SELECT Business_Transaction.Business_Transaction_ID, 
   	Contract_Reimbur_and_Discount.Flat_Amount, 
   	Contract_Reimbur_and_Discount.Reimbursement_Reason, 
   	Contract_Reimbur_and_Discount.Entered_By, 
   	Contract_Reimbur_and_Discount.Entered_On
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract_Reimbur_and_Discount 
		ON Business_Transaction.Business_Transaction_ID = Contract_Reimbur_and_Discount.Business_Transaction_ID
WHERE (Contract_Reimbur_and_Discount.Type = 'Reimbursement')












GO
