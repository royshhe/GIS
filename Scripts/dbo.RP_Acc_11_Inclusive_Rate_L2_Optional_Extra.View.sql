USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L2_Optional_Extra]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L2_Optional_Extra
PURPOSE: Calculate minumal Optional Extra charges 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L2_Optional_Extra]
AS
SELECT 	Contract_Number, 
	GL_Revenue_Account, 
	Optional_Extra, 
   	AMOUNT = CASE 
		WHEN Included_Weekly_Amount IS NULL 
   		THEN Days * Included_Daily_Amount 
		WHEN Days * Included_Daily_Amount <= Weeks * Included_Weekly_Amount 
		     AND 
   		     Days * Included_Daily_Amount <= Alt_Weeks * Included_Weekly_Amount
    						     + Alt_Days * Included_Daily_Amount 
		THEN Days * Included_Daily_Amount
    		WHEN Weeks * Included_Weekly_Amount <= Days * Included_Daily_Amount
    		     AND 
   		     Weeks * Included_Weekly_Amount <= Alt_Weeks * Included_Weekly_Amount
    						       + Alt_Days * Included_Daily_Amount 
		THEN Weeks * Included_Weekly_Amount
    		ELSE Alt_Weeks * Included_Weekly_Amount + Alt_Days * Included_Daily_Amount
    	END, 
	GST_Exempt = CASE
		WHEN GST_Exempt = 1 
		THEN 	'Y'
		ELSE 	''
	END, 
	PST_Exempt = CASE
		WHEN PST_Exempt = 1 
		THEN 	'Y'
		ELSE 	''
	END
FROM 	RP_Acc_11_Inclusive_Rate_L1_Optional_Extra WITH(NOLOCK)












GO
