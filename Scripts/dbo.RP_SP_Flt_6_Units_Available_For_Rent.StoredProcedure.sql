USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_6_Units_Available_For_Rent]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*
PROCEDURE NAME: RP_SP_Flt_6_Units_Available_For_Rent
PURPOSE: Select all information needed for Units Available for Rent Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/04
USED BY:  Units Available for Rent Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/20	Add fields Current_Km, Do_Not_Rent_Past_Km, Ownership_Date, Do_Not_Rent_Past_Days 	
				in order to show warning or restriction level of the vehicle unit on the report
Joseph Tseung	2000/02/02	If there is a movement subsequent to contract check in, then obtain "km in" 
				from the movement rather than from the contract.
Joseph Tseung	2000/02/02      Add parameters for vehicle type and vehicle's owning company 
Joseph Tseung	2000/02/04 	Add foreign company flag to determine which subreport to print
*/

CREATE PROCEDURE [dbo].[RP_SP_Flt_6_Units_Available_For_Rent]
(
	@paramVehicleTypeID varchar(5) = 'Car',
	@paramVehicleOwningCompanyID varchar(20) = '*',
	@paramVehicleLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*'

)

AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpLocID varchar(20), 
		@tmpOwningCompanyID varchar(20)

if @paramVehicleLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @paramVehicleLocationID
	END 

if @paramVehicleOwningCompanyID = '*'
	BEGIN
		SELECT @tmpOwningCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpOwningCompanyID = @paramVehicleOwningCompanyID
	END

DECLARE  @intHubID varchar(6)

if @paramHubID = ''
	select @paramHubID = '*'

if @paramHubID = '*'
	BEGIN
		SELECT @intHubID='0'
        END
else
	BEGIN
		SELECT @intHubID = @paramHubID
	END 

-- end of fixing the problem

SELECT 	
	vBase.Unit_Number,
	vBase.MVA_Number, 
    	vBase.Foreign_Vehicle_Unit_Number,
    	vBase.Model_Name,
	vBase.Vehicle_Type_ID,
    	vBase.Vehicle_Class_Code,
    	vBase.Vehicle_Class_Name,
    	vBase.Exterior_Colour,
    	vBase.Interior_Colour,
    	vBase.Current_Licence_Plate,
    	vBase.Vehicle_Owning_Company_ID,
    	vBase.Vehicle_Owning_Company_Name,
     	vBase.Vehicle_Rental_Status,
    	vBase.Vehicle_Condition_Status,
    	vBase.Available_Since,
    	vBase.Idle_Days,
    	vBase.Loc_Idle_Days,
    	Contract_Number = CASE WHEN (vVoc.Actual_Check_In IS NOT NULL AND vMv.Movement_In IS NOT NULL AND vVoc.Actual_Check_In >= vMv.Movement_In)
				OR (vVoc.Actual_Check_In IS NOT NULL AND vMv.Movement_In IS NULL) -- only voc history
			       THEN vVoc.Contract_Number
			       ELSE NULL
			  END,
    	Km_In = CASE 	WHEN (vVoc.Actual_Check_In IS NOT NULL AND vMv.Movement_In IS NOT NULL AND vVoc.Actual_Check_In >= vMv.Movement_In)  -- latest contract check in later than latest movement in 
				OR (vVoc.Actual_Check_In IS NOT NULL AND vMv.Movement_In IS NULL) -- no movement in history
			THEN vVoc.Km_In
			WHEN (vVoc.Actual_Check_In IS NOT NULL AND vMv.Movement_In IS NOT NULL AND vVoc.Actual_Check_In < vMv.Movement_In) --latest movement in later than contract check in
				OR (vVoc.Actual_Check_In IS NULL AND vMv.Movement_In IS NOT NULL) -- no contract check in history
			THEN vMv.Km_In
			ELSE NULL
		END,
    	vBase.Vehicle_Location_Name,
    	vBase.Vehicle_Location_ID,
    	vBase.Current_Km, 
    	vBase.Do_Not_Rent_Past_Km, 
    	vBase.Ownership_Date,
    	vBase.Do_Not_Rent_Past_Days,
	vBase.Foreign_OC

FROM 	RP_Flt_6_Units_Available_For_Rent_L1_Base_1 vBase with(nolock)
	LEFT 
	JOIN
    	RP_Flt_6_Units_Available_For_Rent_L1_Base_2 vVoc
		ON   vBase.Unit_Number = vVoc.Unit_Number
	LEFT
	JOIN
    	RP_Flt_6_Units_Available_For_Rent_L1_Base_3 vMv
		ON   vBase.Unit_Number = vMv.Unit_Number


WHERE
 	(@paramVehicleTypeID = '*' OR vBase.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleOwningCompanyID = '*' OR CONVERT(INT, @tmpOwningCompanyID) = vBase.Vehicle_Owning_Company_ID)
	AND
	(@paramVehicleLocationID = '*' or CONVERT(INT, @tmpLocID) = vBase.Vehicle_Location_ID)
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = vBase.Hub_ID)

RETURN @@ROWCOUNT



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
