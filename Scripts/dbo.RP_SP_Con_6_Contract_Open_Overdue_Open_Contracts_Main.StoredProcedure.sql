USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*
PROCEDURE NAME: RP_SP_Con_6_Contract_Open_Overdue_Main
PURPOSE: Select all information needed for all configurations in main Contract Open Overdue Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Contract Open Overdue Report
MOD HISTORY:
Name 		Date		Comments
Joseph T.           Sep 16, 1999	Add filtering to improve performance
Sharon L.	Dec 14, 2005	Join Reservation to get Res #.
*/
	--select max(rbr_date) from rbr_date
CREATE PROCEDURE [dbo].[RP_SP_Con_6_Contract_Open_Overdue_Open_Contracts_Main] --  'Open Contracts','01 APR 2018','*', '*'
(
	@Config varchar(20) = 'Open Contracts',
	@ReportDate varchar(20) = '20 Jan 2011',
	@paramVehicleTypeID varchar(20) = '*',
	@paramLocationID varchar(20) = '*'
)
AS
-- convert string to datetime type
DECLARE @@ReportDate datetime

SELECT @@ReportDate = CONVERT(datetime,  '00:00:00 ' + @ReportDate)

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 
-- end of fixing the problem


IF @Config = 'Contract Out'
BEGIN

SELECT	--DISTINCT
	Configuration,
	Status,
	Vehicle_Type_ID,
    	Pick_Up_Location_ID AS Param_Location_ID,
    	Pick_Up_Location_Name AS Param_Location_Name,
	--RBR_Date AS Param_Date,
	Contract_No = CASE WHEN Foreign_Contract_Number IS NOT NULL
				THEN Foreign_Contract_Number
				ELSE CAST(cco.Contract_Number AS varchar(20))
				END,
	Res_Number,
    	Customer_Name,
	Unit_No = CASE WHEN Foreign_Vehicle_Unit_Number IS NOT NULL
			      THEN Foreign_Vehicle_Unit_Number
			      ELSE CAST(Unit_Number AS varchar(20))
			END,
	MVA_Number, 
	Model_Name,
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Check_Out_Date,	-- date contract is actually checked out
	Check_In_Date,		-- date contract is expected checked in
	KM_Driven,
	Drop_Off_Location_ID AS Location_ID,
	Drop_Off_Location_Name AS Location_Name,
	Days_Over,
    	Rate_Name,
	Pre_Authorization_Method,
	Payment_Method,
	Advance_Deposit,
	Accrued_Revenue,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	CDB.DBName

FROM
	RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out CCO
		Left Join dbo.Contract_DirectBill_vw CDB
		on cdb.contract_number=cco.contract_number	
WHERE
	DATEDIFF(dd, RBR_Date, @@ReportDate) = 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Pick_Up_Location_ID)

ORDER BY
	Contract_No
END
ELSE

IF @Config = 'Contract In'
BEGIN

SELECT  --DISTINCT
	Configuration,
	Status,
	Vehicle_Type_ID,
    	Drop_Off_Location_ID AS Param_Location_ID,
    	Drop_Off_Location_Name AS Param_Location_Name,
	--Check_In_RBR_Date AS Param_Date,
	Contract_No = CASE WHEN Foreign_Contract_Number IS NOT NULL
				THEN Foreign_Contract_Number
				ELSE CAST(cci.Contract_Number AS varchar(20))
				END,
	Res_Number,
    	Customer_Name,
	Unit_No = CASE WHEN Foreign_Vehicle_Unit_Number IS NOT NULL
			      THEN Foreign_Vehicle_Unit_Number
			      ELSE CAST(Unit_Number AS varchar(20))			
				END,
	MVA_Number, 
	Model_Name,
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Check_Out_Date,			-- date contract is actual checked out
	Check_In_Date,			-- date contract is actual checked in
	KM_Driven,
	Pick_Up_Location_ID AS Location_ID,
	Pick_Up_Location_Name AS Location_Name,
	Days_Over,
    	Rate_Name,
	Pre_Authorization_Method,
	Payment_Method,
	Advance_Deposit,
	Accrued_Revenue,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	cdb.dbname

FROM
	RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_In cci
	Left Join dbo.Contract_DirectBill_vw CDB
		on cdb.contract_number=cci.contract_number		
WHERE
	DATEDIFF(dd, Check_In_RBR_Date, @@ReportDate) = 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)	AND
 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Drop_Off_Location_ID)

ORDER BY
	Contract_No
END
ELSE
IF @Config = 'Contract Overdue'
BEGIN

SELECT  --DISTINCT
	Configuration,
	Status,
	Vehicle_Type_ID,
    	Pick_Up_Location_ID AS Param_Location_ID,
    	Pick_Up_Location_Name  AS Param_Location_Name,
	--Expected_Drop_Off_Date AS Param_Date,
	Contract_No = CASE WHEN Foreign_Contract_Number IS NOT NULL
				THEN Foreign_Contract_Number
				ELSE CAST(ccov.Contract_Number AS varchar(20))
				END,
	Res_Number,
    	Customer_Name,
	Unit_No = CASE WHEN Foreign_Vehicle_Unit_Number IS NOT NULL
			      THEN Foreign_Vehicle_Unit_Number
			      ELSE CAST(Unit_Number AS varchar(20))
			END,
	MVA_Number, 
	Model_Name,
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Check_Out_Date,-- date contract is actually checked out
	Check_In_Date,	-- date contract is expected checked in
	KM_Driven,
	Drop_Off_Location_ID AS Location_ID, --expected drop off location
	Drop_Off_Location_Name AS Location_Name,
	Days_Over,
    	Rate_Name,
	Pre_Authorization_Method,
	Payment_Method,
	Advance_Deposit,
	Accrued_Revenue,
	[Time&KM],
	OptionalExtra,
	Coverage,
	SalesAccs,
	Upsell,
	OtherCharges,
	Discount,
	cdb.dbname
FROM
	RP_Con_6_Contract_Open_Overdue_L3_Main_Contract_Overdue ccov
		Left Join dbo.Contract_DirectBill_vw CDB
		on cdb.contract_number=ccov.contract_number	
WHERE
	DATEDIFF(dd, Expected_Drop_Off_Date, @@ReportDate) > 0
	AND
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Pick_Up_Location_ID)

ORDER BY
	Contract_No
END

ELSE
IF @Config = 'Open Contracts'
BEGIN
SELECT  --DISTINCT
	'Open Contracts' AS Configuration,
	Contract.Status,
	Vehicle_Class.Vehicle_Type_ID,
    	Contract.Pick_Up_Location_ID AS Param_Location_ID,
    	Loc1.Location AS Param_Location_Name,
	--NULL  AS Param_Date,
	--Business_Transaction.RBR_Date as param_date,
	Contract_No = CASE WHEN Contract.Foreign_Contract_Number IS NOT NULL
				THEN Contract.Foreign_Contract_Number
				ELSE CAST(Contract.Contract_Number AS varchar(20))
				END,
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name,
	Unit_No = CASE WHEN Vehicle.Foreign_Vehicle_Unit_Number IS NOT NULL
			      THEN Vehicle.Foreign_Vehicle_Unit_Number
			      ELSE CAST(Vehicle_On_Contract.Unit_Number AS varchar(20))
			END,          
	Vehicle.MVA_Number AS MVA_Number, 
	Vehicle_Model_Year.Model_Name,
    	Vehicle_Class.Vehicle_Class_Name,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Contract.Pick_Up_On AS Check_Out_Date,			-- date contract is actually checked out
	Check_In_Date = CASE WHEN Contract.Status = 'CO'  THEN
				 	Vehicle_On_Contract.Expected_Check_In	-- date contract is expected checked in when current status of the contract is check out
				ELSE Vehicle_On_Contract.Actual_Check_In	-- date contract is actually checked in when the current status of the contract is check in or voide
			END,
          KM_Driven = case WHEN Contract.Status = 'CO' THEN
				0
				else Vehicle_On_Contract.KM_In - Vehicle_On_Contract.KM_Out
				END,
	Location_ID = CASE WHEN Contract.Status = 'CO'  THEN
						Vehicle_On_Contract.Expected_Drop_Off_Location_ID --location contract is expected checked in when current status of the contract is check out
			          	          ELSE Vehicle_On_Contract.Actual_Drop_Off_Location_ID --location contract is actually checked in when current status of the contract is check in or void
			             END,
	Location_Name =  CASE WHEN Contract.Status = 'CO' THEN
				             		 Loc2.Location	-- expected drop off location
				   	    ELSE Loc3.Location	-- actual drop off location
			           	      END,
	NULL AS Days_Over,
    	Rate_Name = CASE WHEN Contract.Rate_ID IS NOT NULL-- GIS Rate
			THEN Vehicle_Rate.Rate_Name
		             ELSE Quoted_Vehicle_Rate.Rate_Name
		        END,
	Contract.Pre_Authorization_Method,
	vDep.Payment_Method,
	vDep.Advance_Deposit,
	Accrued_Revenue =
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  
				ROUND((
				
				(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 Then 0.5
					  Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
				End)
						
						
				
				/ CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((
				(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 Then 0.5
					  Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
				End)
						
				
				/ CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 Then 0.5
								 Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
							End)
						 * vCC.Total_Contract_Charge , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) >= 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(
							(Case When DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)=0 Then 0.5
								  Else DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate)
							End)
						 * vCC.Total_Contract_Charge , 2)
			 ELSE 0
			END,
	[Time&KM]=  CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.[Time&KM] , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.[Time&KM], 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.[Time&KM] , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.[Time&KM] , 2)
			 ELSE 0
			END,
	OptionalExtra=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.OptionalExtra , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.OptionalExtra , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.OptionalExtra , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.OptionalExtra , 2)
			 ELSE 0
			END,
	Coverage=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.Coverage , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.Coverage , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Coverage , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Coverage , 2)
			 ELSE 0
			END,

	SalesAccs=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.SalesAccs , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.SalesAccs , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.SalesAccs , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.SalesAccs , 2)
			 ELSE 0
			END,
	Upsell=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.Upsell , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.Upsell , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Upsell , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Upsell , 2)
			 ELSE 0
			END,
	OtherCharges=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.OtherCharges , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.OtherCharges , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.OtherCharges , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.OtherCharges , 2)
			 ELSE 0
			END,
	Discount=
		    CASE WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) AS DECIMAL)) * vCCDetail.Discount , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) <> 0
				THEN  ROUND((DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) / CAST( DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) AS DECIMAL)) * vCCDetail.Discount , 2)
			 WHEN Contract.Status = 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Expected_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Discount , 2)
			 WHEN Contract.Status <> 'CO' AND DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) > 0 AND DATEDIFF(dd, Contract.Pick_Up_On, Vehicle_On_Contract.Actual_Check_In) = 0
				THEN ROUND(DATEDIFF(dd, Contract.Pick_Up_On, @@ReportDate) * vCCDetail.Discount , 2)
			 ELSE 0
			END,
		cdb.DBName

FROM 	Contract
	INNER
	JOIN
    	Vehicle_On_Contract
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
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
    	Location Loc2
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Loc2.Location_ID
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
		AND Business_Transaction.Transaction_Description = 'Check Out'	
		AND DATEDIFF(dd, Business_Transaction.RBR_Date, @@ReportDate) >= 0 --RBR date for the check out less than or equal to the requested date
		 -- RBR date for the check in greater than requested date
		AND Business_Transaction.Contract_Number NOT IN (SELECT Contract_Number FROM Business_Transaction bt2
									WHERE bt2.Transaction_Type = 'CON'
										And bt2.Contract_number=Contract.Contract_Number
										AND  bt2.Transaction_Description = 'Check In'
										AND  DATEDIFF(dd,bt2.RBR_Date, @@ReportDate) >= 0)

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
	RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge vCC
		ON vCC.Contract_Number = Contract.Contract_Number
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L1_Contract_Charge_Detail vCCDetail
		ON vCCDetail.Contract_Number = Contract.Contract_Number
	LEFT
	JOIN
	RP_Con_6_Contract_Open_Overdue_L1_Base_Deposit vDep
		ON vDep.Contract_Number = Contract.Contract_Number

	LEFT JOIN
        	dbo.Reservation 
		ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number
	Left Join dbo.Contract_DirectBill_vw CDB
		on cdb.contract_number=dbo.contract.contract_number	
WHERE
	(@paramVehicleTypeID = '*' OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) = Contract.Pick_Up_Location_ID)


ORDER BY
	Contract_No
END


RETURN @@ROWCOUNT



GO
