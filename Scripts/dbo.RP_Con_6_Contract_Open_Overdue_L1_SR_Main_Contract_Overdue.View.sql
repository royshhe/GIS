USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Overdue]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Overdue
PURPOSE: Select all information needed for Location and Company Subtotals Subreports for Contract Overdue Configuration

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/04/17	Include Vehicle Support Check In contracts with null actual check in location in the voc record
Sharon L.	2005/06/22	Include Accrued_Revenue for SubReport calculation
*/
CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Overdue]
AS
-- this view is used in the Location Subtotals and Company Subtotals subreports for Contract Overdue Configuration
-- select all contracts currently checked out and expected drop off date is prior to today
SELECT 
	'Contract Overdue' AS Configuration,
	Vehicle_Class.Vehicle_Type_ID, 
    	Contract.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	Loc1.Location AS Pick_Up_Location_Name, 
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)) AS Expected_Drop_Off_Date,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Accrued_Revenue = CASE
			 WHEN DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0   
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, getDate()) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL(10,2))) * vCC.Total_Contract_Charge , 2) 
				ELSE ROUND((DATEDIFF(dd, Contract.Pick_Up_On, getDate()) * vCC.Total_Contract_Charge), 2) 
			 END
FROM 	Contract
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND Contract.Status = 'CO'
		AND (Vehicle_On_Contract.Actual_Check_In IS NULL OR Vehicle_On_Contract.Actual_Drop_Off_Location_ID IS NULL)
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
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge vCC
		ON vCC.Contract_Number = Contract.Contract_Number

























GO
