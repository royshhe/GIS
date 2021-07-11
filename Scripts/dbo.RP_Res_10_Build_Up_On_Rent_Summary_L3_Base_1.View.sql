USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME:  	 RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1
PURPOSE:    	 This view stores all the counts in columns for both local and foreign locations

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	View RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_2
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_1]
AS
SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	Cnt AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_CDT_L1_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	Cnt AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_COR1_L2_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	Cnt AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_COR2_L2_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	Cnt AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_COR3_L2_Base

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	Cnt AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_OD_L2_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	Cnt AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_RDT1_L1_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	Cnt AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_RDT2_L1_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	Cnt AS Rpu1_Cnt,
	0 AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_RPU1_L1_Base WITH(NOLOCK)

UNION ALL

SELECT 	
	Rpt_Date,
       	Vehicle_Class_Code,
 	Location_ID,
	0 AS Cdt_Cnt,
	0 AS Cor1_Cnt,
	0 AS Cor2_Cnt,
	0 AS Cor3_Cnt,
	0 AS Od_Cnt,
	0 AS Rdt1_Cnt,
	0 AS Rdt2_Cnt,
	0 AS Rpu1_Cnt,
	Cnt AS Rpu2_Cnt

FROM	RP_Res_10_Build_Up_On_Rent_RPU2_L1_Base WITH(NOLOCK)

























GO
