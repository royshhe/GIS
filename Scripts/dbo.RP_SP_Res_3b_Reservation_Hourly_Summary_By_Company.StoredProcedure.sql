USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_3b_Reservation_Hourly_Summary_By_Company]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_3_Reservation_Hourly_Summary_By_Company
PURPOSE: Select all information needed for Reservation Hourly Summary by Company and Location
	 (Hourly and Time Interval) Reports

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/23
USED BY:  Reservation Hourly Summary by Company and Location (Hourly and Time Interval) Reports
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_3b_Reservation_Hourly_Summary_By_Company] --'2017/08/04', '*','*', '*'
(
	@paramPUDate varchar(20) = '15 April 1999',
	@paramVehicleTypeID char(5) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE @PUDate datetime

SELECT	@PUDate	= CONVERT(datetime, '00:00:00 ' + @paramPUDate)

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

SELECT 	Reservation.Source_Code,				-- source of reservation
	Reservation.Status,               			-- status of reservation
	Reservation.Pick_up_on,					-- date vehicle is claimed to pick up
	CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)) AS Pick_up_date,	-- date vehicle is picked up
	DATEPART(hh, Reservation.Pick_up_on) AS Pick_up_hour,	-- hour of the day vehicle is picked up
	Vehicle_Class.Vehicle_Type_ID,				-- vehicle type
	--Vehicle_Class.Vehicle_Class_Name,			 -- Vehicle class name
	Right(Convert(char(03), Vehicle_Class.DisplayOrder+100),2)+' - '+Vehicle_Class.Vehicle_Class_Name Vehicle_Class_Name,			 	-- Vehicle class name
	Owning_Company.Owning_Company_ID,			-- company ID
	Owning_Company.Name AS Company_Name,        		-- company name
	Location.Location_ID AS Location_ID, 			-- location ID
	Location.Location AS Location_Name,			-- location name
	COUNT(Reservation.Confirmation_Number) AS Res_cnt	-- total count of reservation

FROM 	Location with(nolock)	
	INNER JOIN 	
	Reservation 	
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Location.Rental_Location = 1
		--AND Reservation.Status = 'A'
	INNER  JOIN	
	Vehicle_Class	
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN	
	Owning_Company	
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Owning_Company.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Location.Location_ID)
	AND
	DATEDIFF(dd, CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)), @PUDate)= 0

GROUP BY 	
	Reservation.Source_Code,	
	Reservation.Status,
	Reservation.Pick_up_on,
	DATEPART(hh, Reservation.Pick_up_on),
	Vehicle_Class.Vehicle_Type_ID,
	Vehicle_Class.Vehicle_Class_Name,
	Owning_Company.Owning_Company_ID,
	Owning_Company.Name,
	Location.Location_ID,
	Location.Location,
	Vehicle_Class.DisplayOrder
order by Vehicle_Class.DisplayOrder

GO
