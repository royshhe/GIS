USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_All_Date_L1_Base]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Res_10_Build_Up_On_Rent_All_Date_L1_Base
PURPOSE: Select the next 45 days starting from today

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_COR1_L2_Base,
		View RP_Res_10_Build_Up_On_Rent_COR2_L2_Base,
		View RP_Res_10_Build_Up_On_Rent_COR3_L2_Base,
		View RP_Res_10_Build_Up_On_Rent_OD_L2_Base
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_All_Date_L1_Base]
AS
SELECT 	CONVERT(datetime, CONVERT(varchar(12), DATEADD(dd, DayNum, GETDATE()), 112)) AS Rpt_Date 
FROM 		RP_Day_Number WITH(NOLOCK)





















GO
