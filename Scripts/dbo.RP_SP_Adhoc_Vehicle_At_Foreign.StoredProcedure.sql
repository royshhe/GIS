USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_Vehicle_At_Foreign]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Adhoc_Vehicle_At_Foreign
PURPOSE: Select information about the owning company of all BRAC vehicles for 
	 Main report of Vehicle Control Report
AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/09
USED BY:  Main report of Vehicle Control Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Adhoc_Vehicle_At_Foreign]
(
	@paramVehicleTypeID char(5) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpOwningCompanyID varchar(20)


if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpOwningCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpOwningCompanyID = @paramCompanyID
	END
-- end of fixing the problem

SELECT 	vBase.Unit_Number,
	vBase.MVA_Number, 
	vBase.Current_Licence_Plate,
	vBase.Model_Name,
	vBase.Model_Year,
    	vBase.Vehicle_Type_ID,
	vBase.Vehicle_Class_Code,
    	vBase.Vehicle_Class_Name,
	vBase.Exterior_Colour,
    	vBase.Vehicle_Rental_Status,
    	vBase.Vehicle_Condition_Status,
	--vBase.Vehicle_Status,
    	vBase.Current_Km,
	vBase.Vehicle_Location_ID,
    	vBase.Vehicle_Location_Name		AS Vehicle_Location_Name,
	vBase.Foreign_Company_ID,
	vBase.Foreign_Company_Name,
	vBase.Available_Since,
	vBase.Idle_Days,
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
    	vBase.Ownership_Date

FROM 	RP_Adhoc_vehicle_at_foreign_location vBase with(nolock)
	LEFT JOIN
    	RP_Flt_6_Units_Available_For_Rent_L1_Base_2 vVoc
		ON   vBase.Unit_Number = vVoc.Unit_Number
	LEFT JOIN
    	RP_Flt_6_Units_Available_For_Rent_L1_Base_3 vMv
		ON   vBase.Unit_Number = vMv.Unit_Number


WHERE 	(@paramVehicleTypeID = "*" OR vBase.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR vBase.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vBase.Foreign_Company_ID)

RETURN @@ROWCOUNT


GO
