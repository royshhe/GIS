USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_14_Frequent_Flyer_Submission_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*----------------------------------------------------------------------
VIEW NAME: RP_Acc_14_Frequent_Flyer_Submission_Main
PURPOSE: Select all the information needed for Frequent Flyer Submission Report.
	
AUTHOR:	Vivian Leung
DATE CREATED: 2004/02/09
USED BY: RP_SP_Acc_14_Frequent_Flyer_Submission.
MOD HISTORY:
Name 		Date		Comments
------------------------------------------------------------------------------------*/
CREATE VIEW [dbo].[RP_Acc_14_Frequent_Flyer_Submission_Main]
as
SELECT distinct
	'Transaction Code' = 'A' ,
	'RA Prefix' = null,
	'RA Number' = 'EBC' + right(convert(varchar(15), Contract.Contract_Number),6),
	business_transaction.rbr_date,
	--business_transaction.transaction_description,
	Location.Location,
	Contract.Pick_up_location_id,
	'DBR Code' = Location.DBRCode,
	'Last Name' = upper(replace(replace(Contract.Last_Name,'''', ''), '-', ' ')),
	'First Init' = upper(left(Contract.First_Name,1)),
	'C/I Rate Code' = null,
   	Vehicle_Class.Vehicle_Class_Code,
	/*'BCD Number' = CASE
		WHEN Contract.Quoted_Rate_ID IS NOT NULL THEN
		   	Organization.BCD_Number
		WHEN Organization_Rate.Rate_ID IS NOT NULL THEN		
			Organization.BCD_Number
		when Contract.BCD_Rate_Organization_ID is not null then
			Organization.BCD_Number
		else	null
		END,*/
	'BCD Number' = CASE
		WHEN Organization.BCD_Number IS NOT NULL THEN
		   	Organization.BCD_Number		
		ELSE
			Reservation.BCD_Number
		END,
	'Check In Date' = RP__Last_Vehicle_On_Contract.Actual_Check_In,
	'Check Out Date' = Contract.Pick_Up_On,
   	'FTP Code' = case when Frequent_Flyer_Plan.Maestro_code = 'AC'
			then 'CA'
			when Frequent_Flyer_Plan.Maestro_code = 'AA'
			then 'AD'						
			else Frequent_Flyer_Plan.Maestro_code
		end,
	'Frequent Flyer Number' = replace(replace(Contract.FF_Member_Number , '-', ' '), '/', ''),
	Contract.FF_Assigned_Date,
	Length = ceiling(DATEDIFF(mi, Contract.Pick_Up_On, RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0),
	'Gross T&M' = cci.total_charges,
	'Net T&M' = cci.total_charges,
	Contract.Frequent_Flyer_Plan_id,
             Reservation.Coupon_Code
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
	inner join
	(SELECT contract_number, SUM(amount) total_charges
                   FROM contract_charge_item
                  WHERE charge_type IN ('10', '11', '50', '51')
                  GROUP
                     BY contract_number
                ) cci
            ON  cci.contract_number = Contract.contract_number
    	LEFT OUTER JOIN
   	Organization
		ON Contract.BCD_Rate_Organization_ID = Organization.Organization_ID
    	LEFT OUTER JOIN
   	Reservation
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
    	/*LEFT OUTER JOIN
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
*/
				
WHERE 	
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	business_transaction.transaction_description = 'Check in'
	and
	contract.contract_number not in
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
	'Transaction Code' = 'A' ,
	'RA Prefix' = null,
	'RA Number' ='BC' + convert(varchar(15), Contract.Contract_Number),
	business_transaction.rbr_date,
	--business_transaction.transaction_description,
	Location.Location,
	Contract.Pick_up_location_id,
	'DBR Code' = Location.DBRCode,
	'Last Name' = upper(replace(replace(Contract.Last_Name,'''', ''), '-', ' ')),
	'First Init' = upper(left(Contract.First_Name,1)),
	'C/I Rate Code' = null,
   	Vehicle_Class.Vehicle_Class_Code,
	/*'BCD Number' = CASE
		WHEN Contract.Quoted_Rate_ID IS NOT NULL THEN
		   	Organization.BCD_Number
		WHEN Organization_Rate.Rate_ID IS NOT NULL THEN		
			Organization.BCD_Number
		when Contract.BCD_Rate_Organization_ID is not null then
			Organization.BCD_Number
		ELSE
			NULL
		END,*/
	'BCD Number' = CASE
		WHEN Organization.BCD_Number IS NOT NULL THEN
		   	Organization.BCD_Number		
		ELSE
			Reservation.BCD_Number
		END,

	'Check In Date' = RP__Last_Vehicle_On_Contract.Actual_Check_In,
	'Check Out Date' = Contract.Pick_Up_On,
   	'FTP Code' = case when Frequent_Flyer_Plan.Maestro_code = 'AC'
			then 'CA'
			when Frequent_Flyer_Plan.Maestro_code = 'AA'
			then 'AD'						
			else Frequent_Flyer_Plan.Maestro_code
		end,
	'Frequent Flyer Number' = replace(replace(Contract.FF_Member_Number , '-', ' '), '/', ''),
	Contract.FF_Assigned_Date,
	Length = ceiling(DATEDIFF(mi, Contract.Pick_Up_On, RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0),
	'Gross T&M' = cci.total_charges,
	'Net T&M' = cci.total_charges,
	Contract.Frequent_Flyer_Plan_id,
 	Reservation.Coupon_Code
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
	inner join
	(SELECT contract_number, SUM(amount) total_charges
                   FROM contract_charge_item
                  WHERE charge_type IN ('10', '11', '50', '51')
                  GROUP
                     BY contract_number
                ) cci
            ON  cci.contract_number = Contract.contract_number
    	LEFT OUTER JOIN
   	Organization
		ON Contract.BCD_Rate_Organization_ID = Organization.Organization_ID
    	LEFT OUTER JOIN
   	Reservation
		ON Contract.Confirmation_Number = Reservation.Confirmation_Number
 /*   	LEFT OUTER JOIN
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
	*/			
WHERE 	
	(Lookup_Table.Category = 'BudgetBC Company')
	AND
	business_transaction.transaction_description = 'Adjustments'
	and 
	business_transaction.rbr_date <= Contract.FF_Assigned_Date
GO
