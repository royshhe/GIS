USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_8_Vehicle_Control_L2_SR_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_8_Vehicle_Control_L2_SR_Main
PURPOSE: Get the required information for Location and Owning Company Subreports of Vehicle Control Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/08
USED BY: RP_SP_Flt_8_Vehicle_Control_SR_Loc / RP_SP_Flt_8_Vehicle_Control_SR_OC
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung 	2000/03/31	Include the case where there is only one of vehicle on contract/vehicle
				movement records for selecting the location.
*/
CREATE VIEW [dbo].[RP_Flt_8_Vehicle_Control_L2_SR_Main]
AS
SELECT	Vehicle.Unit_Number,
	Vehicle_Class.Vehicle_Type_ID,
    	Vehicle.Vehicle_Class_Code,
	Vehicle.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
	Vehicle_Location_ID =
		CASE 
			-- if latest check out time is later than latest movement out time,
			-- then select location from VOC record
			WHEN vVoc.Checked_Out > vVM.Movement_Out THEN
			 	vVoc.Location_ID
			-- if latest check out time is earlier than latest movement out time,
			-- then select location from VM record
			WHEN vVoc.Checked_Out < vVM.Movement_Out THEN
			 	vVm.Location_ID
			-- if there is only vehicle on contract record with no vehicle movement record,
			-- then select location from VOC record
			WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NULL THEN
				vVoc.Location_ID
			-- if there is only vehicle movement record with no vehicle on contract record,
			-- then select location from VM record
			WHEN vVoc.Checked_Out IS NULL AND vVM.Movement_Out IS NOT NULL THEN
				vVm.Location_ID
			-- if latest check out and movement out times are the same, 
			-- then select the location from VOC or VM record with the larger km
			WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND vVoc.Checked_Out = vVM.Movement_Out AND ISNULL(vVoc.Km, 0) >= ISNULL(vVm.Km, 0) THEN
			 	vVoc.Location_ID
			WHEN vVoc.Checked_Out IS NOT NULL AND vVM.Movement_Out IS NOT NULL AND vVoc.Checked_Out = vVM.Movement_Out AND ISNULL(vVoc.Km, 0) < ISNULL(vVm.Km, 0) THEN
			 	vVm.Location_ID
			-- if there is no voc or vm record assocated with the vehicle
			-- select location from the vehicle inventory
			ELSE Vehicle.Current_Location_ID
		END
FROM 	Vehicle WITH(NOLOCK)
     	INNER JOIN
    	Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Lookup_Table
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code
	LEFT JOIN
	RP_Flt_8_Vehicle_Control_L1_Base_VOC vVoc
		ON Vehicle.Unit_Number = vVoc.Unit_Number
     		AND Vehicle.Current_Rental_Status IN ('a', 'b')
	LEFT JOIN
	RP_Flt_8_Vehicle_Control_L1_Base_VM vVm
		ON Vehicle.Unit_Number = vVm.Unit_Number

WHERE  (Lookup_Table.Category = 'BudgetBC Company')
	AND (	Vehicle.Current_Vehicle_Status = 'a'
		OR Vehicle.Current_Vehicle_Status = 'b'
		OR Vehicle.Current_Vehicle_Status = 'c'
	 	OR Vehicle.Current_Vehicle_Status = 'd'
	 	OR Vehicle.Current_Vehicle_Status = 'e'
		OR Vehicle.Current_Vehicle_Status = 'f'
	 	OR Vehicle.Current_Vehicle_Status = 'g' 		
		OR Vehicle.Current_Vehicle_Status = 'j'
		OR Vehicle.Current_Vehicle_Status = 'k'
	 	OR Vehicle.Current_Vehicle_Status = 'l' )
	AND
	Vehicle.Deleted = 0























GO
