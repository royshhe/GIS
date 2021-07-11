USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_5_Interbranch_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Con_5_Interbranch_Main
PURPOSE: Select all the information needed for main report of Interbranch Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY: Interbranch Report (Main)
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/07	Get the actual drop off location from the last vehicle 
				on contract record rather than from the contract record.
				
*/
CREATE PROCEDURE [dbo].[RP_SP_Con_5_Interbranch_Main]
(
	@paramBusDate varchar(20) = '23 Apr 1999'
)
AS
-- convert strings to datetime

DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)

SELECT 	
	Business_Transaction.RBR_Date,
   	Business_Transaction.Business_Transaction_ID,
   	Contract.Contract_Number,
   	Contract.Foreign_Contract_Number,
   	Location.Location 						AS Pick_Up_Location_Name,
   	Contract.Pick_Up_On,
   	Location1.Location 						AS Drop_Off_Location_Name,
   	RP__Last_Vehicle_On_Contract.Actual_Check_In,
   	Contract.Last_Name + ' ' + Contract.First_Name 			AS Customer_Name,
	Transaction_Type = CASE
				WHEN   Business_Transaction.Transaction_Description = 'adjustments' THEN
					'Adjustment'
				ELSE
					'Close'
			END
FROM 	RP_Con_5_Interbranch_L1_Base_1 with(nolock)
	INNER JOIN
   	Contract
		ON RP_Con_5_Interbranch_L1_Base_1.Contract_Number = Contract.Contract_Number
    	INNER JOIN
   	Business_Transaction
		ON RP_Con_5_Interbranch_L1_Base_1.Contract_Number = Business_Transaction.Contract_Number
    	INNER JOIN
   	Location
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
   	RP__Last_Vehicle_On_Contract
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number
	INNER JOIN
   	Location Location1
		ON RP__Last_Vehicle_On_Contract.Actual_Drop_Off_Location_ID = Location1.Location_ID
WHERE 	
	(Business_Transaction.Transaction_Type = 'con')
    	AND
   	(Business_Transaction.Transaction_Description = 'check in'
    	OR Business_Transaction.Transaction_Description = 'foreign check in'
    	OR Business_Transaction.Transaction_Description = 'adjustments')
	AND
	DATEDIFF(dd, @busDate, RBR_Date) = 0

RETURN @@ROWCOUNT















GO
