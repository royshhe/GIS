USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_2_Reservation_Yearly_Comparison_By_Location_And_Vehicle_Class]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_2_Reservation_Yearly_Comparison_By_Location_And_Vehicle_Class
PURPOSE: Select all the information needed for Reservation (Yearly) Comparison
	 by Location/Vehicle Class Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reservation (Yearly) Comparison by Location/Vehicle Class Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 23 1999	Add more filtering to improve performance
*/

CREATE Procedure [dbo].[RP_SP_Res_2_Reservation_Yearly_Comparison_By_Location_And_Vehicle_Class]
(
	@year1 VARCHAR(20) = '1998',
	@year2 VARCHAR(20) = '1999',
	@endMonth VARCHAR(20) = '31 December',
	@paramVehicleTypeID char(5) = 'Car',
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

SELECT 	Reservation.Source_Code,
	Vehicle_Type.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Vehicle_Class.Vehicle_Class_Name,
	Location.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	CONVERT(datetime, CONVERT(varchar(20), DATENAME(Year, Reservation.Pick_Up_On))) AS Year,
	Reservation.Status,
    	COUNT(Reservation.Confirmation_Number) AS Reservation_Count

FROM 	Reservation with(nolock)
	INNER
	JOIN
    	Vehicle_Class ON
    		Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER
	JOIN
    	Vehicle_Type ON
    		Vehicle_Class.Vehicle_Type_ID = Vehicle_Type.Vehicle_Type_ID
     	INNER
	JOIN
    	Location ON
    		Reservation.Pick_Up_Location_ID = Location.Location_ID
	INNER
     	JOIN
    	Owning_Company ON
    		Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
WHERE (
		(
		 (Reservation.Pick_Up_On >= Convert(datetime,'January ' + @year1)) AND
		 (Reservation.Pick_Up_On <= Convert(datetime,'23:59:59 ' + @endMonth + ' ' + @year1))
		)
		OR
		(
		 (Reservation.Pick_Up_On >= Convert(datetime,'January ' + @year2)) AND
		 (Reservation.Pick_Up_On <= Convert(datetime,'23:59:59 ' + @endMonth + ' ' + @year2))
		)
	)
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Type.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Location.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Reservation.Pick_Up_Location_ID)

GROUP BY	
	Reservation.Source_Code,
	Owning_Company.Name,
    	Location.Location,
	Vehicle_Type.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Name, CONVERT(datetime, CONVERT(varchar(20), DATENAME(Year, Reservation.Pick_Up_On))),
	Reservation.Status,
    	Reservation.Vehicle_Class_Code,
    	Location.Owning_Company_ID,
    	Reservation.Pick_Up_Location_ID
return

GO
