USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_Contracts_L1_Main_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_7_CSR_Performance_Contracts_L1_Main_1
PURPOSE: Select the core records for the CSR Performance Report.
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_Contracts_L1_Main_1]
AS
SELECT 	Business_Transaction.RBR_Date, 
   	Business_Transaction.Contract_Number, 
	Contract.Confirmation_Number,
   	Business_Transaction.Transaction_Description, 
   	RP__CSR_Who_Opened_The_Contract.Location_ID 	AS Contract_Opened_At_Location_ID,
    	Location.Location 				AS Contract_Opened_At_Location_Name,
	RP__CSR_Who_Opened_The_Contract.User_ID
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	RP__CSR_Who_Opened_The_Contract 
		ON Business_Transaction.Contract_Number = RP__CSR_Who_Opened_The_Contract.Contract_Number
    	INNER JOIN
   	Location 
		ON RP__CSR_Who_Opened_The_Contract.Location_ID = Location.Location_ID
	INNER JOIN
	Contract
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
WHERE 	(Business_Transaction.Transaction_Type = 'Con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'Check Out' 
	OR Business_Transaction.Transaction_Description = 'Check In')
	AND 
	(Contract.Status IN ('Co','Ci'))



















GO
