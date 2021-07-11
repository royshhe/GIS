USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_4_Reservation_Log_Name_List]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PROCEDURE NAME: RP_SP_Res_4_Reservation_Log_Name_List
PURPOSE: Select all information needed for Reservation Log - Name List Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY:   Reservation Log - Name List Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 4 1999	add filtering to improve performance
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_4_Reservation_Log_Name_List] --'21 dec 2011','30 dec 2011','*','*','*'
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramVehicleClassID char(1) = '*',
	@paramCompanyID	   varchar(20) = '*',
	@paramPickUpLocationID varchar(20) = '*'
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
-- end of fixing the problem


SELECT	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Company_ID,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Company_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Pick_Up_Location_ID,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Pick_Up_Location_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Drop_Off_Location_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Customer_Name,
	Confirmation_Number = CASE
				WHEN  RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Foreign_Confirm_Number IS NOT NULL
				THEN 	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Foreign_Confirm_Number
				ELSE  CAST( RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Confirmation_Number AS varchar(20))
			          END,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Phone_Number,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Flight_Number,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Source_Code,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.EXE,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.BCN,
        RP_Res_4_Reservation_Log_Name_List_L1_Base_2.BCD_Number,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.APP,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.PDP,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.FBP,
	CONVERT(char(5),
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Pick_Up_On, 8) AS Pick_Up_Time,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Pick_Up_On,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Drop_Off_On,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Length,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.GIS_Rate_Level,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Vehicle_Type_ID,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.GIS_Rate_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Remarks,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Vehicle_Class_ID,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Vehicle_Class_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Rate_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Rate_Structure,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Authorized_DO_Charge,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Per_KM_Charge,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Time_Period,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Time_Period_End,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Time_Period_Start,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Amount,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Km_Cap,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.M_Rate_Type,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Status,
	null as contract_number
FROM	RP_Res_4_Reservation_Log_Name_List_L1_Base_1 with(nolock)
	INNER JOIN
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2
		ON RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Confirmation_Number = RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Confirmation_Number
where 	(@paramVehicleClassID = '*' OR RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Vehicle_Class_ID = @paramVehicleClassID)
	AND
	(@paramCompanyID =  '*'  OR CONVERT(INT, @tmpOwningCompanyID) = RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Company_ID)
	AND
	(@paramPickUpLocationID =  '*'  or CONVERT(INT, @tmpLocID) = RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Pick_Up_Location_ID)
	AND
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Pick_Up_On BETWEEN @startDate AND @endDate
	
	union
	
SELECT	ResPWCon.Company_ID,
	ResPWCon.Company_Name,
	ResPWCon.Pick_Up_Location_ID,
	ResPWCon.Pick_Up_Location_Name,
	ResPWCon.Drop_Off_Location_Name,
	ResPWCon.Customer_Name,
	Confirmation_Number = CASE
				WHEN  ResPWCon.Foreign_Confirm_Number IS NOT NULL
				THEN 	ResPWCon.Foreign_Confirm_Number
				ELSE  CAST( ResPWCon.Confirmation_Number AS varchar(20))
			          END,
	ResPWCon.Phone_Number,
	ResPWCon.Flight_Number,
	ResPWCon.Source_Code,
	ResPWCon.EXE,
	ResPWCon.BCN,
        ResPWCon.BCD_Number,
	ResPWCon.APP,
	ResPWCon.PDP,
	ResPWCon.FBP,
	CONVERT(char(5),
	ResPWCon.Pick_Up_On, 8) AS Pick_Up_Time,
	ResPWCon.Pick_Up_On,
	ResPWCon.Drop_Off_On,
	ResPWCon.Length,
	ResPWCon.GIS_Rate_Level,
	ResPWCon.Vehicle_Type_ID,
	ResPWCon.GIS_Rate_Name,
	ResPWCon.Remarks,
	ResPWCon.Vehicle_Class_ID,
	ResPWCon.Vehicle_Class_Name,
	ResPWCon.M_Rate_Name,
	ResPWCon.M_Rate_Structure,
	ResPWCon.M_Authorized_DO_Charge,
	ResPWCon.M_Per_KM_Charge,
	ResPWCon.M_Time_Period,
	ResPWCon.M_Time_Period_End,
	ResPWCon.M_Time_Period_Start,
	ResPWCon.M_Amount,
	ResPWCon.M_Km_Cap,
	ResPWCon.M_Rate_Type,
	ResPWCon.Status,
	ResPWCon.Contract_Number 
FROM	RP_Res_4_Reservation_Log_Name_List_Prewrite_Contract ResPWCon with(nolock)
where 	(@paramVehicleClassID = '*'  OR ResPWCon.Vehicle_Class_ID = @paramVehicleClassID)
	AND
	(@paramCompanyID = '*'  OR CONVERT(INT, @tmpOwningCompanyID) = ResPWCon.Company_ID)
	AND
	(@paramPickUpLocationID = '*'  or CONVERT(INT, @tmpLocID) = ResPWCon.Pick_Up_Location_ID)
	AND
	ResPWCon.Pick_Up_On BETWEEN @startDate AND @endDate

order by Company_Name,Pick_Up_Location_Name,Pick_Up_On,Pick_Up_Time,Confirmation_Number
GO
