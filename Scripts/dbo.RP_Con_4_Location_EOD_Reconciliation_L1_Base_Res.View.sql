USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Res]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_L1_Base_Res
PURPOSE: Get all transaction Information for reservations

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_4_Location_EOD_Reconciliation_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/12	Report foreign confimation number if it is a foreign reservation
Joseph Tseung	1999/11/05	Display null instead of 0 for unit number
Joseph Tseung	2000/01/20      Display '*' in Handheld column if any of the major credit card (Amex, diners, JCB, MC and VISA)
				payment/refund authorisations for the transactions were entered manually.	
Vivian Leung	2003/09/16	Include the new debit card refund in calculation
Vivian Leung	2003/10/10	Add Debit Card Column under Cash
*/
CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Res]
AS
-- ALL Reservations payments and refunds
SELECT 
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Location.Location AS Location_Name, 
    	Business_Transaction.Transaction_Type AS Document_Type, 
    	Business_Transaction.Confirmation_Number AS Document_Number, 
    	Reservation.Foreign_Confirm_Number AS Foreign_Document_Number, 
    	Business_Transaction.Transaction_Description, 
    	Business_Transaction.Transaction_Date, 
    	Business_Transaction.User_ID, 
	NULL AS Unit_Number,
    	Signature_Flag = CASE 
			WHEN Business_Transaction.Signature_Required  <> 0
				THEN 'S'
				ELSE NULL
			END,
    	Handheld_Flag = CASE 
			WHEN Business_Transaction.Entered_On_Handheld <> 0
				THEN 'H'
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Reservation_Dep_Payment.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND  (tRcc.Terminal_ID IS NULL or tRcc.Terminal_ID='EIGEN')
				THEN '*'


			ELSE NULL
			END,
	-- $Cdn cash payment
	SUM(CASE 
		WHEN ((Reservation_Cash_Dep_Payment.Cash_Payment_Type > 0 
			and Reservation_Cash_Dep_Payment.Cash_Payment_Type != 2) -- not debit card
			OR Reservation_Cash_Dep_Payment.Cash_Payment_Type = -2 ) --include cash or debit card direct refund
			AND Reservation_Cash_Dep_Payment.Currency_ID =  1 
		THEN Reservation_Cash_Dep_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cash_Payment_Cdn_Amt,
   	
	-- $US cash payment
    	SUM(CASE 
		WHEN (Reservation_Cash_Dep_Payment.Cash_Payment_Type > 0 
			OR Reservation_Cash_Dep_Payment.Cash_Payment_Type in (-2, -3) ) --include cash or debit card direct refund
			AND Reservation_Cash_Dep_Payment.Currency_ID = 2
		THEN Reservation_Cash_Dep_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cash_Payment_US_Amt,
	
	-- $Cdn Debit Card payment
	SUM(CASE 
		WHEN (Reservation_Cash_Dep_Payment.Cash_Payment_Type = 2 
			OR Reservation_Cash_Dep_Payment.Cash_Payment_Type = -3 ) --include cash or debit card direct refund
			AND Reservation_Cash_Dep_Payment.Currency_ID =  1 
		THEN Reservation_Cash_Dep_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS DebitCard_Payment_Cdn_Amt,

   	-- $Cdn mail refund
	SUM(CASE 
		WHEN Reservation_Cash_Dep_Payment.Cash_Payment_Type = -1
			 AND Reservation_Cash_Dep_Payment.Currency_ID =  1
		THEN Reservation_Cash_Dep_Payment.Foreign_Currency_Amt_Collected -- already negative
		ELSE 0
	      END) AS Mail_Refund_Cdn_Amt,
	
    	-- Budget Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID IN ('BOV', 'BRC', 'PHH', 'BML', 'GEC', 'BU')
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_Budget_Amt,

    	-- Sears Credit Card
	/*SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'SRS'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_Sears_Amt,*/

    	-- Novus Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DIS'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_Novus_Amt,

    	-- AMEX Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'AMX'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_AMEX_Amt,

    	-- Diners Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DC'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_Diners_Amt,

    	-- JCB Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'JCB'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_JCB_Amt,

    	-- MC Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'MCD'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_MC_Amt,

    	-- VISA Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'VSA'
		THEN Reservation_Dep_Payment.Amount
		ELSE 0
	     END) AS CC_VISA_Amt,

	-- no direct billing for Reservation 
	0 AS Direct_Billing_Amt
	
FROM 	Business_Transaction  WITH(NOLOCK)
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

LEFT OUTER JOIN

   	Reservation_Cash_Dep_Payment 
		ON Reservation_Dep_Payment.Confirmation_Number = Reservation_Cash_Dep_Payment.Confirmation_Number
     		AND Reservation_Dep_Payment.Collected_On = Reservation_Cash_Dep_Payment.Collected_On
				and Reservation_Dep_Payment.sequence=Reservation_Cash_Dep_Payment.sequence

LEFT OUTER JOIN

	Reservation_CC_Dep_Payment tRcc
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = tRcc.Credit_Card_Key
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID

	ON Reservation_Dep_Payment.Confirmation_Number = tRcc.Confirmation_Number
	AND Reservation_Dep_Payment.Collected_On = tRcc.Collected_On 
	and Reservation_Dep_Payment.sequence=trcc.sequence

GROUP BY
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Location.Location, 
    	Business_Transaction.Transaction_Type, 
    	Business_Transaction.Confirmation_Number, 
    	Reservation.Foreign_Confirm_Number,
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
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Reservation_Dep_Payment.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND (tRcc.Terminal_ID IS NULL or tRcc.Terminal_ID='EIGEN')
				THEN '*'
			ELSE NULL
			END
GO
