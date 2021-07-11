USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_11_Inclusive_Rate_L1_Optional_Extra]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_11_Inclusive_Rate_L1_Optional_Extra
PURPOSE: Get information about Optional Extra charges included in the rate

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Acc_11_Inclusive_Rate_L2_Optional_Extra
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_11_Inclusive_Rate_L1_Optional_Extra]
AS
SELECT	Contract.Contract_Number, 
   	Optional_Extra_GL.GL_Revenue_Account, 
   	Optional_Extra.Optional_Extra, 
   	Contract_Optional_Extra.GST_Exempt, 
   	Contract_Optional_Extra.PST_Exempt, 
	ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, Contract_Optional_Extra.Rent_To) 
		/ 86400.00000 + 0.49999), 0) AS Days, 
	Weeks = CASE 
		WHEN (CAST(ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, 
			Contract_Optional_Extra.Rent_To) / 86400.00000 + 0.49999), 0) AS INT) % 7) > 0 
		THEN FLOOR(ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, 
				Contract_Optional_Extra.Rent_To) / 86400.00000 + 0.49999), 0) / 7) + 1 
		ELSE ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, 
				Contract_Optional_Extra.Rent_To) / 86400.00000 + 0.49999), 0) / 7 
	END, 
	FLOOR(ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, 
		Contract_Optional_Extra.Rent_To) / 86400.00000 + 0.49999), 0) / 7)  AS Alt_Weeks, 
	(CAST(ROUND((DATEDIFF(ss, Contract_Optional_Extra.Rent_From, 
		Contract_Optional_Extra.Rent_To) / 86400.00000 + 0.49999), 0) AS INT) % 7) AS Alt_Days, 
	Included_Optional_Extra.Quantity, 
   	Included_Optional_Extra.Included_Daily_Amount, 
   	Included_Optional_Extra.Included_Weekly_Amount
FROM 	Contract WITH(NOLOCK)	
	INNER JOIN
   	Contract_Optional_Extra 
		ON Contract.Contract_Number = Contract_Optional_Extra.Contract_Number
		AND Contract_Optional_Extra.Termination_Date >  CONVERT(DATETIME,'2078-12-31 00:00:00', 102)
    	INNER JOIN
   	Optional_Extra 
		ON Contract_Optional_Extra.Optional_Extra_ID = Optional_Extra.Optional_Extra_ID
    	INNER JOIN
   	Optional_Extra_GL 
		ON Optional_Extra.Optional_Extra_ID = Optional_Extra_GL.Optional_Extra_ID
    	INNER JOIN
   	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    		AND Optional_Extra_GL.Vehicle_Type_ID = Vehicle_Class.Vehicle_Type_ID
    	INNER JOIN
   	Included_Optional_Extra 
		ON Optional_Extra.Optional_Extra_ID = Included_Optional_Extra.Optional_Extra_ID
    		AND Contract.Rate_ID = Included_Optional_Extra.Rate_ID 
		AND Contract.Rate_Assigned_Date >= Included_Optional_Extra.Effective_Date
    		AND Contract.Rate_Assigned_Date <= Included_Optional_Extra.Termination_Date    	
WHERE (Contract_Optional_Extra.Included_In_Rate = '1')















GO
