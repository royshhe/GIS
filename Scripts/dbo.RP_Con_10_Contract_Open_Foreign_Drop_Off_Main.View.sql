USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_10_Contract_Open_Foreign_Drop_Off_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*
VIEW NAME: RP_Con_10_Contract_Open_Foreign_Drop_Off_Main
PURPOSE: Select all information needed for Contract Out Configuration

DATE CREATED: 2004/04/01
USED BY: Stored Procedure RP_SP_Con_10_Contract_Open_Foreign_Drop_Off_Main
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[RP_Con_10_Contract_Open_Foreign_Drop_Off_Main]
AS

-- select all contracts opened on the request date. The current status of the contract can be anything.(CA, CO, CI, VD, OP)
SELECT DISTINCT 
	'Contract Out' AS Configuration,
	--Contract.Status,
	Status = bt.transaction_description,
	Vehicle_Class.Vehicle_Type_ID, 
	bt.RBR_Date,
	Contract.Contract_Number, 
    	Contract.Foreign_Contract_Number, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	NULL AS Unit_Number, 
	NULL as Current_Licence_plate,
	NULL AS Model_Name, 
    	NULL AS Vehicle_Class_Name,
    	NULL AS Vehicle_Class_Code_Name,
	NULL as Vehicle_Owning_Company,
	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name, 
	Contract.Drop_Off_Location_ID as ExpectedDropOffLocID,
	Loc2.Location as ExpectedDropOffLoc,
	loc2.owning_company_id as ExpectedDOLocOCID,
	oc2.name as ExpectedDOOCName,
	NULL as ActualDropOffLocID,
	NULL as ActualDropOffLoc,
	NULL as ActualDOLocOCID,
	Contract.Pick_Up_On AS Check_Out_Date,	
	Contract.Drop_Off_On AS Check_In_Date,	
	Contract.Pre_Authorization_Method,
	vDep.Payment_Type,
	vDep.Advance_Deposit
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
	inner join
	owning_company oc2 
		on oc2.owning_company_id = loc2.Owning_Company_ID
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
	RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit vDep
		ON vDep.Contract_Number = Contract.Contract_Number




UNION ALL

-- select all contracts checked out on the request day and current status is check out or void or check in
SELECT 
	'Contract Out' AS Configuration,
	--Contract.Status,
	Status = Business_Transaction.transaction_description,
	Vehicle_Class.Vehicle_Type_ID,  
	Business_Transaction.RBR_Date,
	Contract.Contract_Number, 
    	Contract.Foreign_Contract_Number, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	Unit_number = case when Vehicle.Foreign_Vehicle_Unit_Number is null
			then convert(varchar(15),Vehicle_On_Contract.Unit_Number)
			else Vehicle.Foreign_Vehicle_Unit_Number
			end, 
	case when Vehicle.Current_licence_plate != ''
		then Vehicle.Current_licence_plate
		else vlh.licence_plate_number
		end			as Current_Licence_plate,
	--Vehicle.Current_Licence_plate,
	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	oc1.Name as Vehicle_Owning_Company,
	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name,
	ExpectedDropOffLocID = Vehicle_On_Contract.Expected_Drop_Off_Location_ID,
	ExpectedDropOffLoc = loc2.location,
	ExpectedDOLocOCID = loc2.owning_company_id,
	ExpectedDOOCName = oc2.name,
	ActualDropOffLocID = Actual_Drop_Off_Location_ID,
	ActualDropOffLoc = loc3.location,
	ActualDOLocOCID = loc3.owning_company_id,
	Contract.Pick_Up_On AS Check_Out_Date,			
	Check_In_Date = CASE WHEN Contract.Status = 'CO'  THEN
				 	Vehicle_On_Contract.Expected_Check_In	
				ELSE Vehicle_On_Contract.Actual_Check_In	
			END,
	
	Contract.Pre_Authorization_Method,
	vDep.Payment_Type,
	vDep.Advance_Deposit
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
	inner join
	owning_company oc1 
		on oc1.owning_company_id = Vehicle.owning_company_id
	inner join
	owning_company oc2 
		on oc2.owning_company_id = loc2.Owning_Company_ID
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
	left join
	vehicle_licence_history vlh
		on vlh.unit_number = vehicle_on_contract.unit_number
		and (vehicle_on_contract.Checked_out between vlh.attached_on and vlh.removed_on
			or vlh.removed_on is null)
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit vDep
		ON vDep.Contract_Number = Contract.Contract_Number







GO
