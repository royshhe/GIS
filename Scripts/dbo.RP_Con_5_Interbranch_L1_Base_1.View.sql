USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_L1_Base_1]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_L1_Base_1
PURPOSE: Select contracts that involved at least one vehicle for which 
       	- pick up location is foreign 
 	OR	
       	- drop off location is foreign 
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Con_5_Interbranch_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_L1_Base_1]
AS

SELECT DISTINCT Contract.Contract_Number
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
WHERE (Vehicle_On_Contract.Pick_Up_Location_ID IN
       			(SELECT Location.Location_ID
     			FROM 	Location 
				INNER JOIN
		        		Owning_Company 
					ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
         				INNER JOIN
        				Lookup_Table 
					ON Owning_Company.Owning_Company_ID <> Lookup_Table.Code
     			WHERE (Lookup_Table.Category = 'BudgetBC Company')))
	OR
   	(Vehicle_On_Contract.Actual_Drop_Off_Location_ID IN
       			(SELECT Location.Location_ID
     			FROM 	Location 
				INNER JOIN
        				Owning_Company 
					ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
         				INNER JOIN
        				Lookup_Table 
        					ON Owning_Company.Owning_Company_ID <> Lookup_Table.Code
     				WHERE (Lookup_Table.Category = 'BudgetBC Company'))
		)


UNION 

-- Select contracts that during the lifecycle of the contract have have involved a foreign vehicle
SELECT DISTINCT Contract.Contract_Number
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
    	INNER JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number 
	INNER JOIN
   	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID
    	INNER JOIN
  	Lookup_Table 
		ON Lookup_Table.Code <> Owning_Company.Owning_Company_ID
WHERE (Lookup_Table.Category = 'BudgetBC Company')

UNION 

-- Select contract for which Any Payment or Refund has been made at a foreign location
SELECT DISTINCT Contract.Contract_Number
FROM 	Location Location1 
	INNER JOIN
   	Contract_Payment_Item 
		ON Location1.Location_ID = Contract_Payment_Item.Collected_At_Location_ID
    	INNER JOIN
   	Owning_Company 
		ON Location1.Owning_Company_ID = Owning_Company.Owning_Company_ID
    	INNER JOIN
   	Lookup_Table 
		ON Owning_Company.Owning_Company_ID <> Lookup_Table.Code 
	INNER JOIN
   	Contract 
		ON Contract_Payment_Item.Contract_Number = Contract.Contract_Number
WHERE (Lookup_Table.Category = 'BudgetBC Company')













GO
