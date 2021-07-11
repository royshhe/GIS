USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PROCEDURE NAME: RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily
PURPOSE: Select all the information needed for Fleet Turn Back Summary (Daily) Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Fleet Turn Back Summary (Daily) Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE Procedure [dbo].[RP_SP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily]	--'5000', '30 oct 2013', '30 oct 2013'
(
	@Km_Tolerance varchar(20) = '3000',
	@Start_Date varchar(25) = '1 January 2000',
	@End_Date varchar(25) = '1 December 2000'
)
AS
DECLARE @dStart datetime,
	@dEnd datetime,
	@Num_Km_Tolerance int


SELECT	@dStart = Convert(datetime,'00:00:00 ' + @Start_Date),
	@dEnd = Convert(datetime,'23:59:59 ' + @End_Date),
	@Num_Km_Tolerance = Convert(int, @Km_Tolerance)

SELECT 	Turn_Back_Deadline, 
	Acquired_Date,
	Unit_Number,
	Case when Program='1'
			then 'Program'
			else 'Risk'
	end as Program,
	Current_Licence_Plate,
	Model_Name,
	Vehicle_Rental_Status,
    	Current_Km, 	
	Contract_Number,
	Expected_Check_In,
    	Location,
	Day_In_Service,
    	Month_In_Service,
	Maximum_Km,
	Vehicle_Class_Code,
	Vehicle_Type_Id,
   	Km_Exceed =
    		CASE WHEN (Current_Km >= (Maximum_Km - @Num_Km_Tolerance)) Then
			'Y'
	 	ELSE
			NULL
		END
FROM 	RP_Flt_3_Fleet_Turn_Back_Schedule_Summary_Daily_L2_Main with(nolock)
WHERE	Turn_Back_Deadline BETWEEN @dStart AND @dEnd
   		OR Current_Km >= (Maximum_Km - @Num_Km_Tolerance)

return























GO
