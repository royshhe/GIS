USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_1_Foreign_Vehicle_Control_Main_AL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Flt_1_Foreign_Vehicle_Control_Main_AL
PURPOSE: Select all the information needed for Main Report of
	 Foreign Vehicle Control (by Available Location) Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/21
USED BY: Main report of Foreign Vehicle Control (by Available Location)
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/09/29	Add filtering on Vehicle Type,
				Vehicle Rental Status and Vehicle Condition Status

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_1_Foreign_Vehicle_Control_Main_AL]
(
	@paramAvailLocID varchar(20) = '*',
	@paramVehicleTypeID char(5) = '*',
	@paramVehicleRentalStatusID char(1) = '*',
	@paramVehicleConditionStatusID char(1) = '*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramAvailLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramAvailLocID
	END 
-- end of fixing the problem

SELECT RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Unit_Number,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Foreign_Vehicle_Unit_Number,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Vehicle_Owning_Company_ID,
    	Owning_Company.Name AS Vehicle_Owning_Cmp_Name,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Licence_Plate,
    	Vehicle_Model_Year.Model_Name,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_ID_Name,
    	Vehicle_Class.Vehicle_Type_ID,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Km,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Date_Out,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Expected_Date_In,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Available_Location_ID,
    	Location.Location AS Available_Location_Name,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.MTCN,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Customer_Name,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Rental_Status AS Vehicle_Rental_Status_ID,
    	Lookup_Table.Value AS Vehicle_Rental_Status,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Condition_Status AS Vehicle_Condition_Status_ID,
    	Lookup_Table1.Value AS Vehicle_Condition_Status,
    	RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Idle_Days
FROM 	RP_Flt_1_Foreign_Vehicle_Control_L1_Base with(nolock)
	INNER JOIN
	Owning_Company
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Vehicle_Owning_Company_ID = Owning_Company.Owning_Company_ID
	INNER JOIN
	Vehicle_Model_Year
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
	INNER JOIN
	Vehicle_Class
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Location
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Available_Location_ID = Location.Location_ID
	INNER JOIN
	Owning_Company Owning_Company1
		ON Location.Owning_Company_ID = Owning_Company1.Owning_Company_ID
	LEFT OUTER JOIN	
	Lookup_Table
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Rental_Status = Lookup_Table.Code
		 AND Lookup_Table.Category = 'Vehicle Rental Status'
	LEFT OUTER JOIN
	Lookup_Table Lookup_Table1
		ON RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Condition_Status = Lookup_Table1.Code
		 AND Lookup_Table1.Category = 'Vehicle Condition Status'
	INNER JOIN
	Lookup_Table Lookup_Table2
		ON Location.Owning_Company_ID = Lookup_Table2.Code
		AND Lookup_Table2.Category = 'BudgetBC Company'

WHERE 	(@paramAvailLocID = "*" or CONVERT(INT, @tmpLocID) = RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Available_Location_ID)
	AND	
	(@paramVehicleTypeID = "*" or Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND	
	(@paramVehicleRentalStatusID = "*" or RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Rental_Status = @paramVehicleRentalStatusID)
	AND	
	(@paramVehicleConditionStatusID = "*" or RP_Flt_1_Foreign_Vehicle_Control_L1_Base.Current_Condition_Status = @paramVehicleConditionStatusID)

GO
