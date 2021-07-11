USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Journal_Entries_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_Journal_Entries_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Journal Entries Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Journal Entries Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Journal_Entries_SB_L1_Base_1]
AS
SELECT 	
	Business_Transaction.Business_Transaction_ID, 
   	SUBSTRING(Sales_Journal.GL_Account, 1, 5) 
	+ '-' + SUBSTRING(Sales_Journal.GL_Account, 6, 2) 
	+ '-' + SUBSTRING(Sales_Journal.GL_Account, 8, 1) 
	+ '-' + SUBSTRING(Sales_Journal.GL_Account, 9, 1) AS GL_Account_Number, 
	ISNULL(glchart.account_description, '*** Undefined ***') AS GL_Account_Name,
   	Debit = CASE
		WHEN Sales_Journal.Amount > 0 THEN
			Sales_Journal.Amount
		ELSE
			0.0
		END,
	Credit  = CASE
		WHEN Sales_Journal.Amount < 0 THEN
			ABS(Sales_Journal.Amount)
		ELSE
			0.0
		END
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Sales_Journal 
		ON Business_Transaction.Business_Transaction_ID = Sales_Journal.Business_Transaction_ID
    	INNER JOIN
   	glchart 
		ON Sales_Journal.GL_Account = glchart.account_code


























GO
