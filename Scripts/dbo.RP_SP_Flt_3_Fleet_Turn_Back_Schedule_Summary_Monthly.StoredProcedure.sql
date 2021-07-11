USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Monthly]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PROCEDURE NAME: RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Monthly
PURPOSE: Select all the information for Fleet Turn Back Schedule Summary - Monthly Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/24
USED BY: Fleet Turn Back Schedule Summary - Monthly Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/

CREATE PROCEDURE [dbo].[RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Monthly]
(
	@paramStartMonthYear VARCHAR(20) = '1999/01',
	@paramEndMonthYear VARCHAR(20) = '2001/12',
	@paramVehicleTypeID char(5) = 'Car',
	@paramVehicleClassID char(1) = '*'
)
AS
-- convert strings to datetime
DECLARE @startMonthYear datetime,
	@endMonthYear datetime

SELECT	@startMonthYear	= CONVERT(datetime, '00:00:00 ' + @paramStartMonthYear + '/01'),
	@endMonthYear	= CONVERT(datetime, '00:00:00 ' + @paramEndMonthYear + '/01')	

SELECT	Vehicle_Model_Year.Model_Name,
    	Vehicle_Class.Vehicle_Type_ID,
	CONVERT(Varchar(15), Vehicle.Unit_Number) AS Unit_Num,
	CONVERT(datetime, CONVERT(varchar(20), DATENAME(month, Vehicle.Turn_Back_Deadline) + ' ' + DATENAME(Year, Vehicle.Turn_Back_Deadline))) AS Turn_Back_Month_Year,
    	Vehicle_Class.Vehicle_Class_Code,
    	Vehicle_Class.Vehicle_Class_Name

FROM 	Vehicle_Class with(nolock)
	INNER JOIN
  	Vehicle
		ON Vehicle_Class.Vehicle_Class_Code = Vehicle.Vehicle_Class_Code
     	INNER JOIN
 	Vehicle_Model_Year
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
     	INNER JOIN
    	Lookup_Table
		ON Vehicle.Owning_Company_ID = Lookup_Table.Code

WHERE 	
	(Vehicle.Current_Vehicle_Status = 'b'
	 	OR  Vehicle.Current_Vehicle_Status = 'c'
	 	OR  Vehicle.Current_Vehicle_Status = 'd'
	 	OR  Vehicle.Current_Vehicle_Status = 'f'
	 	OR  Vehicle.Current_Vehicle_Status = 'g'
	 	OR  Vehicle.Current_Vehicle_Status = 'j'
	 	OR  Vehicle.Current_Vehicle_Status = 'k'
	 	OR  Vehicle.Current_Vehicle_Status = 'l')
	AND
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Vehicle_Class.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(DATEDIFF(mm, Vehicle.Turn_Back_Deadline, @startMonthYear) <= 0)
	AND
	(DATEDIFF(mm, Vehicle.Turn_Back_Deadline, @endMonthYear) >= 0)
	AND
	Vehicle.Deleted = 0	



















GO
