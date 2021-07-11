USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME: RP_Con_6_Contract_Open_Overdue_L1_Base_Contract_Charge
PURPOSE: Group contract charges by contract number

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_In,
	   View RP_Con_6_Contract_Open_Overdue_L2_Main_Contract_Out,
	   View RP_Con_6_Contract_Open_Overdue_L3_Main_Contract_Overdue
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Con_6_Contract_Open_Overdue_L2_Base_Contract_Charge]
AS
SELECT 
	Contract_Number, 
	SUM(Contract_Charge) AS Total_Contract_Charge
FROM 	RP_Con_6_Contract_Open_Overdue_L1_Base_Contract_Charge
GROUP BY 
	Contract_Number

















GO
