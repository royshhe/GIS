USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_6_Mail_Refund_L1_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_Acc_6_Mail_Refund_L1_Main
PURPOSE: Select all the information needed for Mail Refund Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Mail Refund Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/09/27	eliminate extra comma from address
Joseph Tseung	1999/12/09	Extract all contracts with no country specified in the address on the contract.
*/
CREATE VIEW [dbo].[RP_Acc_6_Mail_Refund_L1_Main]
AS
-- mail refund from contracts
SELECT Business_Transaction.RBR_Date, 
    	'Contract' AS Document_Type, 
    	Business_Transaction.Contract_Number AS Document_Number,
    	Contract.Foreign_Contract_Number, 
   	Business_Transaction.Business_Transaction_ID, 
    	Contract_Payment_Item.Collected_At_Location_ID, 
	Location.Location AS Location_Name,
    	Contract.Last_Name + ', ' + Contract.First_Name AS Customer_Name, 
	Address = CASE 
		WHEN Contract.Address_2 IS NOT NULL AND Contract.Postal_Code IS NOT NULL
		THEN Contract.Address_1 + ', ' + Contract.Address_2 + ', '+ Contract.City +  ', ' + Contract.Province_State  + ', ' + Lookup_Table2.Value  + ', ' + Contract.Postal_Code
		WHEN Contract.Address_2 IS NULL AND Contract.Postal_Code IS NOT NULL
		THEN Contract.Address_1 + ', ' + Contract.City +  ', ' + Contract.Province_State  + ', ' +  Lookup_Table2.Value  + ', ' + Contract.Postal_Code
		WHEN Contract.Address_2 IS NOT NULL AND Contract.Postal_Code IS NULL
		THEN Contract.Address_1 + ', ' + Contract.Address_2 + ', '+ Contract.City +  ', ' + Contract.Province_State  + ', ' + Lookup_Table2.Value
		ELSE Contract.Address_1 + ', ' + Contract.City +  ', ' + Contract.Province_State  + ', ' + Lookup_Table2.Value
		  END,
	ABS(Contract_Payment_Item.Amount) AS Amount
FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Business_Transaction 
		ON Contract.Contract_Number = Business_Transaction.Contract_Number
	INNER
	JOIN
	Contract_Payment_Item 
		ON Contract_Payment_Item.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
	INNER 
	JOIN
   	Cash_Payment 
		ON  Cash_Payment.Contract_Number = Contract_Payment_Item.Contract_Number
		AND Cash_Payment.Sequence = Contract_Payment_Item.Sequence
		AND Cash_Payment.Cash_Payment_Type = -1 -- mail refund
     	INNER 
	JOIN
   	Location 
		ON Contract_Payment_Item.Collected_At_Location_ID = Location.Location_ID 
	INNER
     	JOIN
    	Lookup_Table AS Lookup_Table1
		ON Location.Owning_Company_ID = Lookup_Table1.Code
		AND Lookup_Table1.Category = 'BudgetBC Company'
	LEFT
	OUTER
	JOIN
    	Lookup_Table AS Lookup_Table2
		ON Contract.Country = Lookup_Table2.Code
		AND Lookup_Table2.Category = 'Country'

UNION ALL

-- mail refund from reservations

SELECT 
	Business_Transaction.RBR_Date, 
	'Reservation' AS Document_Type,
    	Reservation.Confirmation_Number AS Document_Number, 
    	NULL AS Foreign_Contract_Number,
	Business_Transaction.Business_Transaction_ID, 
    	Business_Transaction.Location_ID, 
	Location.Location AS Location_Name,
	Reservation.Last_Name + ', ' + Reservation.First_Name AS Customer_Name, 
	Address = CASE
		   WHEN Reservation.Customer_ID IS NULL
		   	THEN Reservation.Special_Comments
		   WHEN Reservation.Customer_ID IS NOT NULL AND Customer.Address_2 IS NOT NULL AND Customer.Postal_Code IS NOT NULL
		   	THEN Customer.Address_1 + ', ' +  Customer.Address_2 + ', ' + Customer.City + ', ' + Customer.Province + ', ' + Lookup_Table2.Value + ', ' + Customer.Postal_Code
		   WHEN Reservation.Customer_ID IS NOT NULL AND Customer.Address_2 IS NULL AND Customer.Postal_Code IS NOT NULL
		   	THEN Customer.Address_1 + ', ' +  Customer.City + ', ' + Customer.Province + ', ' +  Lookup_Table2.Value + ', ' + Customer.Postal_Code
		   WHEN Reservation.Customer_ID IS NOT NULL AND Customer.Address_2 IS NOT NULL AND Customer.Postal_Code IS NULL
		   	THEN Customer.Address_1 + ', ' +  Customer.Address_2 + ', ' + Customer.City + ', ' + Customer.Province + ', ' + Lookup_Table2.Value
		   ELSE Customer.Address_1 + ', ' + Customer.City + ', ' + Customer.Province + ', ' + Lookup_Table2.Value
		   END,

	ABS(Reservation_Dep_Payment.Amount) AS Amount

FROM 	Reservation_Dep_Payment 
	INNER 
	JOIN
    	Reservation_Cash_Dep_Payment 
		ON Reservation_Dep_Payment.Confirmation_Number = Reservation_Cash_Dep_Payment.Confirmation_Number
     		AND Reservation_Dep_Payment.Collected_On = Reservation_Cash_Dep_Payment.Collected_On
		AND Reservation_Cash_Dep_Payment.Cash_Payment_Type = -1 -- mail refund
    	INNER 
	JOIN
    	Business_Transaction 
		ON Reservation_Dep_Payment.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
	INNER 
	JOIN
    	Reservation 
		ON Business_Transaction.Confirmation_Number = Reservation.Confirmation_Number
     	INNER 
	JOIN
    	Location 
		ON Business_Transaction.Location_ID = Location.Location_ID 
	INNER
     	JOIN
    	Lookup_Table AS Lookup_Table1
		ON Location.Owning_Company_ID = Lookup_Table1.Code
		AND (Lookup_Table1.Category = 'BudgetBC Company')
	LEFT
	OUTER 
	JOIN
	Customer 
		ON Reservation.Customer_ID = Customer.Customer_ID
	LEFT
	OUTER
	JOIN
	Lookup_Table AS Lookup_Table2 
		ON Customer.Country = Lookup_Table2.Code
		AND Lookup_Table2.Category = 'Country'
   
UNION ALL

-- mail refund from accessory sales

SELECT 	
	Business_Transaction.RBR_Date, 
    	'Acc.Sales' AS Document_Type, 
    	Sales_Accessory_Sale_Payment.Sales_Contract_Number AS Document_Number,
     	NULL AS Foreign_Contract_Number, 
    	Business_Transaction.Business_Transaction_ID, 
   	Sales_Accessory_Sale_Contract.Sold_At_Location_ID,
	Location.Location AS Location_Name, 
    	Sales_Accessory_Sale_Contract.Last_Name + ', ' + Sales_Accessory_Sale_Contract.First_Name AS Customer_Name, 
    	Address = CASE 
		WHEN Sales_Accessory_Sale_Contract.Address_2 IS NOT NULL AND  Sales_Accessory_Sale_Contract.Postal_Code IS NOT NULL
		THEN Sales_Accessory_Sale_Contract.Address_1 + ', ' + Sales_Accessory_Sale_Contract.Address_2 +  ', ' + Sales_Accessory_Sale_Contract.City +  ', ' + Sales_Accessory_Sale_Contract.Province +  ', ' + Lookup_Table2.Value +  ', ' + Sales_Accessory_Sale_Contract.Postal_Code
		WHEN Sales_Accessory_Sale_Contract.Address_2 IS NULL AND  Sales_Accessory_Sale_Contract.Postal_Code IS NOT NULL
		THEN Sales_Accessory_Sale_Contract.Address_1 + ', '  + Sales_Accessory_Sale_Contract.City +  ', ' + Sales_Accessory_Sale_Contract.Province +  ', ' + Lookup_Table2.Value +  ', ' + Sales_Accessory_Sale_Contract.Postal_Code
		WHEN Sales_Accessory_Sale_Contract.Address_2 IS NOT NULL AND  Sales_Accessory_Sale_Contract.Postal_Code IS NULL
		THEN Sales_Accessory_Sale_Contract.Address_1 + ', ' + Sales_Accessory_Sale_Contract.Address_2 +  ', ' + Sales_Accessory_Sale_Contract.City +  ', ' + Sales_Accessory_Sale_Contract.Province +  ', ' +  Lookup_Table2.Value 
  	               ELSE Sales_Accessory_Sale_Contract.Address_1 + ', ' +  Sales_Accessory_Sale_Contract.City +  ', ' + Sales_Accessory_Sale_Contract.Province +  ', ' +  Lookup_Table2.Value 
            	     	   END,    
	ABS(Sales_Accessory_Sale_Payment.Amount) AS Amount

FROM 	Sales_Accessory_Sale_Payment 
       	INNER 
	JOIN
	Business_Transaction 
		ON Sales_Accessory_Sale_Payment.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
     	INNER 
	JOIN
    	Sales_Accessory_Sale_Contract 
		ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = Sales_Accessory_Sale_Contract.Sales_Contract_Number 
     	INNER 
	JOIN
    	Sales_Accessory_Cash_Payment 
		ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = Sales_Accessory_Cash_Payment.Sales_Contract_Number
		AND Sales_Accessory_Cash_Payment.Cash_Payment_Type = -1 -- mail refund
     	INNER 
	JOIN
    	Location 
		ON Sales_Accessory_Sale_Contract.Sold_At_Location_ID = Location.Location_ID 
     	INNER 
	JOIN
    	Lookup_Table AS Lookup_Table1
		ON Location.Owning_Company_ID = Lookup_Table1.Code
		AND Lookup_Table1.Category = 'BudgetBC Company'
	LEFT
	OUTER
	JOIN
    	Lookup_Table AS Lookup_Table2
		ON Sales_Accessory_Sale_Contract.Country = Lookup_Table2.Code
		AND Lookup_Table2.Category = 'Country'


















































GO
