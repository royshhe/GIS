USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_2_Missing_Kilometers_L1_Base]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Flt_2_Missing_Kilometers_L1_Base
PURPOSE: Get the information about different vehicle movements 
	 (Contracts, Movments, Services)

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_Flt_2_Missing_Kilometers_L2_Main 
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_2_Missing_Kilometers_L1_Base]
AS
SELECT	Unit_Number,
	CONVERT(varchar(25), Movement_Type) 	AS MTCN, 
	Movement_Out 	AS Date_Out, 
	Movement_In 	AS Date_In, 
    	Km_Out, 
	Km_In, 
	Sending_Location_ID 	AS Pick_Up_Location_ID, 
    	Receiving_Location_ID 	AS Drop_Off_Location_ID
FROM Vehicle_Movement WITH(NOLOCK)
UNION ALL

SELECT Unit_Number, 
	CONVERT(varchar(25), VOC.Contract_Number), 
    	Checked_Out, 	
	Actual_Check_In, 
	Km_Out, 
	Km_In, 
    	VOC.Pick_Up_Location_ID, 
	Actual_Drop_Off_Location_ID
FROM Vehicle_On_Contract VOC
INNER JOIN Contract ON Contract.Contract_Number = VOC.Contract_Number
WHERE Contract.Status <> 'VD'

UNION ALL
SELECT Unit_Number,
	'Service',
	Service_Performed_On		AS Date_Out,
	Service_Performed_On 		AS Date_In,
	Km_Reading			AS Km_Out,
	Km_Reading			AS Km_In,
	NULL			 	AS Pick_Up_Location_ID, 
    	NULL	 			AS Drop_Off_Location_ID
FROM 	Vehicle_Service


















GO
