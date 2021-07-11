USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_1_General_Ledger_L2_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Acc_1_General_Ledger_L2_Base_1
PURPOSE: Get information about debit/credit amount and GL Account
	 associted with selected business transaction 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_1_General_Ledger
MOD HISTORY:
Name 		Date		Comments
*/ 
CREATE VIEW [dbo].[RP_Acc_1_General_Ledger_L2_Base_1]
AS
--SELECT SUBSTRING(Sales_Journal.GL_Account, 1,5) + '-' 
--	+ SUBSTRING(Sales_Journal.GL_Account, 6,2 ) + '-'
--	+ SUBSTRING(Sales_Journal.GL_Account, 8,1)  
--	+ 
--	        (case 
--		 when SUBSTRING(Sales_Journal.GL_Account, 9, 1)<>'' then
--			'-' + SUBSTRING(Sales_Journal.GL_Account, 9, 1)
--	                else
--	                	''
--	        end
--	        ) 
		SELECT Sales_Journal.GL_Account AS GL_Account_Number,
     	glchart.account_description AS GL_Account_Name, 
    	RP_Acc_1_General_Ledger_L1_Base_1.Document_Type, 
    	RP_Acc_1_General_Ledger_L1_Base_1.Document_Number, 
    	Location.Location AS Revenue_Location_Name, 
    	RP_Acc_1_General_Ledger_L1_Base_1.Revenue_Location_ID, 
    	RP_Acc_1_General_Ledger_L1_Base_1.RBR_Date, 
    	Debit  =	CASE 
		WHEN Sales_Journal.Amount >= 0 
		THEN Sales_Journal.Amount
		ELSE	0
		END,
	Credit =	CASE 
		WHEN Sales_Journal.Amount < 0 
		THEN ABS(Sales_Journal.Amount)
		ELSE	0
		END	
FROM 	RP_Acc_1_General_Ledger_L1_Base_1 WITH(NOLOCK)
	INNER JOIN
   	Sales_Journal 
		ON RP_Acc_1_General_Ledger_L1_Base_1.Business_Transaction_ID = Sales_Journal.Business_Transaction_ID
	INNER JOIN
    	Location 
		ON RP_Acc_1_General_Ledger_L1_Base_1.Revenue_Location_ID = Location.Location_ID
     	LEFT OUTER JOIN
    	glchart 
		ON Replace(Sales_Journal.GL_Account,'-', '') = glchart.account_code
WHERE	Sales_Journal.Business_Transaction_ID IN
		(SELECT sj.Business_Transaction_ID	
		 FROM Sales_Journal sj 		 
		 GROUP BY sj.Business_Transaction_ID
		 HAVING SUM(sj.Amount) <= 0
		)
GO
