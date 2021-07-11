USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_11_Reservation_Rate_Performance]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PROCEDURE NAME: RP_SP_Res_11_Reservation_Rate_Performance
PURPOSE: Select all information needed for Reservation Rate Performance Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY:  Reservation Rate Performance Report
MOD HISTORY:
Name 		Date		Comments

*/

CREATE PROCEDURE [dbo].[RP_SP_Res_11_Reservation_Rate_Performance]
(
	@paramStartBookDate varchar(20) = '01 Apr 1999',
	@paramEndBookDate varchar(20) = '01 Jul 1999',
	@paramStartPickUpDate varchar(20) = '31 Apr 1999',
	@paramEndPickUpDate varchar(20) = '31 Jul 1999',
	@paramVehicleTypeID char(5) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramOperator	   varchar(50) = '*',
	@paramRateName varchar(50) = '*'

)
AS
-- convert strings to datetime
DECLARE 	@startBookDate datetime,
		@endBookDate datetime,
		@startPickUpDate datetime,
		@endPickUpDate datetime

SELECT	@startBookDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBookDate),
		@endBookDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBookDate),
		@startPickUpDate = CONVERT(datetime, '00:00:00 ' + @paramStartPickUpDate),
		@endPickUpDate = CONVERT(datetime, '23:59:59 ' + @paramEndPickUpDate)

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

SELECT
	vRez.Source_Code,
    	vRez.Vehicle_Type_ID,
    	vRez.Vehicle_Class_Code,
     	vRez.Vehicle_Class_Name,
     	vRez.Owning_Company_ID,
    	vRez.Owning_Company_Name,
     	vRez.Pick_Up_Location_ID,
     	vRez.Pick_Up_Location_Name,
     	vRez.Booking_Date,
     	vRez.Pick_Up_Date,
	vRez.Operator_Name,
	Reservation_Number = CASE WHEN vRez.Foreign_Confirmation_Number IS NOT NULL
				        THEN vRez.Foreign_Confirmation_Number
			            	        ELSE Cast(vRez.GIS_Confirmation_Number AS char(20))
			            END,
	vRez.Status,
     	vRez.Renter_Name,
	vRez.Rate_Type,
     	vRez.Rate_ID,
     	vRez.Rate_Name,
     	vRez.Rate_Level,
     	Contract_Number = CASE WHEN vRezToCon.Status = 'VD' -- contract voided
				  THEN 'Voided'
				  WHEN vRezToCon.Status = 'CA' -- contract cancelled
				  THEN 'Cancelled'
				  Else Cast(vRezToCon.Contract_Number AS char(10))
			     END,
     	vRezToCon.Check_Out_RBR_Date,
	Rez_Change = 	CASE
			WHEN vRezToCon.Contract_Number IS NULL OR vRezToCon.Status IN ('VD','CA')
				THEN NULL
			WHEN vRezToCon.Contract_Number IS NOT NULL
				AND (vRez.Rate_ID <> vRezToCon.Rate_ID OR vRez.Rate_Level <> vRezToCon.Rate_Level OR vRez.Vehicle_Class_Code <> vRezToCon.Vehicle_Class_Code)
				THEN 'Y'
			Else  'N'
			END,
     	vCon.TimeKm_Charge,
     	vCon.LDW_Charge,
     	vCon.PAI_Charge,
     	vCon.PEC_Charge,
     	vCon.Cargo_Charge,
     	vCon.Rental_Days,
     	vCon.Km_Driven,
     	vRez.IATA_Number,
     	vRez.BCD_Number,
     	vRez.Res_Booking_City,
     	resCancelTime.ResCancelTime
FROM
	RP_Res_11_Reservation_Rate_Performance_L2_Base_Rez_Misc vRez
	LEFT
	JOIN
	RP_Res_11_Reservation_Rate_Performance_L2_Base_Res_Opened_To_Con vRezToCon
		ON  vRezToCon.Confirmation_Number = vRez.GIS_Confirmation_Number
	LEFT
	JOIN
	RP_Res_11_Reservation_Rate_Performance_L2_Base_Cont_Misc vCon
		ON vCon.Contract_Number = vRezToCon.Contract_Number
	LEFT
	JOIN
	RP__Reservation_Cancel_Time resCancelTime
		ON resCancelTime.Confirmation_Number = vRez.GIS_Confirmation_Number
		
WHERE
	(@paramVehicleTypeID = "*" OR vRez.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vRez.Owning_Company_ID)
	AND
	(@paramPickUpLocationID = "*" OR CONVERT(INT, @tmpLocID) = vRez.Pick_Up_Location_ID)
	AND
	vRez.Booking_Date BETWEEN @startBookDate AND @endBookDate
	AND
	vRez.Pick_Up_Date BETWEEN @startPickUpDate AND @endPickUpDate
	AND
	(@paramOperator = "*" OR vRez.Operator_Name = @paramOperator)
	AND
	(@paramRateName = "*" OR vRez.Rate_Name = @paramRateName)

GO
