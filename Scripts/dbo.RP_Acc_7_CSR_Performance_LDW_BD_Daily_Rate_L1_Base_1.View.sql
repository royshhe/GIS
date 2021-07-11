USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1
PURPOSE: Get the Optional Extra (LDW, BD) Daily Rate
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_LDW_BD_Daily_Rate_L1_Base_1]
AS
SELECT 	Contract_Optional_Extra.Contract_Number, 
   	Contract_Optional_Extra.Daily_Rate
FROM 	Contract_Optional_Extra WITH(NOLOCK)
	INNER JOIN
   	Optional_Extra 
		ON Contract_Optional_Extra.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
WHERE 	(Optional_Extra.Type IN ('ldw', 'buydown')) 
	AND 
   	(Contract_Optional_Extra.Rent_From =
       					(SELECT MIN(coe.Rent_From)
     					FROM Contract_Optional_Extra coe
     					WHERE coe.Contract_Number = Contract_Optional_Extra.Contract_Number
         				AND coe.Termination_Date > CONVERT(DATETIME, '2078-12-31')))
	AND 
   	(Contract_Optional_Extra.Termination_Date > CONVERT(DATETIME,'2078-12-31'))
	AND
	(Contract_Optional_Extra.Included_In_Rate = '0')

















GO
