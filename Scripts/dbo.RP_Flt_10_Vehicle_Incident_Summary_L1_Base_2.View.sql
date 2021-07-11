USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L1_Base_2]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_10_Vehicle_Incident_Summary_L1_Base_2
PURPOSE: Select information on different types of incidents (damage, mechanical, siezure and failure)

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Flt_10_Vehicle_Incident_Summary_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/9/28	show 'Movement' in GIS Contract column if there is no GIS or foreign contract number
				remove ', ' if no renter name.
Joseph T	1999/10/7	add Vehicle.Owning_Company_ID field
Vivian Leung	09 Nov 2001	Change 'Seisure' to 'Seizure'; enable the view to include 'Seizure' incident type
*/

CREATE VIEW [dbo].[RP_Flt_10_Vehicle_Incident_Summary_L1_Base_2]
AS
-- damage incidents
SELECT 
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_Support_Incident.Logged_On, 112)) AS Logged_Date, 
   	Vehicle_Support_Incident.Vehicle_Support_Incident_Seq AS Incident_Number, 
    	Contract_Number = CASE
				WHEN Vehicle_Support_Incident.Contract_Number IS NULL AND Vehicle_Support_Incident.Foreign_Contract_Number IS NULL
				THEN 'Movement'
				ELSE CONVERT(varchar(12), Vehicle_Support_Incident.Contract_Number)
				END,
    	Vehicle_Support_Incident.Foreign_Contract_Number, 
    	Lookup_Table.Value AS Status, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Renter_Name,
     	Vehicle_Support_Incident.Unit_Number, 
	Vehicle.Owning_Company_ID,
    	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Model_Year.Model_Year, 
    	Vehicle_Support_Incident.Incident_Type,  
	Damage_Incident.Type AS Problem_Type,
	Vehicle_Support_Incident.Do_Not_Switch_Reason AS Reason,
   	Problem_Type_And_Reason = Damage_Incident.Type + 
					CASE WHEN Vehicle_Support_Incident.Do_Not_Switch_Reason <> '' 
					          THEN ' / ' + Vehicle_Support_Incident.Do_Not_Switch_Reason
     					END
FROM 	Contract  WITH(NOLOCK)
RIGHT 
OUTER 
JOIN
    	Vehicle_Support_Incident 
	INNER 
	JOIN
    	Damage_Incident 
		ON Vehicle_Support_Incident.Vehicle_Support_Incident_Seq = Damage_Incident.Vehicle_Support_Incident_Seq
		AND Vehicle_Support_Incident.Incident_Type = 'Damage'
     	INNER 
	JOIN
	Lookup_Table 
		ON Vehicle_Support_Incident.Incident_Status = Lookup_Table.Code 
		AND Lookup_Table.Category = 'Vehicle Incident Status'
	INNER
     	JOIN
    	Vehicle 
	     	ON Vehicle_Support_Incident.Unit_Number = Vehicle.Unit_Number 
	INNER 
	JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
ON Contract.Contract_Number = Vehicle_Support_Incident.Contract_Number

UNION ALL

-- mechanical incidents
SELECT 
	CONVERT(datetime, CONVERT(varchar(12),  Vehicle_Support_Incident.Logged_On, 112)) AS Logged_Date, 
   	Vehicle_Support_Incident.Vehicle_Support_Incident_Seq AS Incident_Number, 
    	GIS_Contract_Number = CASE
				WHEN Vehicle_Support_Incident.Contract_Number IS NULL AND Vehicle_Support_Incident.Foreign_Contract_Number IS NULL
				THEN 'Movement'
				ELSE CONVERT(varchar(12), Vehicle_Support_Incident.Contract_Number)
				END,
   	Vehicle_Support_Incident.Foreign_Contract_Number, 
    	Lookup_Table.Value AS Status, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Renter_Name,
     	Vehicle_Support_Incident.Unit_Number, 
	Vehicle.Owning_Company_ID,
    	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Model_Year.Model_Year, 
    	Vehicle_Support_Incident.Incident_Type, 
	Mechanical_Incident.Type AS Problem_Type,
	Vehicle_Support_Incident.Do_Not_Switch_Reason AS Reason,
   	Problem_Type_And_Reason = Mechanical_Incident.Type + 
					CASE WHEN Vehicle_Support_Incident.Do_Not_Switch_Reason <> '' 
					          THEN ' / ' + Vehicle_Support_Incident.Do_Not_Switch_Reason
     					END
FROM 	Contract 
RIGHT 
OUTER 
JOIN
    	Vehicle_Support_Incident 
	INNER 
	JOIN
    	Mechanical_Incident 
		ON Vehicle_Support_Incident.Vehicle_Support_Incident_Seq = Mechanical_Incident.Vehicle_Support_Incident_Seq
		AND Vehicle_Support_Incident.Incident_Type = 'Mechanical'
     	INNER 
	JOIN
	Lookup_Table 
		ON Vehicle_Support_Incident.Incident_Status = Lookup_Table.Code 
		AND Lookup_Table.Category = 'Vehicle Incident Status'
	INNER
     	JOIN
    	Vehicle 
	     	ON Vehicle_Support_Incident.Unit_Number = Vehicle.Unit_Number 
	INNER 
	JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID
ON Contract.Contract_Number = Vehicle_Support_Incident.Contract_Number

UNION ALL

-- seizure and stolen incidents
SELECT 
	CONVERT(datetime, CONVERT(varchar(12),  Vehicle_Support_Incident.Logged_On, 112)) AS Logged_Date, 
	Vehicle_Support_Incident.Vehicle_Support_Incident_Seq AS Incident_Number, 
    	GIS_Contract_Number = CASE
				WHEN Vehicle_Support_Incident.Contract_Number IS NULL AND Vehicle_Support_Incident.Foreign_Contract_Number IS NULL
				THEN 'Movement'
				ELSE CONVERT(varchar(12), Vehicle_Support_Incident.Contract_Number)
				END,
    	Vehicle_Support_Incident.Foreign_Contract_Number, 
    	Lookup_Table.Value AS Status, 
    	Contract.Last_Name + ', ' + Contract.First_Name AS Renter_Name,
     	Vehicle_Support_Incident.Unit_Number, 
	Vehicle.Owning_Company_ID,
    	Vehicle_Model_Year.Model_Name, 
    	Vehicle_Model_Year.Model_Year, 
    	Vehicle_Support_Incident.Incident_Type, 
	NULL AS Problem_Type,
	Vehicle_Support_Incident.Do_Not_Switch_Reason AS Reason,
	Vehicle_Support_Incident.Do_Not_Switch_Reason AS Problem_Type_And_Reason

FROM 	Contract 
RIGHT 
OUTER 
JOIN
    	Vehicle_Support_Incident 
     	INNER 
	JOIN
	Lookup_Table 
		ON Vehicle_Support_Incident.Incident_Status = Lookup_Table.Code 
		AND Lookup_Table.Category = 'Vehicle Incident Status'
		AND (Vehicle_Support_Incident.Incident_Type = 'Seizure' OR Vehicle_Support_Incident.Incident_Type = 'Stolen')

	INNER
     	JOIN
    	Vehicle 
	     	ON Vehicle_Support_Incident.Unit_Number = Vehicle.Unit_Number 
	INNER 
	JOIN
    	Vehicle_Model_Year 
		ON Vehicle.Vehicle_Model_ID = Vehicle_Model_Year.Vehicle_Model_ID

ON Contract.Contract_Number = Vehicle_Support_Incident.Contract_Number




























GO
