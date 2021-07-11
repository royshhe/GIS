USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1
PURPOSE: Check was Optional Extra (LDW) included in the contract rate
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_LDW_INC_Flag_L1_Base_1]
AS
-- GIS Rates
SELECT	Contract.Contract_Number,
	Optional_Extra.Optional_Extra_ID
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
	Included_Optional_Extra
		INNER JOIN
   			Optional_Extra	 
			ON Optional_Extra.Optional_Extra_ID = Included_Optional_Extra.Optional_Extra_ID
			ON Included_Optional_Extra.Termination_Date >= Contract.Rate_Assigned_Date
    			AND Included_Optional_Extra.Effective_Date <= Contract.Rate_Assigned_Date
    			AND Included_Optional_Extra.Rate_ID = Contract.Rate_ID
			AND (Optional_Extra.Type = 'LDW')

UNION ALL
-- Maestro Rates
SELECT 	Contract.Contract_Number, 
   	Optional_Extra.Optional_Extra_ID
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
   	Quoted_Included_Optional_Extra 
		INNER JOIN  Optional_Extra
			ON Optional_Extra.Optional_Extra_ID = Quoted_Included_Optional_Extra.Optional_Extra_ID
			ON Quoted_Included_Optional_Extra.Quoted_Rate_ID = Contract.Quoted_Rate_ID
			AND (Optional_Extra.Type = 'LDW')











GO
