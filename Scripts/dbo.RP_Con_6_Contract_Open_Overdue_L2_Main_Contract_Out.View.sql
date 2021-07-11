USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out
PURPOSE: Select all information needed for Contract Out Configuration

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts
MOD HISTORY:
Name 		Date		Comments
Sharon L.	Dec 14, 2005	Join Reservation to get Res #.
*/


CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out]
AS

-- select all contracts opened on the request date. The current status of the contract can be anything.(CA, CO, CI, VD, OP)
SELECT DISTINCT 
	'Contract Out' AS Configuration,
	Contract.Status,
	Vehicle_Class.Vehicle_Type_ID, 
    	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name, 
	bt.RBR_Date,
	Contract.Contract_Number, 
    	Contract.Foreign_Contract_Number, 
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	NULL AS Unit_Number, 
	NULL AS KM_Driven,
	NULL AS MVA_Number, 
    	NULL AS Foreign_Vehicle_Unit_Number,
	NULL AS Model_Name, 
    	NULL AS Vehicle_Class_Name,
    	NULL AS Vehicle_Class_Code_Name,
	Contract.Pick_Up_On AS Check_Out_Date,	-- date contract is actually checked out
	Contract.Drop_Off_On AS Check_In_Date,	-- date contract is expected checked in
	Contract.Drop_Off_Location_ID,
	Loc2.Location AS Drop_Off_Location_Name,
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
    	Location Loc1
		ON Contract.Pick_Up_Location_ID = Loc1.Location_ID
		AND Loc1.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
    	Location Loc2
		ON Contract.Drop_Off_Location_ID = Loc2.Location_ID
	INNER 
	JOIN 
	Vehicle_Class
		ON Vehicle_Class.Vehicle_Class_Code = Contract.Vehicle_Class_Code
	INNER 
	JOIN
	Business_Transaction bt
  		ON bt.Contract_Number = Contract.Contract_Number
		AND bt.Transaction_Type = 'CON'
		AND bt.Transaction_Description = 'Open'
		-- select contracts that are opened only (not checked out) on the requested date
		AND bt.Contract_Number NOT IN (SELECT Contract_Number FROM Business_Transaction bt2
									WHERE bt2.Transaction_Type = 'CON' 
										AND  bt2.Transaction_Description = 'Check Out'
										AND  bt2.RBR_Date = bt.RBR_Date)
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
UNION ALL

-- select all contracts checked out on the request day and current status is check out or void or check in
SELECT 
	'Contract Out' AS Configuration,
	Contract.Status,
	Vehicle_Class.Vehicle_Type_ID, 
    	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name, 
	Business_Transaction.RBR_Date,
	Contract.Contract_Number, 
    	Contract.Foreign_Contract_Number,  
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number,
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	Vehicle_On_Contract.Unit_Number, 
	0 AS KM_Driven,
	Vehicle.MVA_Number AS MVA_Number, 
    	Vehicle.Foreign_Vehicle_Unit_Number,
	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Contract.Pick_Up_On AS Check_Out_Date,			-- date contract is actually checked out
	Check_In_Date = CASE WHEN Contract.Status = 'CO'  THEN
				 	Vehicle_On_Contract.Expected_Check_In	-- date contract is expected checked in when current status of the contract is check out
				ELSE Vehicle_On_Contract.Actual_Check_In	-- date contract is actually checked in when the current status of the contract is check in or voide
			END,
	Drop_Off_Location_ID = CASE WHEN Contract.Status = 'CO'  THEN
					Vehicle_On_Contract.Expected_Drop_Off_Location_ID --location contract is expected checked in when current status of the contract is check out
			          	          ELSE Vehicle_On_Contract.Actual_Drop_Off_Location_ID --location contract is actually checked in when current status of the contract is check in or void

			           END,
	Drop_Off_Location_Name =  CASE WHEN Contract.Status = 'CO' THEN
				              Loc2.Location
				    ELSE Loc3.Location
			           END,
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
		AND (Contract.Status = 'CO' OR Contract.Status = 'VD' OR Contract.Status = 'CI')
     		AND Vehicle_On_Contract.Checked_Out =
    			(SELECT MAX(Checked_Out)
      				FROM Vehicle_On_Contract
      					WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)
	INNER 
	JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
    	INNER 
	JOIN
    	Location Loc1
		ON Contract.Pick_Up_Location_ID = Loc1.Location_ID
		AND Loc1.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
    	Location Loc2
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Loc2.Location_ID

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
		AND Business_Transaction.Transaction_Description = 'Check Out'
	LEFT 
	JOIN
    	Location Loc3
		ON Vehicle_On_Contract.Actual_Drop_Off_Location_ID = Loc3.Location_ID
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
