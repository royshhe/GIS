USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_5_Interbranch_Vehicle_History_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_5_Interbranch_Vehicle_History_SB_L1_Base_1
PURPOSE: Select all the information needed for 
	 Vehicle History Subreport of Interbranch Report
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Vehicle History Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_5_Interbranch_Vehicle_History_SB_L1_Base_1]
AS
SELECT Contract.Contract_Number,
	ISNULL( Vehicle.Foreign_Vehicle_Unit_Number, Vehicle.Unit_Number) AS Unit_Number,
   	Vehicle.Current_Licence_Plate, 
   	Vehicle_Class.Vehicle_Class_Name, 
   	Owning_Company.Name	AS Vehicle_Owning_Company, 
   	Vehicle_On_Contract.Checked_Out, 
   	Vehicle_On_Contract.Actual_Check_In,
	ROUND(DATEDIFF(mi, Vehicle_On_Contract.Checked_Out, Vehicle_On_Contract.Actual_Check_In) / 1440.0, 1) AS Days_Used, 
	Vehicle_On_Contract.Km_Out, 
   	Vehicle_On_Contract.Km_In, 
   	Vehicle_On_Contract.Km_In - Vehicle_On_Contract.Km_Out AS Km_Used
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
	INNER JOIN
	Vehicle 
		ON Vehicle.Unit_Number = Vehicle_On_Contract.Unit_Number 
	INNER JOIN
   	Vehicle_Class 
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
   	Owning_Company 
		ON Vehicle.Owning_Company_ID = Owning_Company.Owning_Company_ID
























GO
