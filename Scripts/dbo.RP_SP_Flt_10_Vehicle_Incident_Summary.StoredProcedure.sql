USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_10_Vehicle_Incident_Summary]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PROCEDURE NAME: RP_SP_Flt_10_Vehicle_Incident_Summary
PURPOSE: Select all information needed for Vehicle Incident Summary Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/17
USED BY:  Vehicle Incident Summary Report
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/10/07	if a specific model/year is selected on the parameter screen, 
				only include vehicle support incidents for BRAC BC vehicles.

*/

CREATE PROCEDURE [dbo].[RP_SP_Flt_10_Vehicle_Incident_Summary]
(
	@paramStartDate varchar(20) = '01 Jan 1999',
	@paramEndDate varchar(20) = '31 May 1999',
	@paramStatus varchar(20) = '*',
	@paramIncidentType varchar(20) = '*',
	@paramProblemType varchar(20) = '*',
	@paramVehicleModel varchar(50) = '*',
	@paramVehicleYear varchar(4) = '*'
)
AS
-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpModelYear varchar(4)

if @paramVehicleYear = '*'
	BEGIN
		SELECT @tmpModelYear='0'
        END
else
	BEGIN
		SELECT @tmpModelYear = @paramVehicleYear
	END 
-- end of fixing the problem

SELECT 
	Logged_Date,
     	Incident_Number,
     	Contract_Number,
     	Foreign_Contract_Number,
     	Status, 
    	Renter_Name,
     	Unit_Number,
	Model_Name,
     	Model_Year,
     	Current_Location_Name,
     	Incident_Type,
	Problem_Type,
	Reason,
    	Problem_Type_And_Reason

FROM	RP_Flt_10_Vehicle_Incident_Summary_L2_Main with(nolock)

WHERE
	(@paramStatus = "*" OR Status = @paramStatus)
	AND
 	(@paramIncidentType = "*" OR Incident_Type = @paramIncidentType)
	AND
	(@paramProblemType = "*" OR Problem_Type = @paramProblemType)
	AND
	(@paramVehicleModel = "*" OR (Model_Name = @paramVehicleModel AND Is_BRAC_Vehicle = 'Y'))
	AND
	(@paramVehicleYear = "*" OR (Model_Year = @tmpModelYear AND Is_BRAC_Vehicle = 'Y'))
	AND
	Logged_Date BETWEEN @startDate AND @endDate

GO
