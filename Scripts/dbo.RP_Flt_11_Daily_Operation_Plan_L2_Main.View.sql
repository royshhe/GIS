USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_11_Daily_Operation_Plan_L2_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Flt_11_Daily_Operation_Plan_L2_Main
PURPOSE: Get the current information about vehicles for BRAC 
	 rental locations and BRAC HQ location

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored procedure RP_SP_Flt_11_Daily_Operation_Plan
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Flt_11_Daily_Operation_Plan_L2_Main]
AS
-- select data for all rental BRAC locations
SELECT 	
	ID, 
	Location_ID, 
	Vehicle_Class_Code,
      	Status,
	Hours_Overdue

FROM 	RP_Flt_11_Daily_Operation_Plan_L1_Base WITH(NOLOCK)

WHERE  	Rental_location = 1

UNION ALL

-- select data for BRAC headquarter location
SELECT 	
	ID, 
	Location_ID, 
	Vehicle_Class_Code,
      	Status,
	Hours_Overdue

FROM 	RP_Flt_11_Daily_Operation_Plan_L1_Base WITH(NOLOCK)
	INNER 
	JOIN
    	Lookup_Table 
		ON Location_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'HQ Location' 













GO
