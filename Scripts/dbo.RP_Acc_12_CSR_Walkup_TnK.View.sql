USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_12_CSR_Walkup_TnK]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		27 Feb 2001
--	Details		Sum all items, seperate in different columns (Summary)
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE View [dbo].[RP_Acc_12_CSR_Walkup_TnK]

AS

SELECT
	RBR_Date, 	
	Pick_Up_Location_ID,
   	CSR_Name,
   	Contract_number,
	Confirmation_number,
	Walk_up,
	Contract_Rental_Days,
	    
	--Calculation With Hours 						
        SUM( CASE 	WHEN Charge_Type IN (10,  50, 51, 52)
			THEN Amount
			ELSE 0
			END)             as Rental_Time_Revenue,
              

	SUM( CASE 	WHEN Charge_Type IN (11)
			THEN Amount
			ELSE 0
			END)  						as Rental_KM_Revenue,

	SUM( CASE 	WHEN Charge_Type IN (10, 11,50, 51, 52)
			THEN Amount
			ELSE 0
			END)  						as Contract_TnKm_Revenue,


	SUM( CASE 	WHEN Charge_Type IN (10, 11, 20,50, 51, 52)
			THEN Amount
			ELSE 0
			END)  						as Contract_Revenue

FROM 	RP_Acc_12_CSR_Incremental_Yield_L1 
where Walk_up=1

GROUP BY 	RBR_Date,
		Pick_Up_Location_ID,
   		CSR_Name,
		Contract_number,
		Confirmation_number,
		Walk_up,
		Contract_Rental_Days,
		Contract_Rental_Hours





















GO
