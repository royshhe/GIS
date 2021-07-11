USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_2_Reservation_Monthly_Comparison_By_Location_And_Vehicle_Class]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_2_Reservation_Monthly_Comparison_By_Location_And_Vehicle_Class
PURPOSE: Select all the information needed for Reservation (Monthly) Comparison
	 by Location/Vehicle Class Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/24
USED BY: Reservation (Monthly) Comparison by Location/Vehicle Class Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_2_Reservation_Monthly_Comparison_By_Location_And_Vehicle_Class]
(
	@paramMonthYear1 VARCHAR(20) = '1998/01',
	@paramMonthYear2 VARCHAR(20) = '1999/12',
	@paramVehicleTypeID char(5) = 'Car',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE @monthYear1 datetime,
	@monthYear2 datetime

SELECT	@monthYear1	= CONVERT(datetime, '00:00:00 ' + @paramMonthYear1 + '/01'),
	@monthYear2	= CONVERT(datetime, '00:00:00 ' + @paramMonthYear2 + '/01')	

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

SELECT  Reservation.Source_Code,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	CONVERT(datetime, CONVERT(varchar(20), DATENAME(month, Reservation.Pick_Up_On) + ' '
						             + DATENAME(Year, Reservation.Pick_Up_On))) AS Month_Year,
	Reservation.Status,
    	COUNT(Reservation.Confirmation_Number) 	AS Reservation_Count

FROM 	Reservation with(nolock)
	INNER
	JOIN
    	Vehicle_Class
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER
	JOIN
    	Location
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	INNER
	JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" OR CONVERT(INT, @tmpLocID) = Reservation.Pick_Up_Location_ID)
	AND
	(
	DATEDIFF(mm, Reservation.Pick_Up_On, @monthYear1) = 0
		OR
	DATEDIFF(mm, Reservation.Pick_Up_On, @monthYear2) = 0
	)

GROUP BY 	
	Reservation.Source_Code,
	Vehicle_Class.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code,
    	Vehicle_Class.Vehicle_Class_Name,
    	Location.Owning_Company_ID,
    	Owning_Company.Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location,
    	CONVERT(datetime, CONVERT(varchar(20), DATENAME(month, Reservation.Pick_Up_On) + ' '
						             + DATENAME(Year, Reservation.Pick_Up_On))),
	Reservation.Status

GO
