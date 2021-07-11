USE [GISData]
GO
/****** Object:  View [dbo].[RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates
PURPOSE: Select all information required for Current Active Rate Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/11/20
USED BY: Stored Procedure RP_SP_Rc_1_Current_Active_Rate
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates]
AS
SELECT 	Vehicle_Rate.Rate_ID, 
	Owning_Company.Owning_Company_ID,
	Owning_Company.Name AS Owning_Company_Name,
	Location.Location_ID,
	Location.Location AS Location_Name,
	NULL AS Valid_From,
	NULL AS Valid_To
		
FROM 	Vehicle_Rate WITH(NOLOCK)
	INNER
	JOIN
	Rate_Location_Set_Member
		ON Vehicle_Rate.Rate_ID = Rate_Location_Set_Member.Rate_ID
		AND Rate_Location_Set_Member.Termination_Date > CONVERT(DATETIME,'2078-12-31')
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Location
		ON Location.Location_ID = Rate_Location_Set_Member.Location_ID
		AND Rental_Location = 1
		AND Resnet = 1
	INNER
	JOIN
	Owning_Company
		ON Owning_Company.Owning_Company_ID = Location.Owning_Company_ID
	
UNION ALL

SELECT 	Vehicle_Rate.Rate_ID, 
	NULL AS Owning_Company_ID,
	NULL AS Owning_Company_Name,
	NULL AS Location_ID,
	NULL AS Location_Name,	
	Rate_Availability.Valid_From,
	ISNULL(Rate_Availability.Valid_To, CONVERT(DATETIME,'2078-12-31 23:59:59', 102))
		
FROM 	Vehicle_Rate 
	INNER
	JOIN
	Rate_Availability
		ON Vehicle_Rate.Rate_ID = Rate_Availability.Rate_ID
		AND Rate_Availability.Termination_Date > CONVERT(DATETIME,'2078-12-31')
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')




















GO
