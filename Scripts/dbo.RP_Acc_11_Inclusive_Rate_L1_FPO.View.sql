USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L1_FPO]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L1_FPO
PURPOSE: Get information about fuel purchase option amount included in the rate

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L1_FPO]
AS
SELECT 	Contract.Contract_Number, 
   	Charge_GL.GL_Revenue_Account, 	
	'FPO' 					AS Description, 
   	Vehicle_Class.Included_FPO_Amount 	AS Amount, 
   	'' 					AS GST_Exempt, 
	'' 					AS PST_Exempt
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    	INNER JOIN
   	Vehicle_Rate 
		ON Contract.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Contract.Rate_Assigned_Date >= Vehicle_Rate.Effective_Date 
		AND Contract.Rate_Assigned_Date <= Vehicle_Rate.Termination_Date
    	INNER JOIN
   	Charge_GL 
		ON Vehicle_Class.Vehicle_Type_ID = Charge_GL.Vehicle_Type_ID
WHERE 	(Charge_GL.Charge_Type_ID = 14)
	AND
	Vehicle_Rate.FPO_Purchased = 1













GO
