USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Deposit_Refund_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_Deposit_Refund_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Deposit/Refund Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Deposit/Refund Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Deposit_Refund_SB_L1_Base_1]
AS
SELECT 	
	Transaction_Type = 
	CASE 
		WHEN Contract_Payment_Item.Amount  >= 0 
		THEN 'Deposit' 
		ELSE 'Refund' 
	END, 
   	Contract_Payment_Item.Business_Transaction_ID, 
   	Contract_Payment_Item.Contract_Number, 
	Location.Location, 
   	Contract_Payment_Item.Collected_By, 
   	Contract_Payment_Item.Collected_On, 
   	Contract_Payment_Item.Payment_Type, 
   	Contract_Payment_Item.Amount
FROM 	Contract_Payment_Item WITH(NOLOCK)
	INNER JOIN
   	Location 
		ON Contract_Payment_Item.Collected_At_Location_ID = Location.Location_ID
WHERE (Contract_Payment_Item.Payment_Type = 'Cash' 
	OR Contract_Payment_Item.Payment_Type = 'Credit Card')


















GO
