USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_8_Frequent_Flyer_Payment_Summary]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_8_Frequent_Flyer_Payment_Summary
PURPOSE: Select all the information needed for Frequent Flyer Payment Summary Report.
	
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/15
USED BY: Frequent Flyer Payment Summary Report.
MOD HISTORY:
Name 		Date		Comments
*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_8_Frequent_Flyer_Payment_Summary]
(
	@paramStartBusDate varchar(20) = '22 Apr 1999',
	@paramEndBusDate varchar(20) = '23 Apr 1999',
	@paramFFPlanID varchar(18) = '*',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE 	@tmpLocID varchar(20), 
		@tmpFFPlanID varchar(18)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 

if @paramFFPlanID = '*'
	BEGIN
		SELECT @tmpFFPlanID = '0'
	END
else 
	BEGIN
		SELECT @tmpFFPlanID = @paramFFPlanID
	END

-- end of fixing the problem

SELECT distinct
	Contract.Pick_Up_Location_ID,
   	Location.Location AS Pick_Up_Location_Name,
   	Contract.FF_Member_Number,
   	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name,
    	Contract.Customer_Program_Number AS BCN_Number,
   	Perfect_Drive = CASE
		WHEN Reservation.Perfect_Drive_Indicator = 1 THEN
			'Y'
		ELSE
			''
		END,
	BCD_Number = CASE
		WHEN Contract.Quoted_Rate_ID IS NOT NULL THEN
		   	Organization.BCD_Number
		WHEN Organization_Rate.Rate_ID IS NOT NULL THEN		
			Organization.BCD_Number
		when Contract.BCD_Rate_Organization_ID is not null then
			Organization.BCD_Number
		ELSE
			NULL
		END,
	Contract.Company_Name,
   	Contract.Pick_Up_On,
	Drop_Off_Date = RP__Last_Vehicle_On_Contract.Actual_Check_In,
	Length = round(DATEDIFF(mi, Contract.Pick_Up_On, RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0,1),
   	Contract.Contract_Number,
	Vehicle_Class.Vehicle_Class_Name,
   	ISNULL(Vehicle_Rate.Rate_Name,Quoted_Vehicle_Rate.Rate_Name) AS Rate_Name,
   	Contract.Frequent_Flyer_Plan_ID,
   	Frequent_Flyer_Plan.Frequent_Flyer_Plan,
   	Contract.FF_Assigned_Date
FROM 	Contract with(nolock)
	INNER JOIN
	business_transaction 
		on business_transaction.contract_number = contract.contract_number
	inner join
   	Location
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
   	Lookup_Table
		ON Location.Owning_Company_ID = Lookup_Table.Code
	INNER JOIN
   	Frequent_Flyer_Plan
		ON Contract.Frequent_Flyer_Plan_ID = Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID
    	INNER JOIN
   	Vehicle_Class
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    	INNER JOIN
   	RP__Last_Vehicle_On_Contract
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number
    	LEFT OUTER JOIN
   	Organization
		ON Contract.BCD_Rate_Organization_ID = Organization.Organization_ID
    	LEFT OUTER JOIN
   	Reservation
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
    	LEFT OUTER JOIN
   	Vehicle_Rate
		ON Contract.Rate_ID = Vehicle_Rate.Rate_ID
		AND Contract.Rate_Assigned_Date >= Vehicle_Rate.Effective_Date
		AND Contract.Rate_Assigned_Date <= Vehicle_Rate.Termination_Date
    	LEFT OUTER JOIN
   	Quoted_Vehicle_Rate
		INNER JOIN
		Quoted_Rate_Category
			ON Quoted_Vehicle_Rate.Quoted_Rate_ID = Quoted_Rate_Category.Quoted_Rate_ID
			ON Contract.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID
	LEFT OUTER JOIN
	Organization_Rate
		ON Contract.Rate_ID = Organization_Rate.Rate_ID
		AND Contract.BCD_Rate_Organization_ID = Organization_Rate.Organization_ID
    		AND Contract.Rate_Level = Organization_Rate.Rate_Level
		AND Contract.Rate_Assigned_Date >= Organization_Rate.Effective_Date
		AND Contract.Rate_Assigned_Date <= Organization_Rate.Termination_Date
				
WHERE 	
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	business_transaction.transaction_description = 'Check in'
	AND
	(@paramFFPlanID = "*" OR Contract.Frequent_Flyer_Plan_ID = CONVERT(INT,@tmpFFPlanID))
	AND
	(@paramPickUpLocationID = "*" OR Contract.Pick_Up_Location_ID = CONVERT(INT, @tmpLocID))
	AND
	business_transaction.rbr_date BETWEEN @startBusDate AND @endBusDate
	and contract.status = 'CI'
	and contract.contract_number not in
	(
		select distinct contract.contract_number from 
		Contract with(nolock)
		INNER JOIN
		business_transaction 
			on business_transaction.contract_number = contract.contract_number
		where 
			business_transaction.transaction_description = 'Adjustments'
			and 
			business_transaction.rbr_date <= Contract.FF_Assigned_Date
	)


union

SELECT distinct
	Contract.Pick_Up_Location_ID,
   	Location.Location AS Pick_Up_Location_Name,
   	Contract.FF_Member_Number,
   	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name,
    	Contract.Customer_Program_Number AS BCN_Number,
   	Perfect_Drive = CASE
		WHEN Reservation.Perfect_Drive_Indicator = 1 THEN
			'Y'
		ELSE
			''
		END,
	BCD_Number = CASE
		WHEN Contract.Quoted_Rate_ID IS NOT NULL THEN
		   	Organization.BCD_Number
		WHEN Organization_Rate.Rate_ID IS NOT NULL THEN		
			Organization.BCD_Number
		when Contract.BCD_Rate_Organization_ID is not null then
			Organization.BCD_Number
		ELSE
			NULL
		END,
	Contract.Company_Name,
   	Contract.Pick_Up_On,
	Drop_Off_Date = RP__Last_Vehicle_On_Contract.Actual_Check_In,
	Length = round(DATEDIFF(mi, Contract.Pick_Up_On, RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0,1),
   	Contract.Contract_Number,
	Vehicle_Class.Vehicle_Class_Name,
   	ISNULL(Vehicle_Rate.Rate_Name,Quoted_Vehicle_Rate.Rate_Name) AS Rate_Name,
   	Contract.Frequent_Flyer_Plan_ID,
   	Frequent_Flyer_Plan.Frequent_Flyer_Plan,
   	Contract.FF_Assigned_Date
FROM 	Contract with(nolock)
	INNER JOIN
	business_transaction 
		on business_transaction.contract_number = contract.contract_number
	inner join
   	Location
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
   	Lookup_Table
		ON Location.Owning_Company_ID = Lookup_Table.Code
	INNER JOIN
   	Frequent_Flyer_Plan
		ON Contract.Frequent_Flyer_Plan_ID = Frequent_Flyer_Plan.Frequent_Flyer_Plan_ID
    	INNER JOIN
   	Vehicle_Class
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
    	INNER JOIN
   	RP__Last_Vehicle_On_Contract
		ON Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number
    	LEFT OUTER JOIN
   	Organization
		ON Contract.BCD_Rate_Organization_ID = Organization.Organization_ID
    	LEFT OUTER JOIN
   	Reservation
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
    	LEFT OUTER JOIN
   	Vehicle_Rate
		ON Contract.Rate_ID = Vehicle_Rate.Rate_ID
		AND Contract.Rate_Assigned_Date >= Vehicle_Rate.Effective_Date
		AND Contract.Rate_Assigned_Date <= Vehicle_Rate.Termination_Date
    	LEFT OUTER JOIN
   	Quoted_Vehicle_Rate
		INNER JOIN
		Quoted_Rate_Category
			ON Quoted_Vehicle_Rate.Quoted_Rate_ID = Quoted_Rate_Category.Quoted_Rate_ID
			ON Contract.Quoted_Rate_ID = Quoted_Vehicle_Rate.Quoted_Rate_ID
	LEFT OUTER JOIN
	Organization_Rate
		ON Contract.Rate_ID = Organization_Rate.Rate_ID
		AND Contract.BCD_Rate_Organization_ID = Organization_Rate.Organization_ID
    		AND Contract.Rate_Level = Organization_Rate.Rate_Level
		AND Contract.Rate_Assigned_Date >= Organization_Rate.Effective_Date
		AND Contract.Rate_Assigned_Date <= Organization_Rate.Termination_Date
				
WHERE 	
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	business_transaction.transaction_description = 'Adjustments'
	and 
	business_transaction.rbr_date <= Contract.FF_Assigned_Date
	AND
	(@paramFFPlanID = "*" OR Contract.Frequent_Flyer_Plan_ID = CONVERT(INT,@tmpFFPlanID))
	AND
	(@paramPickUpLocationID = "*" OR Contract.Pick_Up_Location_ID = CONVERT(INT, @tmpLocID))
	AND
	business_transaction.rbr_date BETWEEN @startBusDate AND @endBusDate
	and contract.status = 'CI'
GO
