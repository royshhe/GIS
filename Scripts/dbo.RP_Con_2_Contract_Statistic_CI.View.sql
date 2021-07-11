USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_2_Contract_Statistic_CI]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
VIEW NAME: RP_Con_2_Contract_Statistic_L4_Base_Check_In_new
PURPOSE: summarize information for contracts checked in on a business day 

AUTHOR:	Linda Qu
DATE CREATED: 2000/06/08
USED BY:  
MOD HISTORY:
Name 		Date		Comments
LQ		2000/06/08      Created
*/
CREATE VIEW [dbo].[RP_Con_2_Contract_Statistic_CI]
AS
SELECT 	
	RBR_Date,
     	Vehicle_Type_ID,
     	Pick_Up_Location_ID,
     	Location_Name, 
    	COUNT(*) AS Check_In, 
    	SUM(Rental_Days) AS Rental_Days, 
    	SUM(Km_Driven) AS Km_Driven, 
    	SUM(TimeKm_Charge) AS TimeKm_Charge, 
    	SUM(LDW_Charge) AS LDW_Charge, 
    	SUM(PAI_Charge) AS PAI_Charge, 
    	SUM(PEC_Charge) AS PEC_Charge, 
    	SUM(Cargo_Charge) AS Cargo_Charge, 
  	SUM(Foreign_Opt_Extra_Charge) AS Foreign_Opt_Extra_Charge

FROM 	Contract_CI WITH(NOLOCK)
WHERE BRAC_Unit=1
GROUP BY 
	RBR_Date,
     	Vehicle_Type_ID,
     	Pick_Up_Location_ID,
     	Location_Name


















GO
