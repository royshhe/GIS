USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_7_Reservation_Summary_By_Vehicle_Class]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PROCEDURE NAME: RP_SP_Res_7_Reservation_Summary_By_Vehicle_Class
PURPOSE: Select all information needed for Reservation Summary by Vehicle Class Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:   Reservation Summary by Vehicle_Class Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE PROCEDURE [dbo].[RP_SP_Res_7_Reservation_Summary_By_Vehicle_Class]  --'2017-04-28', '2017-05-15'
(
	@paramStartDate varchar(20) = '01 Jul 1999',
	@paramEndDate varchar(20) = '15 Sep 1999',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*'

)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
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

DECLARE  @intHubID varchar(6)

if @paramHubID = ''
	select @paramHubID = '*'

if @paramHubID = '*'
	BEGIN
		SELECT @intHubID='0'
        END
else
	BEGIN
		SELECT @intHubID = @paramHubID
	END 

-- end of fixing the problem

SELECT	Reservation.Source_Code,
	Vehicle_Type.Vehicle_Type_ID,
    	Reservation.Vehicle_Class_Code AS Vehicle_Class_ID,
    	Right(Convert(char(03),Vehicle_Class.DisplayOrder+100),2) + '-' + Vehicle_Class.Vehicle_Class_Name  AS Vehicle_Class_Name,
    	Owning_Company.Owning_Company_ID AS CompanyID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID AS Pick_Up_Location_ID,
    	LEFT(Location.Location, 25) AS Pick_Up_Location_Name,
    	CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On)
		+ ' ' + DATENAME(month, Reservation.Pick_Up_On) + ' '
		+ DATENAME(Year, Reservation.Pick_Up_On))) AS Pick_Up_Day,
    	Reservation.Status,
    	COUNT(Reservation.Confirmation_Number) AS Reservation_Count

FROM 	Reservation  with(nolock) 
	INNER
	JOIN
    	Vehicle_Class
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER
	JOIN
    	Vehicle_Type
		ON Vehicle_Class.Vehicle_Type_ID = Vehicle_Type.Vehicle_Type_ID
     	INNER
	JOIN
  	Location
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	INNER
	JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID

WHERE 	(Reservation.Status IN ('N', 'O', 'A'))
	AND
	(@paramVehicleClassID = '*' OR Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramCompanyID = '*' OR CONVERT(INT, @tmpOwningCompanyID) = Owning_Company.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Reservation.Pick_Up_Location_ID)
	AND
	CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On)
		+ ' ' + DATENAME(month, Reservation.Pick_Up_On) + ' '
		+ DATENAME(Year, Reservation.Pick_Up_On))) BETWEEN @startDate AND @endDate
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = Location.Hub_ID)

GROUP BY	Reservation.Source_Code,
		Owning_Company.Name,
    		Location.Location,
		Vehicle_Type.Vehicle_Type_ID,
    		Vehicle_Class.Vehicle_Class_Name,
		CONVERT(datetime, CONVERT(varchar(20), DATENAME(day, Reservation.Pick_Up_On) + ' '
			+ DATENAME(month, Reservation.Pick_Up_On) + ' ' + DATENAME(Year, Reservation.Pick_Up_On))),
		Reservation.Status,
    		Reservation.Pick_Up_Location_ID,
    		Owning_Company.Owning_Company_ID,
		Reservation.Vehicle_Class_Code,
		Vehicle_Class.DisplayOrder
order by Vehicle_Class.DisplayOrder



 
GO
