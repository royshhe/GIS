USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_4_Fleet_Vehicle_Utilization_2_Year_Comparison_SR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PROCEDURE NAME: RP_SP_Flt_4_Fleet_Vehicle_Utilization_2_Year_Comparison_SR
PURPOSE: Select information needed for subreports of
	 Vehicle Utilization - 2 Years Comparison Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Subreports of Vehicle Utilization - 2 Years Comparison Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/9/29	add vehicle type filtering
Joseph Tseung	1999/11/08	include On Rent vehicles for contracts still checked out to 
				to fix the inconsistency between this report and Vehicle UT-Current Report
*/
CREATE Procedure [dbo].[RP_SP_Flt_4_Fleet_Vehicle_Utilization_2_Year_Comparison_SR]
(
	-- target date
	@td_str varchar(20) = '1999/03/05 00:00',
	@paramVehicleTypeID char(5) = '*'
)
AS
DECLARE @td datetime
SELECT @td = CONVERT(datetime, @td_Str)

-- create IT_OR table

BEGIN TRAN

-- add vehicles "In Transit"
SELECT 	Vehicle.Unit_Number,
    	Vehicle_Movement.Movement_Out 	AS Date_Out,
    	Location.Location 			AS Out_Location,
    	Owning_Company.Name		AS Out_Location_OC,
    	Vehicle_Movement.Movement_In 	AS Date_In,
    	Location1.Location 		AS In_Location,
    	Owning_Company1.Name 		AS In_Location_OC,
    	Vehicle_History.Effective_On 	AS Vehicle_Status_Effective_On,
    	Vehicle_History.Vehicle_Status,
    	Condition_History.Effective_On	AS Condition_Status_Effective_On,
     	Condition_History.Condition_Status,
    	'c' 				AS Rental_Status,
    	Vehicle_Class.Vehicle_Type_ID
INTO 	#IT_OR
FROM 	Owning_Company with(nolock)
	INNER 
	JOIN
    	Location
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
     	INNER 	
	JOIN
    	Vehicle_Movement
		ON Location.Location_ID = Vehicle_Movement.Sending_Location_ID
     	INNER 
	JOIN
    	Owning_Company Owning_Company1
	INNER 
	JOIN
    	Location Location1
		ON Owning_Company1.Owning_Company_ID = Location1.Owning_Company_ID
     		ON Vehicle_Movement.Receiving_Location_ID = Location1.Location_ID
     	INNER 
	JOIN
    	Vehicle
		ON Vehicle_Movement.Unit_Number = Vehicle.Unit_Number
	INNER 
	JOIN
	Lookup_Table
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER 
	JOIN
    	Vehicle_History
		ON Vehicle.Unit_Number = Vehicle_History.Unit_Number
	INNER 
	JOIN
    	Condition_History
		ON Vehicle.Unit_Number = Condition_History.Unit_Number
    	INNER 
	JOIN 
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 	(Vehicle_Movement.Movement_Out =
					 (SELECT MAX(vm.Movement_Out)
					  FROM Vehicle_Movement vm with(nolock)
					  WHERE vm.Unit_Number= Vehicle_Movement.Unit_Number
					  AND   vm.Movement_Out <= @td))
	AND	  (Vehicle_History.Effective_On =
					 (SELECT MAX(vh.Effective_On)
					  FROM Vehicle_History vh with(nolock)
					  WHERE vh.Unit_Number= Vehicle_History.Unit_Number
					  AND   vh.Effective_On <= @td))
	AND	  (Condition_History.Effective_On =
					 (SELECT MAX(ch.Effective_On)
					  FROM Condition_History ch with(nolock)
					  WHERE ch.Unit_Number= Condition_History.Unit_Number
					  AND   ch.Effective_On <= @td))					
	AND	  (Vehicle_History.Vehicle_Status IN ('b','d','j','k'))			

-- add On_Rent Vehicles
INSERT INTO #IT_OR

SELECT 	Vehicle_On_Contract.Unit_Number,
    	Vehicle_On_Contract.Checked_Out 	AS Date_Out,
    	Location.Location 			AS Out_Location,
    	Owning_Company.Name 		AS Out_Location_OC,
    	Vehicle_On_Contract.Actual_Check_In 	AS Date_In,
    	ISNULL(Location1.Location, '') 		AS In_Location,
    	ISNULL(Owning_Company1.Name, '') 		AS In_Location_OC,
   	Vehicle_History.Effective_On 	AS Vehicle_Status_Effective_On,
    	Vehicle_History.Vehicle_Status,
    	Condition_History.Effective_On 	AS Condition_Status_Effective_On,
    	Condition_History.Condition_Status,
    	'b' 				AS Rental_Status,
    	Vehicle_Class.Vehicle_Type_ID
FROM 	Vehicle_On_Contract with(nolock)
	INNER 
	JOIN
    	Location
		ON Vehicle_On_Contract.Pick_Up_Location_ID = Location.Location_ID
		AND (Vehicle_On_Contract.Checked_Out =
					 (SELECT MAX(voc.Checked_Out)
					  FROM Vehicle_On_Contract voc with(nolock)
					  WHERE voc.Unit_Number= Vehicle_On_Contract.Unit_Number
					  AND   voc.Checked_Out <= @td))

     	INNER 
	JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID

     	INNER 
	JOIN
    	Vehicle
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
	INNER 
	JOIN
	Lookup_Table
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER 
	JOIN
    	Vehicle_History
		ON Vehicle.Unit_Number = Vehicle_History.Unit_Number
		AND	  (Vehicle_History.Effective_On =
					 (SELECT MAX(vh.Effective_On)
					  FROM Vehicle_History vh with(nolock)
					  WHERE vh.Unit_Number= Vehicle_History.Unit_Number
					  AND   vh.Effective_On <= @td))
		AND	  (Vehicle_History.Vehicle_Status IN ('b','d','j','k'))	
	INNER 
	JOIN
    	Condition_History
		ON Vehicle.Unit_Number = Condition_History.Unit_Number
		AND	  (Condition_History.Effective_On =
					 (SELECT MAX(ch.Effective_On)
					  FROM Condition_History ch with(nolock)
					  WHERE ch.Unit_Number= Condition_History.Unit_Number
					  AND   ch.Effective_On <= @td))		
    	INNER 
	JOIN
	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	LEFT 
	OUTER 
	JOIN
    		Location Location1
	   	INNER 
		JOIN
    		Owning_Company Owning_Company1
			ON Location1.Owning_Company_ID = Owning_Company1.Owning_Company_ID
	ON Vehicle_On_Contract.Actual_Drop_Off_Location_ID = Location1.Location_ID
		
				  		
COMMIT

SELECT 	Unit_Number,
   	Vehicle_Type_ID,
       	Rented =
       	CASE
			WHEN ((Date_In IS NULL) OR (@td < Date_In))
				 AND (Rental_Status = 'b')
			THEN 'Y'
			ELSE 'N'
	END,	
	Rentable =
	CASE WHEN Condition_Status IN ('a','d','f','h','j')
			THEN 'Y'
			ELSE 'N'
	END,
	Vehicle_Location =
	CASE
			WHEN ((Date_In IS NULL) OR (@td < Date_In))
			THEN Out_Location
			ELSE In_Location
	END,			
	Vehicle_Location_OC =
	CASE
			WHEN ((Date_In IS NULL) OR (@td < Date_In))
			THEN Out_Location_OC
			ELSE In_Location_OC
	END			
FROM 	#IT_OR with(nolock)
WHERE 	#IT_OR.Date_Out = (SELECT MAX(itor.Date_Out)
		 		 FROM #IT_OR itor with(nolock)
  				 WHERE itor.Unit_Number = #IT_OR.Unit_Number)
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
RETURN

























GO
