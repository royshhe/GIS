USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_2_Contract_Statistic_CO]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
VIEW NAME: RP_Con_2_Contract_Statistic_CO
PURPOSE: summarize information for contracts checked out on a business day 

AUTHOR:	Linda Qu
DATE CREATED: 2000/06/08
USED BY:  
MOD HISTORY:
Name 		Date		Comments

*/

CREATE VIEW [dbo].[RP_Con_2_Contract_Statistic_CO]
AS
SELECT 	
	RBR_Date, 
    	Vehicle_Type_ID, 
    	Pick_Up_Location_ID, 
    	Location_Name, 
    	COUNT(*) AS Check_Out
FROM 	Contract_CO WITH(NOLOCK)
WHERE BRAC_Unit=1
GROUP BY 
	RBR_Date,  
	Vehicle_Type_ID, 
    	Pick_Up_Location_ID, 
	Location_Name





















GO
