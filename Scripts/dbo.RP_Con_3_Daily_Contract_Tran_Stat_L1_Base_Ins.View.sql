USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Ins]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Ins
PURPOSE: Count number of contracts checked in during an hour block on a day

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_3_Daily_Contract_Tran_Stat_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Ins]
AS
SELECT 
	'I' AS Transaction_Type,
	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Actual_Drop_Off_Location_ID AS Location_ID,
    	Location.Location AS Location_Name, 
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Actual_Check_In, 112)) 	AS Transaction_Date,	-- date contract is checked in
	DATEPART(hh, Vehicle_On_Contract.Actual_Check_In)  AS Transaction_Hour,	-- hour of the day contract is checked in
    	COUNT(Contract.Contract_Number) AS Cnt
	
FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND Contract.Status = 'CI'
		AND Vehicle_On_Contract.Actual_Check_In IS NOT NULL
     		AND Vehicle_On_Contract.Actual_Check_In =
    			(SELECT MAX(Actual_Check_In)
      				FROM Vehicle_On_Contract
      					WHERE Contract.Contract_Number = Vehicle_On_Contract.Contract_Number)
     	INNER 
	JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    	INNER 
	JOIN
    	Location 
		ON Vehicle_On_Contract.Actual_Drop_Off_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 	

GROUP BY
	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Actual_Drop_Off_Location_ID,
    	Location.Location,
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Actual_Check_In, 112)),
	DATEPART(hh, Vehicle_On_Contract.Actual_Check_In)

















GO
