USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1
PURPOSE: Get the information related to contracts and reservations.
	 		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Acc_7_CSR_Performance_Report_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/27	Change the order of outer join and the last inner join
				to improve performance
Joseph Tseung 	1999/11/10	Do not display 'U' under "Upgd Sub" column for walk in customer (i.e. contract without reservation)
*/
CREATE VIEW [dbo].[RP_Acc_7_CSR_Performance_Contract_Reservation_Info_L1_Base_1]
AS
SELECT 	Contract.Contract_Number, 
	Vehicle_Class.Vehicle_Type_ID,
	Contract.Status AS Contract_Status,
   	Status = 	CASE
			WHEN Contract.Status = 'Co' THEN
				'O'
			WHEN Contract.Status = 'Ci' THEN
				'C'
		END,
	ISNULL(LEFT(Reservation.Source_Code, 1),  'W') 				AS Rez_Src, 
	ISNULL(Reservation.Vehicle_Class_Code, '-') 				AS Rez_CS, 
   	RP__First_Vehicle_On_Contract.Actual_Vehicle_Class_Code 		AS Con_CS,
	Upgd_Sub = 
		CASE 
			-- if it is not a walk-up reservation and contract vehicle rate class 
			-- is not the same as reservation vehicle rate class, show 'U'
			WHEN Reservation.Source_Code IS NOT NULL AND ISNULL(Reservation.Vehicle_Class_Code, '-') <> Contract.Vehicle_Class_Code THEN
				'U'
			WHEN ISNULL(Reservation.Vehicle_Class_Code, '-') = Contract.Vehicle_Class_Code 
				AND Contract.Vehicle_Class_Code <> RP__First_Vehicle_On_Contract.Actual_Vehicle_Class_Code THEN
				'S'
			ELSE
				''
		END,
	Length = 	CASE 
			WHEN Contract.Status = 'Co' THEN
				ROUND(DATEDIFF(mi, Contract.Pick_Up_On, Contract.Drop_Off_On) / 1440.0,1)
			WHEN Contract.Status = 'Ci' THEN
				ROUND(DATEDIFF(mi, Contract.Pick_Up_On,RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0,1)
			ELSE 
				-1 -- to detect errors, this should never occur in the report
		END,
	Number_Of_Vehicles =	(SELECT COUNT(*) 
				FROM Vehicle_On_Contract voc 	
				WHERE voc.Contract_Number = Contract.Contract_Number),
	Con_Rate_Level = 
		CASE 
			WHEN Contract.Rate_ID IS NOT NULL  THEN
				Contract.Rate_Level
			ELSE
				'-'
		END,
	Rez_Rate_Level = 
		CASE 
			WHEN Reservation.Rate_ID IS NOT NULL  THEN
				Contract.Rate_Level
			ELSE
				'-'
		END,
	ADJ =	CASE 
			WHEN EXISTS 	(SELECT bt.Business_Transaction_ID 
					FROM Business_Transaction bt
					WHERE bt.Contract_Number = Contract.Contract_Number
						AND bt.Transaction_Type = 'Con'
						AND bt.Transaction_Description = 'Adjustments') THEN
				'Y'
			ELSE
				''
		END							
FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
   	RP__First_Vehicle_On_Contract 
		ON Contract.Contract_Number = RP__First_Vehicle_On_Contract.Contract_Number
    	INNER 
	JOIN
   	RP__Last_Vehicle_On_Contract 
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number    	
	INNER 
	JOIN
	Vehicle_Class
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	LEFT 
	OUTER 
	JOIN
   	Reservation 
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number

WHERE 	Contract.Status IN ('CO', 'CI')
































GO
