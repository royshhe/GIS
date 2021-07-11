USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_9_Referral_Organization_Payment_L2_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_9_Referral_Organization_Payment_L2_Main
PURPOSE:   Select information required for Referral Organization Payment report for both
	   checked out and checked in contracts
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/12/14
USED BY: Stored Procedure RP_SP_Acc_9_Referral_Organization_Payment_Main
MOD HISTORY:
Name 		Date		Comments
*/

CREATE VIEW [dbo].[RP_Acc_9_Referral_Organization_Payment_L2_Main]
AS
-- select CHECKED IN contracts with Commission Rate = FLAT OR PERCENTAGE
SELECT 	1 AS Group_ID,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Check_Out_RBR_Date,
	Business_Transaction.RBR_Date AS Check_In_RBR_Date,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_day,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage,
   	Organization.Organization_ID,
	Organization.Organization,
	Organization.Address_1 + Organization.Address_2 + ', ' + Organization.City AS Address,
	Payable = CASE Organization.Commission_Payable
		WHEN 'C' THEN
			'Company'
		WHEN 'N' THEN
			'Not Payable'
		WHEN 'E' THEN
			'Employee'
		ELSE
			''
	END,
   	Organization.Org_Type 		AS Org_Type_ID,
   	Lookup_Table.Value 		AS Org_Type_Name,
	Staff = CASE
		WHEN Referring_Employee.Referring_Employee_ID IS NOT NULL THEN
			Referring_Employee.Last_Name + ', ' + Referring_Employee.First_Name
		ELSE
			NULL
		END,
   	Contract.Pick_Up_Location_ID,
   	Location.Location 					AS Pick_Up_Location_Name,
	Business_Transaction.Contract_Number,
   	Contract.Last_Name + ', ' + Contract.First_Name 	AS Customer_Name,
    	Contract.Confirmation_Number,
               reservation.foreign_confirm_number, 
              Contract.Pick_Up_On,
   	FPO_Purchase = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3.FPO_Purchase > 0
		     AND RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
			'Y'
		ELSE
			NULL
		END,
	Referral_Fee_Commission = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate IS NOT NULL THEN
			RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_Day IS NOT NULL THEN
			CASE WHEN dbo.GetRentalDays(DATEDIFF(hour, contract.Pick_Up_On, rlv.Actual_Check_In)) >= 1 THEN
				RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_Day 
				* ceiling(dbo.GetRentalDays(DATEDIFF(hour, contract.Pick_Up_On, rlv.Actual_Check_In)))
			ELSE	
				0
			END
		ELSE
		-- use '+' sign for less discount because discount is already in -ve
			RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage
			* (RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Time_Km_Total
	 			+ RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Discount_Total
			  )/ 100.00
		END,
	PAI_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.PAI_Total
		ELSE
			NULL
		END,
	LDW_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.LDW_Total
		ELSE
			NULL
		END,
	PEC_Cargo_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.PEC_Cargo_Total
		ELSE
			NULL
		END,
	Time_Km_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
		-- use '+' sign for less discount because discount is already in -ve
    			(RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Time_Km_Total
			 + RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Discount_Total)
		ELSE
			NULL
		END	
FROM 	Business_Transaction WITH(NOLOCK)
	INNER JOIN
   	Contract
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON Contract.Contract_Number = rlv.Contract_Number
         
    	INNER JOIN
   	Organization
		ON Contract.Referring_Organization_ID = Organization.Organization_ID
    	INNER JOIN
   	Location
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
   	Lookup_Table Lookup_Table1
		ON Location.Owning_Company_ID = Lookup_Table1.Code
	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3
    		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3.Contract_Number
    	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1
		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Contract_Number
    	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2
    		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Contract_Number
             LEFT OUTER JOIN
              reservation
                          on reservation.confirmation_number=contract.confirmation_number
    	LEFT OUTER JOIN
   	Lookup_Table
		ON Organization.Org_Type = Lookup_Table.Code
		AND Lookup_Table.Category = 'OrgType'
	LEFT OUTER JOIN
   	Referring_Employee
		ON Contract.Referring_Employee_ID = Referring_Employee.Referring_Employee_ID
WHERE 	(Business_Transaction.Transaction_Type = 'Con')
	AND
   	(Business_Transaction.Transaction_Description = 'Check In')
	AND
    	(Location.Rental_Location = 1)
	AND
   	(Lookup_Table1.Category = 'BudgetBC Company')
	AND
   	(Contract.Status = 'CI')
 
UNION ALL

-- select CHECKED OUT contracts with Commission Rate = FLAT
SELECT 	1 AS Group_ID,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Check_Out_RBR_Date,
	NULL AS Check_In_RBR_Date,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_day,
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage,
   	Organization.Organization_ID,
	Organization.Organization,
	Organization.Address_1 + Organization.Address_2 + ', ' + Organization.City AS Address,
	Payable = CASE Organization.Commission_Payable
		WHEN 'C' THEN
			'Company'
		WHEN 'N' THEN
			'Not Payable'
		WHEN 'E' THEN
			'Employee'
		ELSE
			''
	END,
   	Organization.Org_Type 		AS Org_Type_ID,
   	Lookup_Table.Value 		AS Org_Type_Name,
	Staff = CASE
		WHEN Referring_Employee.Referring_Employee_ID IS NOT NULL THEN
			Referring_Employee.Last_Name + ', ' + Referring_Employee.First_Name
		ELSE
			NULL
		END,
   	Contract.Pick_Up_Location_ID,
   	Location.Location 					AS Pick_Up_Location_Name,
	Contract.Contract_Number,
   	Contract.Last_Name + ', ' + Contract.First_Name 	AS Customer_Name,
    	Contract.Confirmation_Number, 
     reservation.foreign_confirm_number, 
         
             Contract.Pick_Up_On,
   	FPO_Purchase = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3.FPO_Purchase > 0
		     AND RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
			'Y'
		ELSE
			NULL
		END,
	Referral_Fee_Commission = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate IS NOT NULL THEN
			RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_Day IS NOT NULL THEN
			RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Per_Day 
			* (DATEDIFF(mi, contract.Pick_Up_On, rlv.Actual_Check_In) / 1440.0)
			
		ELSE
		-- use '+' sign for less discount because discount is already in -ve
			RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage
			* (RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Time_Km_Total
	 			+ RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Discount_Total
			  )/ 100.00
		END,
	PAI_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.PAI_Total
		ELSE
			NULL
		END,
	LDW_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.LDW_Total
		ELSE
			NULL
		END,
	PEC_Cargo_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
    			RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.PEC_Cargo_Total

		ELSE
			NULL
		END,
	Time_Km_Total = CASE
		WHEN RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Percentage IS NOT NULL
		THEN
		-- use '+' sign for less discount because discount is already in -ve
    			(RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Time_Km_Total
			 + RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Discount_Total)
		ELSE
			NULL
		END	
FROM 	Contract
       	INNER JOIN
   	RP__Last_Vehicle_On_Contract rlv
		ON Contract.Contract_Number = rlv.Contract_Number
	INNER JOIN
   	Organization
		ON Contract.Referring_Organization_ID = Organization.Organization_ID
    	INNER JOIN
   	Location
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	INNER JOIN
   	Lookup_Table Lookup_Table1
		ON Location.Owning_Company_ID = Lookup_Table1.Code
	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3
    		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_FPO_Purchase_Base_3.Contract_Number
    	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1
		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_Totals_Base_1.Contract_Number
    	INNER JOIN
   	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2
    		ON Contract.Contract_Number = RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Contract_Number
    	LEFT OUTER JOIN
              reservation
                          on reservation.confirmation_number=contract.confirmation_number
    	LEFT OUTER JOIN
   	Lookup_Table
		ON Organization.Org_Type = Lookup_Table.Code
		AND Lookup_Table.Category = 'OrgType'
	LEFT OUTER JOIN
   	Referring_Employee
		ON Contract.Referring_Employee_ID = Referring_Employee.Referring_Employee_ID
WHERE 	Location.Rental_Location = 1
	AND
   	Lookup_Table1.Category = 'BudgetBC Company'
	AND
   	Contract.Status = 'CO'
	AND
	RP_Acc_9_Referral_Organization_Payment_L1_Commission_Rate_Base_2.Flat_Rate IS NOT NULL

















GO
