USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_8_Reservation_Breakdown_By_Maestro_Rate_Name]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_8_Reservation_Breakdown_By_Maestro_Rate_Name
PURPOSE: Select all information needed for Reservation Breakdown by Maestro Rate Name Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/23
USED BY:   Reservation Breakdown by Maestro Rate Name Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_8_Reservation_Breakdown_By_Maestro_Rate_Name]
(
	@paramStartDate varchar(20) = '01 Apr 1999',
	@paramEndDate varchar(20) = '01 Sep 1999',
	@paramVehicleTypeID char(5) = 'Car',
	@paramPickUpLocationID varchar(20) = '*',
	@paramRateName varchar(50) = '*'
)
AS
-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 
-- end of fixing the problem

SELECT 	
	Source_Code, 			-- source of reservation
	Location_ID,			-- location ID
	Location_Name, 			-- location name
	Pick_Up_On,			-- date vehicle is claimed to pick up
	Status,				-- status of reservation
	Vehicle_Type_ID, 		-- vehicle type
	Rate_Name,			-- name of vehicle's rate
	Count(Confirmation_Number) 	AS Res_Cnt	-- number of reservation

FROM	RP_Res_8_Reservation_Breakdown_By_Maestro_Rate_Name_L1_Base  with(nolock) 

WHERE 	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Location_ID)
	AND
	(@paramRateName = "*" OR Rate_Name LIKE @paramRateName)
	AND	
	Pick_Up_On BETWEEN @startDate AND @endDate

GROUP BY 	

	Source_Code,
	Location_ID,
	Location_Name,
	Pick_Up_On,
	Status,
	Vehicle_Type_ID,
	Rate_Name

GO
