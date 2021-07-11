USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L1_Contract_Info]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L1_Contract_Info
PURPOSE: Get contract related information 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L4_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L1_Contract_Info]
AS
SELECT 	Business_Transaction.RBR_Date, 
   	Business_Transaction.Contract_Number, 
	Business_Transaction.Business_Transaction_ID,
   	RP__Last_Vehicle_On_Contract.Actual_Check_In AS Date_Time_In,
    	Location.Location AS Pick_Up_Location_Name, 
   	Vehicle_Rate.Rate_Name, 
   	Location_Fee_Included = CASE
		WHEN Vehicle_Rate.Location_Fee_Included = 1 
		THEN 	'Y'
		ELSE 	'N'
	END
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	RP__Last_Vehicle_On_Contract 
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number
    	INNER JOIN
   	Location 
		ON Contract.Pick_Up_Location_ID = Location.Location_ID 
	INNER JOIN
   	Vehicle_Rate 
		ON Contract.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Contract.Rate_Assigned_Date >= Vehicle_Rate.Effective_Date 
		AND Contract.Rate_Assigned_Date <= Vehicle_Rate.Termination_Date
    	INNER JOIN
   	RP__First_Vehicle_On_Contract 
		ON Contract.Contract_Number = RP__First_Vehicle_On_Contract.Contract_Number
    	INNER JOIN
   	Vehicle 
		ON RP__First_Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
WHERE 	(Business_Transaction.Transaction_Type = 'con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'Check in') 
	AND
    	(Location.Owning_Company_ID IN (SELECT Code
     					FROM Lookup_Table
					WHERE Category = 'BudgetBC Company'))   -- local contracts ONLY
	AND 
   	(Vehicle.Owning_Company_ID IN	(SELECT Code
     					FROM Lookup_Table
     					WHERE Category = 'BudgetBC Company')) 
	AND 
	(NOT (Contract.Status = 'vd'))
	AND
   	((Vehicle_Rate.Location_Fee_Included = 1) 
	 OR	   
	 (Vehicle_Rate.FPO_Purchased = 1)
	 OR
	 Business_Transaction.Contract_Number IN
		(SELECT Contract_Number
		 FROM Contract_Optional_Extra
		 WHERE Contract_Optional_Extra.Included_In_Rate = '1')
	 OR
	 Business_Transaction.Contract_Number IN		 
		 (SELECT Contract_Number
		 FROM Contract_Sales_Accessory
		 WHERE Contract_Sales_Accessory.Included_In_Rate = 'Y'
		)	
	)























GO
