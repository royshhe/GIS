USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_In]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_In
PURPOSE: Select all information needed for Contract In Configuration

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/03/08	include foreign check in contracts
Sharon L.	Dec 14, 2005	Join Reservation to get Res #.
*/

CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_In]
AS
-- select all contracts that have been checked in 
SELECT DISTINCT
	'Contract In' AS Configuration,
	Contract.Status,
	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Actual_Drop_Off_Location_ID AS Drop_Off_Location_ID,
    	Loc1.Location AS Drop_Off_Location_Name, 
	Business_Transaction.RBR_Date AS Check_In_RBR_Date,
	Contract.Contract_Number, 
    	Contract.Foreign_Contract_Number, 
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	Vehicle_On_Contract.Unit_Number, 
	vehicle_On_Contract.KM_In - vehicle_On_Contract.KM_Out AS KM_Driven,
	Vehicle.MVA_Number AS MVA_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number,
	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Contract.Pick_Up_On AS Check_Out_Date,			-- date contract is actual checked out
	Vehicle_On_Contract.Actual_Check_In AS Check_In_Date,	-- date contract is actual checked in
	Contract.Pick_Up_Location_ID,
	Loc2.Location AS Pick_Up_Location_Name,
	NULL AS Days_Over,
    	Rate_Name = CASE WHEN Contract.Rate_ID IS NOT NULL-- GIS Rate
			THEN Vehicle_Rate.Rate_Name
		             ELSE Quoted_Vehicle_Rate.Rate_Name
		        END,
	Contract.Pre_Authorization_Method,
	vDep.Payment_Method,
	vDep.Advance_Deposit,
	NULL AS Accrued_Revenue  
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
    	Location Loc2
		ON Contract.Pick_Up_Location_ID = Loc2.Location_ID
	INNER 
	JOIN
	--drop off location is BRAC location
    	Lookup_Table 
		ON Loc1.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER 
	JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
	INNER 
	JOIN
	Vehicle_Model_Year
		On Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
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
	LEFT 
	JOIN
    	Vehicle_Rate 
		ON Contract.Rate_ID = Vehicle_Rate.Rate_ID 
		AND Contract.Rate_Assigned_Date >= Vehicle_Rate.Effective_Date
     		AND Contract.Rate_Assigned_Date <= Vehicle_Rate.Termination_Date
	LEFT 
	JOIN
    	Quoted_Vehicle_Rate 
		ON Contract.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit vDep
		ON vDep.Contract_Number = Contract.Contract_Number

	LEFT JOIN
        	dbo.Reservation 
		ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number






GO
