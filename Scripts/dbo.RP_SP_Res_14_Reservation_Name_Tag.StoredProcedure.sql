USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_14_Reservation_Name_Tag]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PROCEDURE NAME: RP_SP_Res_4_Reservation_Log_Name_List
PURPOSE: Select all information needed for Reservation Log - Name List Report

AUTHOR:	Roy He
DATE CREATED: 1999/01/01
USED BY:   Reservation - Name Tag
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_14_Reservation_Name_Tag]  --'21 apr 2015','21 Apr 2015','*','*','16'
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


SELECT	 
	
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Customer_Name,
	Confirmation_Number = CASE
				WHEN  RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Foreign_Confirm_Number IS NOT NULL
				THEN 	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Foreign_Confirm_Number
				ELSE  CAST( RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Confirmation_Number AS varchar(20))
			          END,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Pick_Up_Location_Name,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_1.Drop_Off_Location_Name,		          
	 
	CONVERT(char(5),
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Pick_Up_On, 8) AS Pick_Up_Time,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Pick_Up_On,
	RP_Res_4_Reservation_Log_Name_List_L1_Base_2.Vehicle_Class_Name
	 
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
	AND RP_Res_4_Reservation_Log_Name_List_L1_Base_2.FBP=1
	
	union
	
SELECT	 
	
	ResPWCon.Customer_Name,
	Confirmation_Number = CASE
				WHEN  ResPWCon.Foreign_Confirm_Number IS NOT NULL
				THEN 	ResPWCon.Foreign_Confirm_Number
				ELSE  CAST( ResPWCon.Confirmation_Number AS varchar(20))
			          END,
	ResPWCon.Pick_Up_Location_Name,
	ResPWCon.Drop_Off_Location_Name, 
	CONVERT(char(5),
	ResPWCon.Pick_Up_On, 8) AS Pick_Up_Time,
	ResPWCon.Pick_Up_On,
 
	ResPWCon.Vehicle_Class_Name
	 
FROM	RP_Res_4_Reservation_Log_Name_List_Prewrite_Contract ResPWCon with(nolock)
where 	(@paramVehicleClassID = '*'  OR ResPWCon.Vehicle_Class_ID = @paramVehicleClassID)
	AND
	(@paramCompanyID = '*'  OR CONVERT(INT, @tmpOwningCompanyID) = ResPWCon.Company_ID)
	AND
	(@paramPickUpLocationID = '*'  or CONVERT(INT, @tmpLocID) = ResPWCon.Pick_Up_Location_ID)
	AND
	ResPWCon.FBP=1
	AND 
	ResPWCon.Pick_Up_On BETWEEN @startDate AND @endDate

order by  Pick_Up_Location_Name,Pick_Up_On,Pick_Up_Time,Confirmation_Number
GO
