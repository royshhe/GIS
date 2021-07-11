USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L2_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L2_Main
PURPOSE: Select all the information needed for 
	 Fleet Turn Back Schedule Summary - Daily Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Fleet Turn Back Schedule Summary - Daily Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L2_Main]
AS
SELECT 	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Turn_Back_Deadline, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Acquired_Date, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Unit_Number, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Program,
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Current_Licence_Plate, 
    	Vehicle_Model_Year.Model_Name, 
    	Lookup_Table.Value AS Vehicle_Rental_Status, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Current_Km, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Contract_Number, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Expected_Check_In, 
    	Location.Location, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Day_In_Service, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Month_In_Service, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Maximum_Km, 
    	Vehicle_Class.Vehicle_Type_ID, 
    	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Vehicle_Class_Code
FROM 	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base WITH(NOLOCK)
	INNER JOIN
    	Location
		ON RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Expected_Drop_Off_Location_ID = Location.Location_ID
	INNER JOIN
        Vehicle_Class
		ON RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Vehicle_Model_Year
		ON RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
	LEFT OUTER JOIN
	Lookup_Table
		ON RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L1_Base.Current_Rental_Status = Lookup_Table.Code
		AND Lookup_Table.Category = 'Vehicle Rental Status'
	
















GO
