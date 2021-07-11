USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_9_One_Way_Report_L1_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_Res_9_One_Way_Report_L1_Main
PURPOSE: Select all the information needed for Reservation One Way Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Reservation One Way Report
MOD HISTORY: 
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Res_9_One_Way_Report_L1_Main]
AS
SELECT 	Contract.Contract_Number 		AS ID, 
    	Contract.Pick_Up_On 		AS Outbound_Pick_Up_Date, 
    	Contract.Pick_Up_Location_ID 	AS Outbound__Location_ID, 
	Location.Location			AS Outbound_Location_Name,
    	Owning_Company.Name 		AS Outbound_Location_OC_Name, 
    	Location.Rental_Location 		AS Outbound_Rental_Location_Flag, 
    	Contract.Drop_Off_On 		AS Inbound_Drop_Off_Date, 
    	Contract.Drop_Off_Location_ID 	AS Inbound__Location_ID, 
	Location1.Location		AS Inbound_Location_Name,
    	Location1.Owning_Company_ID 	AS Inbound_Location_OC_ID, 
    	Owning_Company1.Name 		AS Inbound_Location_OC_Name, 
    	Location1.Rental_Location 		AS Inbound_Rental_Location_Flag, 
    	Vehicle_Class.Vehicle_Type_ID, Contract.Vehicle_Class_Code, 
    	Contract.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name	 AS Vehicle_Class_Code_Name,
	Contract.Status
FROM 	Location WITH(NOLOCK)
	INNER JOIN
    	Owning_Company
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	INNER JOIN
    	Lookup_Table 
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
	INNER JOIN
    	Contract 
		ON Location.Location_ID = Contract.Pick_Up_Location_ID
	INNER JOIN
    	Location Location1
     		ON Contract.Drop_Off_Location_ID = Location1.Location_ID 
	INNER JOIN
    	Owning_Company Owning_Company1 
 		ON Owning_Company1.Owning_Company_ID = Location1.Owning_Company_ID
	INNER JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 	(Location.Rental_Location = 1) 
	AND (Location1.Rental_Location = 1) 
	AND (Contract.Status = 'CO' OR Contract.Status = 'OP')
UNION 	ALL
SELECT 	Reservation.Confirmation_Number	 AS ID, 
    	Reservation.Pick_Up_On 		AS Outbound_Pick_Up_Date, 
    	Reservation.Pick_Up_Location_ID 	AS Outbound_Location_ID, 
	Location.Location			AS Outbound_Location_Name,
    	Owning_Company.Name	 	AS Outbound_Location_OC_Name, 
    	Location.Rental_Location 		AS Outbound_Rental_Location_Flag, 
    	Reservation.Drop_Off_On 		AS Inbound_Drop_Off_Date, 
    	Reservation.Drop_Off_Location_ID 	AS Inbound_Location_ID, 
	Location1.Location		AS Inbound_Location_Name,
    	Location1.Owning_Company_ID	AS Inbound_Location_OC_ID, 
    	Owning_Company1.Name 		AS Inbound_Location_OC_Name, 
    	Location1.Rental_Location 		AS Inbound_Rental_Location_Flag, 
    	Vehicle_Class.Vehicle_Type_ID, 
    	Reservation.Vehicle_Class_Code, 
    	Reservation.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name 	AS Vehicle_Class_Code_Name,
	Reservation.Status
FROM 	Reservation WITH(NOLOCK)
	INNER JOIN
    	Location 
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID 
		AND (Location.Rental_Location = 1)
	INNER JOIN
    	Owning_Company 
		ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
     	INNER JOIN
    	Lookup_Table
		ON Owning_Company.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER JOIN
    	Location Location1 
		ON Reservation.Drop_Off_Location_ID = Location1.Location_ID 
		AND (Location1.Rental_Location = 1)
	INNER JOIN
    	Owning_Company Owning_Company1 
		ON Location1.Owning_Company_ID = Owning_Company1.Owning_Company_ID
     	INNER JOIN
   	Vehicle_Class 
		ON Reservation.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
WHERE 	(Reservation.Status = 'A')



















GO
