USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_COR1_L2_Base]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
VIEW NAME:  	RP_Res_10_Build_Up_On_Rent_COR1_L2_Base
PURPOSE:   	This view counts number of current on rent for BRAC (local) and foreign locations
		(contracts with status of check out and drop off date >= date of day being counted)
		in the next 45 days.

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_COR1_L2_Base]
AS
SELECT 	
	vDate.Rpt_Date,
	vCor1.Vehicle_Class_Code,
	vCor1.Location_ID,
	SUM(Cnt) AS Cnt		

FROM	RP_Res_10_Build_Up_On_Rent_All_Date_L1_Base AS vDate WITH(NOLOCK)
	LEFT 
	JOIN
	RP_Res_10_Build_Up_On_Rent_COR1_L1_Base AS vCor1
		ON DATEDIFF(dd, vCor1.Rpt_Date, vDate.Rpt_Date) <= 0 

GROUP BY 

	vDate.Rpt_Date,
	vCor1.Vehicle_Class_Code,
	vCor1.Location_ID






















GO
