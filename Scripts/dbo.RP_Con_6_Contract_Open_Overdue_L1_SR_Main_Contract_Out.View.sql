USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Out]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Out
PURPOSE: Select all information needed for Location and Company Subtotals Subreports for Contract Out Configuration

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Out]
AS
-- this view is used in the Location Subtotals and Company Subtotals subreports for Contract Out Configuration
-- no need to select opened contracts since there is no vehicle class associated with it
-- select all contracts checked out on the request day and current status is check out or void or check in
SELECT 
	'Contract Out' AS Configuration,
	Vehicle_Class.Vehicle_Type_ID, 
    	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name, 
	Business_Transaction.RBR_Date,
	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name
FROM 	Contract
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND (Contract.Status = 'CO' OR Contract.Status = 'VD' OR Contract.Status = 'CI')
     		AND Vehicle_On_Contract.Checked_Out =
    			(SELECT MAX(Checked_Out)
      				FROM Vehicle_On_Contract
      					WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)
    	INNER 
	JOIN
    	Location Loc1
		ON Contract.Pick_Up_Location_ID = Loc1.Location_ID
		AND Loc1.Rental_Location = 1 -- Rental Locations
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
		AND Business_Transaction.Transaction_Description = 'Check Out'




















GO
