USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Rez]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

  --select distinct   source_code from reservation

/*
VIEW NAME: RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Rez
PURPOSE: Count number of reservation during an hour block on a day

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_3_Daily_Contract_Tran_Stat_L2_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Rez]
AS
SELECT 	
		case when tr.source_code='GIS' or  tr.source_code='Internet'
				then 'RG' 
			 when tr.source_code='Reznet' 
				then 'RR'
			 else 'RW'
		end AS Transaction_Type,
    	Vehicle_Class.Vehicle_Type_ID, 
    	tRch.Pick_Up_Location_ID AS Location_ID, 
    	Location.Location AS Location_Name, 
	CONVERT(datetime, CONVERT(varchar(12), tR.Pick_up_On, 112)) AS Transaction_Date,	-- date reservation is opened
	DATEPART(hh, tR.Pick_up_On) AS Transaction_Hour,	-- hour of the day reservation is opened
    	COUNT(tR.Confirmation_Number) AS Cnt
	--select *
FROM 	Reservation tR WITH(NOLOCK)
	INNER 
	JOIN
    	Reservation_Change_History tRch 
		ON tR.Confirmation_Number = tRch.Confirmation_Number
		AND tRch.Status = 'A'
		AND tRch.Changed_On =
        		(SELECT MIN(Changed_On)
      				FROM Reservation_Change_History tRch2
      					WHERE tR.Confirmation_Number = tRch2.Confirmation_Number)
	INNER
     	JOIN
    	Vehicle_Class 
		ON tR.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER 
	JOIN
    	Location 
		ON tRch.Pick_Up_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 -- Rental Locations
	INNER 
	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company' 
GROUP BY 
    	Vehicle_Class.Vehicle_Type_ID, 
    	tRch.Pick_Up_Location_ID, 
    	Location.Location, 
	CONVERT(datetime, CONVERT(varchar(12), tR.Pick_up_On, 112)),	
	DATEPART(hh, tR.Pick_up_On),
	tr.source_code


GO
