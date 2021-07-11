USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L2_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Con_3_Daily_Contract_Tran_Stat_L2_Main
PURPOSE: Get all information needed for the Daily Contract Transaction Statistic Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Con_3_Daily_Contract_Tran_Stat
MOD HISTORY:
Name 		Date		Comments
*/


CREATE VIEW [dbo].[RP_Con_3_Daily_Contract_Tran_Stat_L2_Main]
AS
SELECT 	
	Transaction_Type,
    	Vehicle_Type_ID, 
    	Location_ID, 
    	Location_Name, 
	Transaction_Date,	
	Transaction_Hour,	
    	Cnt

FROM 	RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Outs WITH(NOLOCK)

UNION ALL

SELECT 	
	Transaction_Type,
    	Vehicle_Type_ID, 
    	Location_ID, 
    	Location_Name, 
	Transaction_Date,	
	Transaction_Hour,	
    	Cnt

FROM 	RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Ins WITH(NOLOCK)

UNION ALL

SELECT 	
	Transaction_Type,
    	Vehicle_Type_ID, 
    	Location_ID, 
    	Location_Name, 
	Transaction_Date,	
	Transaction_Hour,	
    	Cnt

FROM 	RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Rez

--UNION ALL
--
--SELECT 	
--	Transaction_Type,
--    	Vehicle_Type_ID, 
--    	Location_ID, 
--    	Location_Name, 
--	Transaction_Date,	
--	Transaction_Hour,	
--    	Cnt
--
--FROM 	RP_Con_3_Daily_Contract_Tran_Stat_L1_Base_Sls
GO
