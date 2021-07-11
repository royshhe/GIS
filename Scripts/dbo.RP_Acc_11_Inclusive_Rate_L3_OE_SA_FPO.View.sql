USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
PURPOSE: Calculate charges for Optional Extra, Sales Accessory and Fuel Purchase option
		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L4_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO]
AS
SELECT *
FROM RP_Acc_11_Inclusive_Rate_L1_FPO WITH(NOLOCK)
UNION ALL
SELECT *
FROM RP_Acc_11_Inclusive_Rate_L1_Sales_Accessory WITH(NOLOCK)
UNION ALL
SELECT *
FROM RP_Acc_11_Inclusive_Rate_L2_Optional_Extra WITH(NOLOCK)











GO
