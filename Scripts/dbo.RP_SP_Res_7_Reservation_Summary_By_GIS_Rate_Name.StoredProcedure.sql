USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_7_Reservation_Summary_By_GIS_Rate_Name]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_7_Reservation_Summary_By_GIS_Rate_Name
PURPOSE: Select all information needed for Reservation Summary by GIS Rate Name Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:   Reservation Summary by GIS Rate Name Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE PROCEDURE [dbo].[RP_SP_Res_7_Reservation_Summary_By_GIS_Rate_Name]
(
	@paramStartDate varchar(20) = '01 Jul 1999',
	@paramEndDate varchar(20) = '15 Sep 1999',
	@paramVehicleTypeID char(5) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramRateName varchar(50) = '*',
	@paramRateLevel char(5) = '*'
)
AS
-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)	


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

SELECT 	Source_Code,
	Vehicle_Type_ID,
	Vehicle_Class_ID,
    	Vehicle_Class_Name,
	Company_ID,
	Company_Name,
    	Pick_Up_Location_ID,
	Pick_Up_Location_Name,
	Pick_Up_Day,
    	Rate_Name,
	Rate_Level,
	Status,
    	COUNT(Confirmation_Number) AS Reservation_Count

FROM	RP_Res_7_Reservation_Summary_By_GIS_Rate_Name_L1_Base  with(nolock) 

WHERE 	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Vehicle_Class_ID = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Company_ID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Pick_Up_Location_ID)
	AND
	(@paramRateName = "*" OR Rate_Name LIKE @paramRateName)
	AND
	(@paramRateLevel = "*" OR Rate_Level = @paramRateLevel)
	AND	
	Pick_Up_Day BETWEEN @startDate AND @endDate

GROUP BY 	
	Source_Code,
	Vehicle_Type_ID,
	Vehicle_Class_ID,
   	Vehicle_Class_Name,
	Company_ID,
	Company_Name,
    	Pick_Up_Location_ID,
	Pick_Up_Location_Name,
	Pick_Up_Day,
	Rate_Name,
	Rate_Level,
	Status

GO
