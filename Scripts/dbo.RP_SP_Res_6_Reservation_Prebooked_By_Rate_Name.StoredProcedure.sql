USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_6_Reservation_Prebooked_By_Rate_Name]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_6_Reservation_Prebooked_By_Rate_Name
PURPOSE: Select all information needed for Reservation Prebooked by Rate Name Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:   Reservation Prebooked by Rate Name Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_6_Reservation_Prebooked_By_Rate_Name]
(
	@paramStartDate varchar(20) = '01 Apr 1999',
	@paramEndDate varchar(20) = '01 Sep 1999',
	@paramVehicleTypeID char(5) = 'Car',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '5555',
	@paramPickUpLocationID varchar(20) = '*',
	@paramRateType varchar(10) = '*',
	@paramRateName varchar(50) = '*'
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

SELECT 	Source_Code, 						-- source of reservation
	Owning_Company_ID,					-- owning company ID
	Company_Name,						-- owning company description
       	Location_ID, 						-- location ID
	Location_Name,						-- location name
       	CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)) AS Pick_up_date,	-- extract the date vehicle is claimed to pick up
	NumDaysBeforePU,					-- Number of days booked before pick up date
	Status,							-- status of reservation
	Vehicle_Type_ID, 					-- vehicle type
	Vehicle_Class_Code,					-- vehicle class id
	Vehicle_Class_Name,					-- vehicle class name
	Rate_Type,						-- GIS/Maestro
	Rate_Name,						-- name of vehicle's rate
	Count(Confirmation_Number) AS Res_Cnt			-- number of reservation

FROM 	RP_Res_6_Reservation_Prebooked_By_Rate_Name_L1_Base  with(nolock) 

WHERE	NumDaysBeforePU >= 0
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Location_ID)
	AND
	(@paramRateType = "*" OR Rate_Type = @paramRateType)
	AND
	(@paramRateName = "*" OR Rate_Name LIKE @paramRateName)
	AND	
	CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)) BETWEEN @startDate AND @endDate

GROUP BY 	
	Source_Code,
	Owning_Company_ID,
	Company_Name,
	Location_ID,
	Location_Name,
	CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)),
	NumDaysBeforePU,
	Status,

	Vehicle_Type_ID,
	Vehicle_Class_Code,
	Vehicle_Class_Name,
	Rate_Type,
	Rate_Name

GO
