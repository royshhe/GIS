USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Outs]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Outs
PURPOSE: Count number of contracts checked out during an hour block on a day

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_3_Daily_Contract_Tran_Stat_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/11/09	count includes contracts that have checked in.
*/

CREATE VIEW [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Outs]
AS
SELECT 	
	'O' AS Transaction_Type,
    	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Pick_Up_Location_ID AS Location_ID, 
    	Location.Location AS Location_Name, 
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Checked_Out, 112))  AS Transaction_Date,	-- date contract is checked out
	DATEPART(hh, Vehicle_On_Contract.Checked_Out) AS Transaction_Hour,	-- hour of the day contract is checked out
    	COUNT(Contract.Contract_Number) AS Cnt

FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
		AND Vehicle_On_Contract.Checked_Out =
        		(SELECT MIN(Checked_Out)
      				FROM Vehicle_On_Contract
      					WHERE Contract.Contract_number = Vehicle_On_Contract.Contract_number)
	INNER
     	JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER 
	JOIN
    	Location 
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
GROUP BY 
	Vehicle_Class.Vehicle_Type_ID, 
    	Vehicle_On_Contract.Pick_Up_Location_ID, 
	Location.Location,	
	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Checked_Out, 112)),
	DATEPART(hh, Vehicle_On_Contract.Checked_Out) 
    	






















GO
