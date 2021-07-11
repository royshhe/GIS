USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_1_Resnet_Billing_By_Company_And_Location]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_1_Resnet_Billing_By_Company_And_Location
PURPOSE: Select all information needed for Reznet Billing By Company and Location Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:  Reznet Billing By Company and Location Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Res_1_Resnet_Billing_By_Company_And_Location]
(
	@paramStartCreateDate varchar(20) = '01 April 1999',
	@paramEndCreateDate varchar(20) = '15 September 1999',
	@paramVehicleTypeID char(5) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE @startCreateDate datetime,
	@endCreateDate datetime

SELECT	@startCreateDate = CONVERT(datetime, '00:00:00 ' + @paramStartCreateDate),
	@endCreateDate	= CONVERT(datetime, '23:59:59 ' + @paramEndCreateDate)	

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

SELECT 	Reservation.Confirmation_Number,
    	Owning_Company.Owning_Company_ID AS Company_ID,
    	Owning_Company.Name AS Company_Name,
    	Reservation.Pick_Up_Location_ID,
    	Location.Location AS Pick_Up_Location_Name,
    	Vehicle_Class.Vehicle_Type_ID,
    	MIN(Reservation_Change_History.Changed_On) AS Create_Date,
	Owning_Company.Resnet_Charge
FROM 	Location with(nolock)
	INNER JOIN
    	Reservation
		ON Location.Location_ID = Reservation.Pick_Up_Location_ID
		AND Location.Rental_Location = 1
		AND Location.Resnet = 1
		AND Reservation.Source_Code = 'RezNet'
	INNER JOIN
	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	INNER JOIN
    	Reservation_Change_History
		ON Reservation.Confirmation_Number = Reservation_Change_History.Confirmation_Number
     	INNER JOIN
    	Vehicle_Class
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = Owning_Company.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" or CONVERT(INT, @tmpLocID) = Reservation.Pick_Up_Location_ID)
	
GROUP BY 	Owning_Company.Name,
		Location.Location,
    		Vehicle_Class.Vehicle_Type_ID,
    		Reservation.Confirmation_Number,
    		Owning_Company.Resnet_Charge,
    		Owning_Company.Owning_Company_ID,
    		Reservation.Pick_Up_Location_ID

HAVING 	MIN(Reservation_Change_History.Changed_On) BETWEEN @startCreateDate AND @endCreateDate

GO
