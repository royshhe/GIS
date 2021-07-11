USE [GISData]
GO
/****** Object:  View [dbo].[claimsvehicleincidentreportdamage]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
VIEW NAME:  claimsvehicleincidentreportdamage
PURPOSE: Select information to display a damage report for vehicle incident support in cars program

AUTHOR:	Junaid Ahmed
DATE CREATED: 2002 Feb 26
USED BY: Reports Screen in CARS

MOD HISTORY:
Name 		Date		Comments

*/

CREATE VIEW [dbo].[claimsvehicleincidentreportdamage]
AS
SELECT     dbo.Contract.Last_Name, dbo.Contract.First_Name, dbo.Contract.Birth_Date, dbo.Contract.Gender, dbo.Contract.Country, dbo.Contract.Phone_Number, 
                      dbo.Contract.Company_Name, dbo.Contract.Address_1, dbo.Contract.Company_Phone_Number, dbo.Damage_Incident.Vehicle_Location, 
                      dbo.Damage_Incident.Customer_Location, dbo.Damage_Incident.Vehicle_Model_Name, dbo.Damage_Incident.Current_Km, 
                      dbo.Damage_Incident.Vehicle_Exterior_Color, dbo.Damage_Incident.Type, dbo.Damage_Incident.Vehicle_Drivable, 
                      dbo.Vehicle_Support_Incident.Vehicle_Support_Incident_Seq, dbo.Vehicle_Support_Incident.Contract_Number, 
                      dbo.Vehicle_Support_Incident.Logged_On, dbo.Vehicle_Support_Incident.Logged_By, dbo.Vehicle_Support_Incident.Unit_Number, 
                      dbo.Vehicle_Support_Incident.Licence_Plate, dbo.Vehicle_Support_Incident.Reported_By_Name, dbo.Vehicle_Support_Incident.Reported_By_Role
                  
FROM         dbo.Vehicle_Support_Incident INNER JOIN
                      dbo.Damage_Incident ON 
                      dbo.Vehicle_Support_Incident.Vehicle_Support_Incident_Seq = dbo.Damage_Incident.Vehicle_Support_Incident_Seq INNER JOIN
                      dbo.Contract ON dbo.Vehicle_Support_Incident.Contract_Number = dbo.Contract.Contract_Number 


GO
