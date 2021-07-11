USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Totals]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Totals
PURPOSE: Get breakdown of credit card amounts for all transactions (Manual, Automatic and Imbalance)

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/12/16
USED BY: Subreport (Credit Card Totals by Location/Company) of report RP_Con_4_Location_EOD_Reconciliation.rpt
MOD HISTORY:
Name 		Date		Comments
Kenneth Wong	Dec 07, 2005	Delete imbalance
*/
CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Totals]
AS
-- Select all Manual and Automatic Credit Card Transactions for Contracts
SELECT
	Transaction_Type = CASE WHEN Credit_Card_Payment.Terminal_ID IS NULL 
				THEN 'Manual'
				ELSE 'Automatic'
			   END,
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Credit_Card_Type.Credit_Card_Type,
	Purchase = CASE WHEN Contract_Payment_Item.Amount > 0
		   	THEN Contract_Payment_Item.Amount
			ELSE 0
		   END,
	Refund = CASE WHEN Contract_Payment_Item.Amount < 0
		  	THEN ABS(Contract_Payment_Item.Amount)
			ELSE 0
		   END
FROM 	Contract
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
	Credit_Card_Payment
		ON Contract_Payment_Item.Contract_Number = Credit_Card_Payment.Contract_Number
		AND Contract_Payment_Item.Sequence = Credit_Card_Payment.Sequence 
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = Credit_Card_Payment.Credit_Card_Key
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID 
		AND Credit_Card_Type.Electronic_Authorization = 1 -- major credit cards


UNION ALL

-- Select all Manual and Automatic Credit Card Transactions for Reservations
SELECT 
	Transaction_Type = CASE WHEN tRcc.Terminal_ID IS NULL 
				THEN 'Manual'
				ELSE 'Automatic'
			   END,
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Credit_Card_Type.Credit_Card_Type,
	Purchase = CASE WHEN Reservation_Dep_Payment.Amount > 0
		   	THEN Reservation_Dep_Payment.Amount
			ELSE 0
		   END,
	Refund = CASE WHEN Reservation_Dep_Payment.Amount < 0
		  	THEN ABS(Reservation_Dep_Payment.Amount)
			ELSE 0
		   END

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
	Reservation_CC_Dep_Payment tRcc
		ON Reservation_Dep_Payment.Confirmation_Number = tRcc.Confirmation_Number
		AND Reservation_Dep_Payment.Collected_On = tRcc.Collected_On 
		and Reservation_Dep_Payment.sequence=tRcc.sequence
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = tRcc.Credit_Card_Key 
			and Credit_Card.credit_card_number is not null
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID 
		AND Credit_Card_Type.Electronic_Authorization = 1 -- major credit cards

UNION ALL

-- Select all Manual and Automatic Credit Card Transactions for Separate Accessory Sales

SELECT 
	Transaction_Type = CASE WHEN tS.Terminal_ID IS NULL 
				THEN 'Manual'
				ELSE 'Automatic'
			   END,
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Credit_Card_Type.Credit_Card_Type,
	Purchase = CASE WHEN Sales_Accessory_Sale_Payment.Amount > 0
		   	THEN Sales_Accessory_Sale_Payment.Amount
			ELSE 0
		   END,
	Refund = CASE WHEN Sales_Accessory_Sale_Payment.Amount < 0
		  	THEN ABS(Sales_Accessory_Sale_Payment.Amount)
			ELSE 0
		   END
	
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
	Sales_Accessory_CrCard_Payment tS
		ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = tS.Sales_Contract_Number
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = tS.Credit_Card_Key
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID 
		AND Credit_Card_Type.Electronic_Authorization = 1 -- major credit cards

GO
