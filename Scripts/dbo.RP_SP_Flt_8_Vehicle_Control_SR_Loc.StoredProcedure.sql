USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_8_Vehicle_Control_SR_Loc]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
PROCEDURE NAME: RP_SP_Flt_8_Vehicle_Control_SR_Loc
PURPOSE: Select information about the owning company of all BRAC vehicles needed for Location subreport of Vehicle Control Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/13
USED BY:  Location subreport of Vehicle Control Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_8_Vehicle_Control_SR_Loc]
(
	@paramVehicleTypeID  char(5) = '*',
	@paramVehicleClassID char(1) = '*'

)
AS

SELECT	vMain.Unit_Number,
	vMain.Vehicle_Type_ID,
    	vMain.Vehicle_Class_Code,
	vMain.Vehicle_Class_Code_Name,
	vMain.Vehicle_Location_ID,
    	Location.Location 		AS Vehicle_Location_Name,
    	Location.Owning_Company_ID 	AS Vehicle_Location_OC_ID,
    	Owning_Company.Name 		AS Vehicle_Location_OC_Name

FROM 	RP_Flt_8_Vehicle_Control_L2_SR_Main vMain
	INNER JOIN
    	Location
		ON vMain.Vehicle_Location_ID = Location.Location_ID
	INNER JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID

WHERE  (@paramVehicleTypeID = "*" OR vMain.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR vMain.Vehicle_Class_Code = @paramVehicleClassID)
GO
