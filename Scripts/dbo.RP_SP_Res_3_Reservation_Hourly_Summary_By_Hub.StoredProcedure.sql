USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_3_Reservation_Hourly_Summary_By_Hub]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_3_Reservation_Hourly_Summary_By_Hub
PURPOSE: Select all information needed for Reservation Hourly Summary by Hub and Company
	 (Hourly and Time Interval) Reports

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/23
USED BY:  Reservation Hourly Summary by Hub and Company (Hourly and Time Interval) Reports
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_3_Reservation_Hourly_Summary_By_Hub]
(
	@paramPUDate varchar(20) = '01 Oct 1999',
	@paramVehicleTypeID char(5) = '*',
	@paramHubID char(25) = '*',
	@paramCompanyID	   varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE @PUDate datetime

SELECT	@PUDate	= CONVERT(datetime, '00:00:00 ' + @paramPUDate)

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpCompanyID varchar(20)

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpCompanyID='0'
        END
else
	BEGIN
		SELECT @tmpCompanyID = @paramCompanyID
	END 
-- end of fixing the problem

SELECT 	Reservation.Source_Code,			-- source of reservation
	Reservation.Status,               			-- status of reservation
	Reservation.Pick_up_on,			-- date vehicle is claimed to pick up
	CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)) 	AS Pick_up_date,	-- date vehicle is picked up
	DATEPART(hh, Reservation.Pick_up_on) 			AS Pick_up_hour,	-- hour of the day vehicle is picked up
	Vehicle_Class.Vehicle_Type_ID,				-- vehicle type
	Vehicle_Class.Vehicle_Class_Name,			 	-- Vehicle class name
	Location.Hub_ID,					 	-- Hub ID
	Lookup_Table.Value 	AS Hub_Name,			-- Hub Name
	Owning_Company.Owning_Company_ID,			-- company ID
	Owning_Company.Name 	AS Company_Name,        		-- company name
	Location.Location_ID 	AS Location_ID, 			-- location ID
	Location.Location 		AS Location_Name,		-- location name
	COUNT(Reservation.Confirmation_Number) 	AS Res_cnt	-- total count of reservation
FROM 	Location with(nolock)	
	INNER JOIN 	
	Reservation 	
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Reservation.Status = 'A'
	INNER JOIN	
	Vehicle_Class	
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	Owning_Company	
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER JOIN 	
	Lookup_Table 	
		ON Location.Hub_ID = Lookup_Table.Code
		AND Lookup_Table.Category = "Hub"

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramHubID = "*" or @paramHubID = Location.Hub_ID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpCompanyID) = Owning_Company.Owning_Company_ID)
	AND
	DATEDIFF(dd, CONVERT(datetime, CONVERT(varchar(12), Pick_Up_On, 112)), @PUDate)= 0

GROUP BY 	
	Reservation.Source_Code,
	Reservation.Status,
	Reservation.Pick_up_on,
	DATEPART(hh, Reservation.Pick_up_on),
	Vehicle_Class.Vehicle_Type_ID,
	Vehicle_Class.Vehicle_Class_Name,
	Lookup_Table.Category,
	Location.Hub_ID,
	Lookup_Table.Value,
	Owning_Company.Owning_Company_ID,
	Owning_Company.Name,
	Location.Location_ID,
	Location.Location,
	Vehicle_Class.DisplayOrder

	
order by Vehicle_Class.DisplayOrder
	

GO
