USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_OD_L1_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME:  	RP_Res_10_Build_Up_On_Rent_OD_L1_Base
PURPOSE:    	This view counts number of Overdue for BRAC (local) and foreign locations
   		(contracts with status of check out and drop off date < current date.
    		Note that overdue will only display (show non-zero value) for current date)

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_OD_L2_Base
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/11/18	Only include BRAC BC (local) vehicles
Joseph Tseung	1999/11/18	Change to get information for the vehicle unit from the FIRST vehicle on contract.
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_OD_L1_Base]
AS
SELECT	CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)) AS Rpt_Date, 
  	Vehicle.Vehicle_Class_Code, 
	Contract.Drop_Off_Location_ID AS Location_ID,
  	COUNT(Contract.Contract_Number) AS Cnt

FROM 	Contract WITH(NOLOCK)
      	JOIN 
	RP__Last_Vehicle_On_Contract
		ON 
		RP__Last_Vehicle_On_Contract.Contract_Number = Contract.Contract_Number
     		AND Contract.Status = 'CO' 
      	JOIN
	Vehicle
        	ON RP__Last_Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number 
	JOIN
	Lookup_Table
		ON
		Lookup_Table.Code = Vehicle.Owning_Company_ID
		AND Lookup_Table.Category = 'BudgetBC Company' 

GROUP BY 	
	CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)), 
  	Vehicle.Vehicle_Class_Code, 
	Contract.Drop_Off_Location_ID





















GO
