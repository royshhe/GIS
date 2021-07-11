USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_6_Units_Available_For_Rent_SR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: RP_SP_Flt_6_Units_Available_For_Rent_SR
PURPOSE: Select all information needed for location and owning company subreports of Units Available for Rent Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/02/04
USED BY:  Location and Owning Company Subreports of Units Available for Rent Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Flt_6_Units_Available_For_Rent_SR]
(
	@paramVehicleTypeID  char(5) = '*'
)
AS
SELECT 	Unit_Number, 
	Vehicle_Type_ID,
    	Vehicle_Class_Code + ' - ' + Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	Vehicle_Owning_Company_ID, 
    	Vehicle_Owning_Company_Name, 
    	Vehicle_Location_ID,
    	Vehicle_Location_Name, 
    	Idle_Days,
 	Current_Km, 
    	Do_Not_Rent_Past_Km, 
    	Ownership_Date,
    	Do_Not_Rent_Past_Days

FROM	RP_Flt_6_Units_Available_For_Rent_L1_SR_Base with(nolock)

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)











GO
