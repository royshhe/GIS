USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_US_Cash_Totals]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_US_Cash_Totals]
AS
-- Select US Cash amounts for contracts
SELECT
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	lt3.Value AS Cash_Type,
	Cash_US_Amount = CASE WHEN (Cash_Payment.Cash_Payment_Type > 0 )--cash payment or refund (refund positive)
				THEN Cash_Payment.Foreign_Currency_Amt_Collected
				ELSE - Cash_Payment.Foreign_Currency_Amt_Collected
			 END
FROM 	Contract WITH(NOLOCK)
	INNER 
	JOIN
    	Business_Transaction 
		ON Contract.Contract_Number = Business_Transaction.Contract_Number
		AND Business_Transaction.Transaction_Type = 'Con'
        INNER 
	JOIN
    	Location loc1 
		ON Business_Transaction.Location_ID = loc1.Location_ID 
	INNER
     	JOIN
    	Lookup_Table lt1
		ON loc1.Owning_Company_ID = lt1.Code 
		AND lt1.Category = 'BudgetBC Company'
	INNER
	JOIN
    	Contract_Payment_Item 
		ON Business_Transaction.Business_Transaction_ID = Contract_Payment_Item.Business_Transaction_ID
	INNER 
	JOIN
	Location loc2
		ON Contract_Payment_Item.Collected_At_Location_ID = loc2.Location_ID
		AND Contract_Payment_Item.Copied_Payment = 0
	INNER
     	JOIN
    	Lookup_Table lt2
		ON loc2.Owning_Company_ID = lt2.Code 
		AND lt2.Category = 'BudgetBC Company' 
	INNER 
	JOIN
   	Cash_Payment 
		ON Contract_Payment_Item.Contract_Number = Cash_Payment.Contract_Number
     		AND Contract_Payment_Item.Sequence = Cash_Payment.Sequence 
		AND Cash_Payment.Currency_ID =  2 
		AND Cash_Payment.Cash_Payment_Type <> -1 --Not Mail Refund
	INNER
	JOIN
    	Lookup_Table lt3
		ON Cash_Payment.Cash_Payment_Type = lt3.Code 
		AND lt3.Category IN ('Cash Payment Method', 'Cash Refund Method') 

UNION ALL

-- Select Cdn Cash amounts for Reservations
SELECT 
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID,
	lt3.Value AS Cash_Type,
	Reservation_Cash_Dep_Payment.Foreign_Currency_Amt_Collected AS Cash_US_Amount --already negative for refund
	
FROM 	Business_Transaction 
	INNER 
	JOIN
	Reservation 
		On Business_Transaction.Confirmation_Number = Reservation.Confirmation_Number
		AND Business_Transaction.Transaction_Type = 'Res'
	INNER
	JOIN
    	Reservation_Dep_Payment
		ON Business_Transaction.Business_Transaction_ID = Reservation_Dep_Payment.Business_Transaction_ID
       	INNER 
	JOIN
    	Location 

		ON Business_Transaction.Location_ID = Location.Location_ID 
	INNER
     	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER 
	JOIN
   	Reservation_Cash_Dep_Payment 
		ON Reservation_Dep_Payment.Confirmation_Number = Reservation_Cash_Dep_Payment.Confirmation_Number
     		AND Reservation_Dep_Payment.Collected_On = Reservation_Cash_Dep_Payment.Collected_On
			and Reservation_Dep_Payment.sequence=Reservation_Cash_Dep_Payment.sequence
		AND Reservation_Cash_Dep_Payment.Currency_ID =  2
		AND Reservation_Cash_Dep_Payment.Cash_Payment_Type <> -1 --Not Mail Refund
	INNER
	JOIN
    	Lookup_Table lt3
		ON Reservation_Cash_Dep_Payment.Cash_Payment_Type = lt3.Code 
		AND lt3.Category IN ('Cash Payment Method', 'Cash Refund Method') 

UNION ALL

-- Select Cdn Cash amounts for Separate Accessory Sales
SELECT 
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	lt3.Value AS Cash_Type,
	Sales_Accessory_Cash_Payment.Foreign_Money_Collected AS Cash_US_Amount --already negative for refund

FROM 	Business_Transaction 
	INNER 
	JOIN
    	Sales_Accessory_Sale_Payment 
		ON Business_Transaction.Business_Transaction_ID = Sales_Accessory_Sale_Payment.Business_Transaction_ID
		AND Business_Transaction.Transaction_Type = 'Sls'
       	INNER 
	JOIN
    	Location 
		ON Business_Transaction.Location_ID = Location.Location_ID 
	INNER
     	JOIN
    	Lookup_Table 
		ON Location.Owning_Company_ID = Lookup_Table.Code 
		AND Lookup_Table.Category = 'BudgetBC Company'
	INNER
	JOIN
   	Sales_Accessory_Cash_Payment
		ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = Sales_Accessory_Cash_Payment.Sales_Contract_Number
		AND Sales_Accessory_Cash_Payment.Currency_ID =  2 -- Cdn$
		AND Sales_Accessory_Cash_Payment.Cash_Payment_Type <> -1 --Not Mail Refund
	INNER
	JOIN
    	Lookup_Table lt3
		ON Sales_Accessory_Cash_Payment.Cash_Payment_Type = lt3.Code 
		AND lt3.Category IN ('Cash Payment Method', 'Cash Refund Method')
GO
