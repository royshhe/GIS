USE [GISData]
GO
/****** Object:  View [dbo].[RP__CSR_Who_Opened_The_Contract]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP__CSR_Who_Opened_The_Contract
PURPOSE: Select the CSR who Opened or Checked Out the contract 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reporting Views
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP__CSR_Who_Opened_The_Contract]
AS
SELECT 	
	User_ID, 
	Rbr_date,
	Contract_Number,
	Location_ID,
	Transaction_Date
FROM 	Business_Transaction WITH(NOLOCK)
WHERE 	
	(Transaction_Description = 'Open'  OR Transaction_Description = 'Check Out' or Transaction_Description = 'Foreign Check In' )
	AND 
    	(Transaction_Type = 'Con') 
	AND 
      	(Business_Transaction_ID =	(SELECT MIN(bt.Business_Transaction_ID)
      					FROM Business_Transaction bt
      					WHERE bt.Contract_Number = Business_Transaction.Contract_Number))























GO
