USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Cont_Misc]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME:  	 RP_Res_11_Reservation_Rate_Performance_L2_Base_Cont_Misc
PURPOSE:           Group all information related to contracts by contract number

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: 	 RP_Res_11_Reservation_Rate_Performance_L3_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Res_11_Reservation_Rate_Performance_L2_Base_Cont_Misc]
AS
SELECT 	
	Contract_Number, 
	SUM(Rental_Days) AS Rental_Days, 
	SUM(Km_Driven) AS Km_Driven, 
    	SUM(TimeKm_Charge) AS TimeKm_Charge, 
    	SUM(LDW_Charge) AS LDW_Charge, 
	SUM(PAI_Charge) AS PAI_Charge, 
	SUM(PEC_Charge) AS PEC_Charge, 
   	SUM(Cargo_Charge) AS Cargo_Charge
FROM 	RP_Res_11_Reservation_Rate_Performance_L1_Base_Cont_Misc
GROUP BY 
	Contract_Number














GO
