USE [GISData]
GO
/****** Object:  View [dbo].[RP_Rc_1_Current_Active_Rate_L1_Base_Param]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Rc_1_Current_Active_Rate_L1_Base_Param
PURPOSE: Select all active rates for Current Active Rate report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/11/20
USED BY: Stored Procedure RP_SP_Rc_1_Current_Active_Rate
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/11	Set Valid To date to 2078/12/31 if null
*/

CREATE VIEW [dbo].[RP_Rc_1_Current_Active_Rate_L1_Base_Param]
AS
SELECT 	Vehicle_Rate.Rate_ID, 
	Vehicle_Rate.Rate_Name, 
    	Vehicle_Rate.Rate_Purpose_ID, 
	Owning_Company.Owning_Company_ID,
	rlsm.Location_ID,
	ra.Valid_From,
	ISNULL(ra.Valid_To, CONVERT(DATETIME,'2078-12-31 23:59:59', 102)) AS Valid_To	
		
FROM 	Vehicle_Rate WITH(NOLOCK)
	INNER
	JOIN
	Rate_Location_Set_Member rlsm
		ON Vehicle_Rate.Rate_ID = rlsm.Rate_ID
		AND rlsm.Termination_Date > CONVERT(DATETIME,'2078-12-31')
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Location
		ON Location.Location_ID = rlsm.Location_ID
		AND Rental_Location = 1
		AND Resnet = 1
	INNER
	JOIN
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	INNER
	JOIN
	Rate_Availability ra
		ON Vehicle_Rate.Rate_ID = ra.Rate_ID
		AND ra.Termination_Date > CONVERT(DATETIME,'2078-12-31')





















GO
