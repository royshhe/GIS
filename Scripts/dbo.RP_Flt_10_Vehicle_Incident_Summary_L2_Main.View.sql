USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L2_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_10_Vehicle_Incident_Summary_L1_Base_2
PURPOSE: Select information required for Vehicle Incident Summary Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Vehicle Incident Summary Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/7	Add Is_BRAC_Vehicle field 
*/

CREATE VIEW [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L2_Main]
AS
SELECT 
	v2.Logged_Date,
     	v2.Incident_Number,
     	v2.Contract_Number,
     	v2.Foreign_Contract_Number,
     	v2.Status, 
    	v2.Renter_Name,
     	v2.Unit_Number,
	v2.Owning_Company_ID,
	Is_BRAC_Vehicle = CASE WHEN Lookup_Table.Category = 'BudgetBC Company'
				THEN 'Y'
				ELSE 'N'
			  END,
     	v2.Model_Name,
     	v2.Model_Year,
     	v1.Current_Location_Name,
     	v2.Incident_Type,
	v2.Problem_Type,
	v2.Reason,
    	v2.Problem_Type_And_Reason
FROM 	RP_Flt_10_Vehicle_Incident_Summary_L1_Base_1 v1 WITH(NOLOCK)
	INNER 
	JOIN
    	RP_Flt_10_Vehicle_Incident_Summary_L1_Base_2  v2
		ON v1.Unit_Number = v2.Unit_Number
	LEFT
	JOIN
    	Lookup_Table
		ON v2.Owning_Company_ID = CONVERT(smallint,Lookup_Table.Code)
		AND (Lookup_Table.Category = 'BudgetBC Company')
	

























GO
