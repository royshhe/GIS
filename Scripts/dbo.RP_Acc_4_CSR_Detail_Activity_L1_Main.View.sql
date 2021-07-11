USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_4_CSR_Detail_Activity_L1_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_4_CSR_Detail_Activity_L1_Main
PURPOSE: Select only the core records for the CSR Detail Activity Report.
	 Data for the 6 subreports is retrieved
	 in the separate views named "RP_Acc_4_CSR_Detail_subreport_name_SB_Base_1"
		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_4_CSR_Detail_Activity_L1_Main]
AS
SELECT 	
	Business_Transaction.RBR_Date, 
	Location.Location_ID, 
   	Location.Location AS Location_Name, 
   	RP__CSR_Who_Opened_The_Contract.User_ID	AS CSR_Name, 
   	Vehicle_Class.Vehicle_Type_ID
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	Location 
		ON Contract.Pick_Up_Location_ID = Location.Location_ID 
	INNER JOIN 
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER JOIN 
	Lookup_Table
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code	
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER JOIN
   	RP__CSR_Who_Opened_The_Contract 
		ON Contract.Contract_Number = RP__CSR_Who_Opened_The_Contract.Contract_Number
    	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'check in' 
	OR   Business_Transaction.Transaction_Description = 'check out') 
   	AND 
	(NOT (Contract.Status = 'vd'))
	AND 
   	(Location.Rental_Location = 1)

UNION 

-- Select Records for Opened Reservations subreport
SELECT 	
	Business_Transaction.RBR_Date, 
   	Reservation_Change_History.Pick_Up_Location_ID, 
   	Location.Location AS Location_Name, 
   	Reservation_Change_History.Changed_By AS CSR_Name, 
   	Vehicle_Class.Vehicle_Type_ID
FROM 	Location 
	INNER JOIN
   	Reservation_Change_History 
		ON Location.Location_ID = Reservation_Change_History.Pick_Up_Location_ID
    	INNER JOIN
   	Reservation 
		ON Reservation_Change_History.Confirmation_Number = Reservation.Confirmation_Number
    	INNER JOIN
   	Business_Transaction 
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    		ON Reservation.Confirmation_Number = Contract.Confirmation_Number
	INNER JOIN 
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER JOIN 
	Lookup_Table
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code	
		AND Lookup_Table.Category = 'BudgetBC Company'
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
   	(Business_Transaction.Transaction_Description = 'check out') 
   	AND
	 (NOT (Contract.Status = 'vd')) 
	AND 
   	(Reservation_Change_History.Changed_On =  (SELECT MIN(rch.changed_on)
     						FROM reservation_change_History rch
     						WHERE rch.confirmation_Number = contract.confirmation_Number))
    	AND 
	(Reservation.Source_Code = 'GIS')
	AND 
   	(Location.Rental_Location = 1)

UNION 

-- Select Records for Hand Held Check Ins subreport
SELECT 
	Business_Transaction.RBR_Date, 
   	Business_Transaction.Location_ID, 
   	Location.Location AS Location_Name, 
   	Business_Transaction.User_ID AS CSR_NAme, 
   	Vehicle_Class.Vehicle_Type_ID
FROM 	Business_Transaction 
	INNER JOIN
   	Location 
		ON Business_Transaction.Location_ID = Location.Location_ID 
	INNER JOIN
   	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN 
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER JOIN 
	Lookup_Table
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code	

		AND Lookup_Table.Category = 'BudgetBC Company'
WHERE 	
	(Business_Transaction.Transaction_Description = 'check in') 
   	AND 
	(Business_Transaction.Transaction_Type = 'con')
	AND 
   	(Location.Rental_Location = 1)


UNION 

-- Select Records for Sales Accessories (on separate acc. sale contract)  subreport
SELECT 
	Business_Transaction.RBR_Date, 
   	Business_Transaction.Location_ID, 
   	Location.Location AS Location_Name, 
   	Business_Transaction.User_ID AS CSR_NAme, 
   	'Truck' AS Vehicle_Type_ID
FROM 	Business_Transaction 
	INNER JOIN
   	Location 
		ON Business_Transaction.Location_ID = Location.Location_ID
	INNER JOIN 
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER JOIN 
	Lookup_Table
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code	
		AND Lookup_Table.Category = 'BudgetBC Company'
WHERE 	
	(Business_Transaction.Transaction_Description = 'Sale') 
   	AND 
	(Business_Transaction.Transaction_Type = 'SLS')
	AND 
   	(Location.Rental_Location = 1)






















GO
