USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















/*
PROCEDURE NAME: RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR
PURPOSE: Select all information needed for all configurations of Location and Company Subtotals Subreports

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY:  Location and Company Subtotals Subreports of Contract Open Overdue Report
MOD HISTORY:
Name 		Date		Comments
Joseph T.       Sep 16, 1999	Add filtering to improve performance
Sharon L.	Jun 22, 2005	Include Accrued_Revenue for Subreport calculation
*/

CREATE PROCEDURE [dbo].[RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_SR]-- 'Open Contracts','31 MAR 2013','TRUCK'
(
	@Config varchar(20) = "Contract In",
	@ReportDate varchar(20) = '23 Apr 1999',
	@paramVehicleTypeID varchar(20) = '*'
--	@paramLocationID varchar(20) = '*'
)
AS
-- convert string to datetime type
DECLARE @@ReportDate datetime

SELECT @@ReportDate = CONVERT(datetime,  '00:00:00 ' + @ReportDate)


-- fix upgrading problem (SQL7->SQL2000)
--DECLARE  @tmpLocID varchar(20)

--if @paramLocationID = '*'
--	BEGIN
--		SELECT @tmpLocID='0'
--        END
--else
--	BEGIN
--		SELECT @tmpLocID = @paramLocationID
--	END 
-- end of fixing the problem


IF @Config = 'Contract Out'
BEGIN

SELECT
	Configuration,
	Vehicle_Type_ID,
    	Pick_Up_Location_ID AS Param_Location_ID,
    	Pick_Up_Location_Name AS Param_Location_Name,
    	Vehicle_Class_Code_Name,
	NULL AS Accrued_Revenue
FROM
	RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Out
WHERE
	DATEDIFF(dd, RBR_Date, @@ReportDate) = 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
--	AND
-- 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Pick_Up_Location_ID)
END
ELSE

IF @Config = 'Contract In'
BEGIN

SELECT
	Configuration,
	Vehicle_Type_ID,
    	Drop_Off_Location_ID AS Param_Location_ID,
    	Drop_Off_Location_Name AS Param_Location_Name,
    	Vehicle_Class_Code_Name,
	NULL AS Accrued_Revenue
FROM
	RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_In
WHERE
	DATEDIFF(dd, Check_In_RBR_Date, @@ReportDate) = 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
--	AND
-- 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Drop_Off_Location_ID)

END
ELSE
IF @Config = 'Contract Overdue'
BEGIN

SELECT
	Configuration,
	Vehicle_Type_ID,
    	Pick_Up_Location_ID AS Param_Location_ID,
    	Pick_Up_Location_Name  AS Param_Location_Name,
	Vehicle_Class_Code_Name,
	Accrued_Revenue
FROM
	RP_Con_6_Contract_Open_Overdue_L1_SR_Main_Contract_Overdue
WHERE
	DATEDIFF(dd, Expected_Drop_Off_Date, @@ReportDate) > 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
--	AND
-- 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Pick_Up_Location_ID)

END

ELSE
IF @Config = 'Open Contracts'
BEGIN
SELECT --DISTINCT
--	Contract.Contract_Number,
	'Open Contracts' AS Configuration,
	Vehicle_Class.Vehicle_Type_ID,
    	Contract.Pick_Up_Location_ID AS Param_Location_ID,
    	Loc1.Location AS Param_Location_Name,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Accrued_Revenue =
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 
										Then 0.5
										Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
									End)
							 / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 
										Then 0.5
										Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
									End)
							 / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 
										Then 0.5
										Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
									End)
							 * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 
										Then 0.5
										Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
									End)
							 * vCC.Total_Contract_Charge , 2)
			 ELSE 0
END
FROM 	Contract
	INNER
	JOIN
    	Vehicle_On_Contract
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		-- Be consistent with the Main report 
		-- per Rony's Request, not to include Void Contract
		--AND (Contract.Status = 'CO' OR Contract.Status = 'VD' OR Contract.Status = 'CI')
		AND (Contract.Status = 'CO'  OR Contract.Status = 'CI')


		-- Modified By Roy He
                -- Some time we have exact same check out time, that cause a problem. 
                -- so we use business transcation id instead.

                And (Vehicle_On_Contract.business_transaction_id = 
		(select max(voc1.business_transaction_id)
		from vehicle_on_contract voc1
		where voc1.contract_number = Vehicle_On_Contract.Contract_Number))

     		--AND Vehicle_On_Contract.Checked_Out =
    		--	(SELECT MAX(Checked_Out)
      		--		FROM Vehicle_On_Contract
      		--			WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)
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
		AND DATEDIFF(dd, Business_Transaction.RBR_Date, @@ReportDate) >= 0 --RBR date for the check out less than or equal to the requested date
		AND Business_Transaction.Contract_Number NOT IN (SELECT Contract_Number FROM Business_Transaction bt2
									WHERE bt2.Transaction_Type = 'CON'
									and bt2.Contract_Number=Contract.Contract_Number 
										AND  bt2.Transaction_Description = 'Check In'
										AND  DATEDIFF(dd,bt2.RBR_Date, @@ReportDate) >= 0) -- RBR date for the check in greater than requested date
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge vCC
		ON vCC.Contract_Number = Contract.Contract_Number

WHERE
	(@paramVehicleTypeID = '*' OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
--	AND
-- 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Contract.Pick_Up_Location_ID)

END
RETURN @@ROWCOUNT





















































GO
