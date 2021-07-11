USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_In]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_In
PURPOSE: Select all information needed for Location and Company Subtotals Subreports for Contract In Configuration

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_In]
AS
-- select all contracts that have been checked in 
SELECT 
	'Contract In' AS Configuration,
	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Actual_Drop_Off_Location_ID AS Drop_Off_Location_ID,
    	Loc1.Location AS Drop_Off_Location_Name, 
	Business_Transaction.RBR_Date AS Check_In_RBR_Date,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name
FROM 	Contract
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND (Contract.Status = 'CI' OR Contract.Status = 'VD')
		AND Vehicle_On_Contract.Actual_Check_In IS NOT NULL
     		AND Vehicle_On_Contract.Actual_Check_In =
    			(SELECT MAX(Actual_Check_In)
      				FROM Vehicle_On_Contract
      					WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)
    	INNER 
	JOIN
    	Location Loc1
		ON Vehicle_On_Contract.Actual_Drop_Off_Location_ID = Loc1.Location_ID
		AND Loc1.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
	-- drop off location is a BRAC location
    	Lookup_Table 
		ON Loc1.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
     	INNER 
	JOIN
    	Vehicle_Class 
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER 
	JOIN
	Business_Transaction
  		ON Business_Transaction.Contract_Number = Contract.Contract_Number
		AND Business_Transaction.Transaction_Type = 'CON'
		AND Business_Transaction.Transaction_Description IN ('Check In', 'Foreign Check In')



































GO
