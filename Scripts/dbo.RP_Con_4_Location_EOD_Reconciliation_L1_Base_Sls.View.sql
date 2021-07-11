USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Sls]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_L1_Base_Sls
PURPOSE: Get all transaction Information for separate sale contracts

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_4_Location_EOD_Reconciliation_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/11/05	Display null instead of 0 for unit number
Joseph Tseung	2000/01/20      Display '*' in Handheld column if any of the major credit card (Amex, diners, JCB, MC and VISA)
				payment/refund authorisations for the transactions were entered manually.	
*/
CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Sls]
AS
-- ALL accessory sales payments and refunds
SELECT 
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Location.Location AS Location_Name, 
    	Business_Transaction.Transaction_Type AS Document_Type, 
    	Business_Transaction.Sales_Contract_Number AS Document_Number, 
    	'' AS Foreign_Document_Number, 
    	Business_Transaction.Transaction_Description, 
    	Business_Transaction.Transaction_Date, 
    	Business_Transaction.User_ID, 
	NULL AS Unit_Number,
    	Signature_Flag = CASE 
			WHEN Business_Transaction.Signature_Required <> 0
				THEN 'S'
				ELSE NULL
			END,
    	Handheld_Flag = CASE 
			WHEN Business_Transaction.Entered_On_Handheld <> 0
				THEN 'H'
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Sales_Accessory_Sale_Payment.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND tS.Terminal_ID IS NULL 
				THEN '*'
			ELSE NULL
			END,
	-- $Cdn cash payment
	SUM(CASE 
		WHEN ((Sales_Accessory_Cash_Payment.Cash_Payment_Type > 0 
			and Sales_Accessory_Cash_Payment.Cash_Payment_Type != 2)  -- not debit card
			OR Sales_Accessory_Cash_Payment.Cash_Payment_Type = -2 ) --include cash direct refund
			AND Sales_Accessory_Cash_Payment.Currency_ID =  1 
		THEN Sales_Accessory_Cash_Payment.Foreign_Money_Collected
		ELSE 0
	        END) AS Cash_Payment_Cdn_Amt,
   	
	-- $US cash payment
    	SUM(CASE 
		WHEN (Sales_Accessory_Cash_Payment.Cash_Payment_Type > 0 OR Sales_Accessory_Cash_Payment.Cash_Payment_Type in (-2, -3) ) --include cash or debit card direct refund
			AND Sales_Accessory_Cash_Payment.Currency_ID = 2
		THEN Sales_Accessory_Cash_Payment.Foreign_Money_Collected
		ELSE 0
	        END) AS Cash_Payment_US_Amt,

	-- $Cdn Debit Card payment
	SUM(CASE 
		WHEN (Sales_Accessory_Cash_Payment.Cash_Payment_Type = 2 -- debit card only 
			OR Sales_Accessory_Cash_Payment.Cash_Payment_Type = -3)  --include debit card direct refund
			AND Sales_Accessory_Cash_Payment.Currency_ID =  1 
		THEN Sales_Accessory_Cash_Payment.Foreign_Money_Collected
		ELSE 0
	        END) AS DebitCard_Payment_Cdn_Amt,

   	-- $Cdn mail refund
	SUM(CASE 
		WHEN Sales_Accessory_Cash_Payment.Cash_Payment_Type = -1
			 AND Sales_Accessory_Cash_Payment.Currency_ID =  1
		THEN  Sales_Accessory_Cash_Payment.Foreign_Money_Collected -- already negative
		ELSE 0
	      END) AS Mail_Refund_Cdn_Amt,

    	-- Budget Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID IN ('BOV', 'BRC', 'PHH', 'BML', 'GEC', 'BU')
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_Budget_Amt,

    	-- Sears Credit Card
	/*SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'SRS'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_Sears_Amt,*/

    	-- Novus Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DIS'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_Novus_Amt,

    	-- AMEX Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'AMX'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_AMEX_Amt,

    	-- Diners Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DC'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_Diners_Amt,

    	-- JCB Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'JCB'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_JCB_Amt,

    	-- MC Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'MCD'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_MC_Amt,

    	-- VISA Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'VSA'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS CC_VISA_Amt,

	-- no direct billing for Accessory Sales
	-- change calculate for direct bill /peter ni 2012/02/03
	SUM(CASE 
		WHEN Sales_Accessory_Sale_Payment.payment_type = 'Direct Bill'
		THEN Sales_Accessory_Sale_Payment.Amount
		ELSE 0
	     END) AS Direct_Billing_Amt
	
FROM 	Business_Transaction WITH(NOLOCK)
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

LEFT OUTER JOIN

   	Sales_Accessory_Cash_Payment
		ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = Sales_Accessory_Cash_Payment.Sales_Contract_Number

LEFT OUTER JOIN

	Sales_Accessory_CrCard_Payment tS
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = tS.Credit_Card_Key
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID

	ON Sales_Accessory_Sale_Payment.Sales_Contract_Number = tS.Sales_Contract_Number

GROUP BY
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Location.Location, 
    	Business_Transaction.Transaction_Type, 
    	Business_Transaction.Sales_Contract_Number, 
    	Business_Transaction.Transaction_Description, 
    	Business_Transaction.Transaction_Date, 
    	Business_Transaction.User_ID,
	CASE 
			WHEN Business_Transaction.Signature_Required <> 0
				THEN 'S'
				ELSE NULL
			END,
    	CASE 
			WHEN Business_Transaction.Entered_On_Handheld <> 0
				THEN 'H'
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Sales_Accessory_Sale_Payment.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND tS.Terminal_ID IS NULL 
				THEN '*'
			ELSE NULL
			END
GO
