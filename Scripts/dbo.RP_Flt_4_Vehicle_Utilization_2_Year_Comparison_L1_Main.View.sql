USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_4_Vehicle_Utilization_2_Year_Comparison_L1_Main]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_5_Vehicle_Utilization_Current_L1_Main
PURPOSE: Select all owning companies. The infomation will be used for main
         groups of report, details will come from stored procedures.

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Vehicle Utilization - 2 Years Comparison Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_4_Vehicle_Utilization_2_Year_Comparison_L1_Main]
AS
SELECT 	Name
FROM 	Owning_Company WITH(NOLOCK)
















GO
