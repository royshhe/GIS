USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_1_Foreign_Vehicle_Control_SR_AL]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Flt_1_Foreign_Vehicle_Control_SR_AL
PURPOSE: Select all the information needed for Subreport of
	 Foreign Vehicle Control (by Available Location) Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/21
USED BY: Subreport of Foreign Vehicle Control (by Available Location)
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/09/29	Add filtering on Vehicle Type,
				Vehicle Rental Status and Vehicle Condition Status
*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_1_Foreign_Vehicle_Control_SR_AL]
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

SELECT 	Unit_Number,
    	Foreign_Vehicle_Unit_Number,
    	Owning_Company_ID,
	Current_Rental_Status,
    	Current_Condition_Status,
    	Available_Location_Name,
    	Vehicle_Type_ID,
    	Available_Location_ID

FROM	RP_Flt_1_Foreign_Vehicle_Control_L1_SB_AL_Main with(nolock)

WHERE 	(@paramAvailLocID = "*" or CONVERT(INT, @tmpLocID) = Available_Location_ID)
	AND	
	(@paramVehicleTypeID = "*" or Vehicle_Type_ID = @paramVehicleTypeID)
	AND	
	(@paramVehicleRentalStatusID = "*" or Current_Rental_Status = @paramVehicleRentalStatusID)
	AND	
	(@paramVehicleConditionStatusID = "*" or Current_Condition_Status = @paramVehicleConditionStatusID)

GO
