USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME:  	 RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2
PURPOSE:    	 This view simply groups the counts by date, vehicle class code and location.

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_Summary_L3_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2]
AS
SELECT 	
	Rpt_Date,
	Location_ID, 
	Vehicle_Class_Code, 
	SUM(Cdt_Cnt) AS Cdt_Cnt, 
	SUM(Cor1_Cnt) AS Cor1_Cnt, 
	SUM(Cor2_Cnt) AS Cor2_Cnt, 
	SUM(Cor3_Cnt) AS Cor3_Cnt, 
	SUM(Od_Cnt) AS Od_Cnt, 
	SUM(Rdt1_Cnt) AS Rdt1_Cnt, 
	SUM(Rdt2_Cnt) AS Rdt2_Cnt, 
	SUM(Rpu1_Cnt) AS Rpu1_Cnt, 
	SUM(Rpu2_Cnt) AS Rpu2_Cnt

FROM 	RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1 WITH(NOLOCK)

GROUP BY 
	Rpt_Date, 
	Vehicle_Class_Code, 
	Location_ID


















GO
