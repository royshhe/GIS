USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_8_Vehicle_Control_SR_OC]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: RP_SP_Flt_8_Vehicle_Control_SR_OC
PURPOSE: Select information about the owning company of all BRAC vehicles for Owning Company subreport of Vehicle Control Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/13
USED BY:  Owning Company subreport of Vehicle Control Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Flt_8_Vehicle_Control_SR_OC] 
(
	@paramVehicleTypeID  char(5) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpLocID varchar(20), 
		@tmpOwningCompanyID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpOwningCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpOwningCompanyID = @paramCompanyID
	END
-- end of fixing the problem

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
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" OR CONVERT(INT, @tmpLocID) = vMain.Vehicle_Location_ID)
GO
