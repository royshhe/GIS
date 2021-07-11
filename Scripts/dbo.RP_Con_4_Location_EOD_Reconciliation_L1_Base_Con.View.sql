USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con]
AS
/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con
PURPOSE: Get all transaction Information for contracts

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: View RP_Con_4_Location_EOD_Reconciliation_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/20	Change to exclude copied contract payments
Joseph Tseung	1999/11/05	Display null instead of 0 for unit number when contract status
				is other than Check In, Check Out and Change
Joseph Tseung	1999/11/10	Display check in vehicle unit for 'Foreign Check In'
				Display 'Void' when the contract is VOID on any transactions
Joseph Tseung 	1999/11/17	Display 'Void' when the contract is VOID on Check In transaction
Joseph Tseung	1999/12/14      Display '*' in Handheld column if any of the major credit card (Amex, diners, JCB, MC and VISA)
				payment/refund authorisations for the transactions were entered manually.				
Joseph Tseung	2000/01/10	Show ¡°Cancelled¡± for transaction description if contract is cancelled on an Open or Checked Out transaction.
Joseph Tseung	2000/01/13	Report accurate vehicle unit number according to the business transaction (after link is added between 
				business transaction and voc)
Joseph Tseung   2000/01/18	Use a single view to get the unit number associated with the business transaction for better maintainence
Joseph Tseung	2000/01/24	break down the record by payment items, not by transaction
Joseph Tseung	2000/02/15	Set Direct Bill payment amount to 0 for foreign contracts 
Vivian Leung	2003/09/16	Add Debit Card refund (Payment_type = -3)
Vivian Leung	2003/10/10	Add Debit Card column under Cash; and remove SEAR c/c from Credit Card
*/

-- ALL contract payments and refunds
SELECT
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Loc1.Location AS Location_Name, 
    	Business_Transaction.Transaction_Type AS Document_Type, 
    	Business_Transaction.Contract_Number AS Document_Number, 
    	Contract.Foreign_Contract_Number as Foreign_Document_Number,
	Contract_Payment_Item.Sequence AS Payment_Sequence,
    	Transaction_Description = CASE WHEN Contract.Status = 'VD' AND Business_Transaction.Transaction_Description = 'Check In'
					THEN 'Void'
					WHEN Contract.Status = 'CA' AND Business_Transaction.Transaction_Description IN ('Open', 'Check Out')
					THEN 'Cancelled'
					ELSE Business_Transaction.Transaction_Description
				  END, 
    	Business_Transaction.Transaction_Date, 
    	Business_Transaction.User_ID, 
	Unit_Number = voc.Unit_Number,
    	Signature_Flag = CASE 
			WHEN Business_Transaction.Signature_Required <> 0
				THEN 'S'
				ELSE NULL
			END,
    	Handheld_Flag = CASE 
			WHEN Business_Transaction.Entered_On_Handheld <> 0
				THEN 'H'
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Contract_Payment_Item.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND Credit_Card_Payment.Terminal_ID IS NULL 
				THEN '*'
			ELSE NULL
			END,
    	
	-- $Cdn cash payment
	SUM(CASE 
		WHEN (Cash_Payment.Cash_Payment_Type > 0 --cash payment
			and Cash_Payment.Cash_Payment_Type != 2 --not debit card
			AND Cash_Payment.Currency_ID =  1) 
		THEN Cash_Payment.Foreign_Currency_Amt_Collected
		WHEN (Cash_Payment.Cash_Payment_Type = -2  --cash direct refund
			AND Cash_Payment.Currency_ID =  1) 
		THEN - Cash_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cash_Payment_Cdn_Amt,
   	
	-- $US cash payment
    	SUM(CASE 
		WHEN (Cash_Payment.Cash_Payment_Type > 0 -- cash payment
			AND Cash_Payment.Currency_ID = 2)
		THEN Cash_Payment.Foreign_Currency_Amt_Collected
		WHEN (Cash_Payment.Cash_Payment_Type in (-2, -3)  --cash or debit card direct refund
			AND Cash_Payment.Currency_ID = 2)
		THEN - Cash_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cash_Payment_US_Amt,

	-- $CAD Debit Card payment (per Estella, all $CAD)
	SUM(CASE 
		WHEN (Cash_Payment.Cash_Payment_Type = 2 --debit card payment
			AND Cash_Payment.Currency_ID =  1) 
		THEN Cash_Payment.Foreign_Currency_Amt_Collected
		WHEN (Cash_Payment.Cash_Payment_Type = -3  --debit card direct refund
			AND Cash_Payment.Currency_ID =  1) 
		THEN - Cash_Payment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS DebitCard_Payment_Cdn_Amt,

   	-- $Cdn mail refund
	SUM(CASE 
		WHEN Cash_Payment.Cash_Payment_Type = -1
			 AND Cash_Payment.Currency_ID =  1
		THEN  -  Cash_Payment.Foreign_Currency_Amt_Collected
		ELSE 0

	      END) AS Mail_Refund_Cdn_Amt,
	
    	-- Budget Credit Card

	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID IN ('BOV', 'BRC', 'PHH', 'BML', 'GEC', 'BU')
		THEN Contract_Payment_Item.Amount

		ELSE 0
	     END) AS CC_Budget_Amt,

    	-- Sears Credit Card

	/*SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'SRS'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_Sears_Amt,*/

    	-- Novus Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DIS'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_Novus_Amt,

    	-- AMEX Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'AMX'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_AMEX_Amt,

    	-- Diners Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'DC'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_Diners_Amt,

    	-- JCB Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'JCB'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	    END) AS CC_JCB_Amt,

    	-- MC Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'MCD'
		THEN Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_MC_Amt,

    	-- VISA Credit Card
	SUM(CASE 
		WHEN Credit_Card.Credit_Card_Type_ID = 'VSA'
		THEN  Contract_Payment_Item.Amount
		ELSE 0
	     END) AS CC_VISA_Amt,

	-- direct billing 
	SUM(CASE 
		WHEN (Contract_Payment_Item.Payment_Type = 'A/R' AND Contract.Foreign_Contract_Number IS NULL)
		THEN  Contract_Payment_Item.Amount
		ELSE 0
	     END) AS Direct_Billing_Amt,

	-- $Cdn Cert payment
	SUM(CASE 
		WHEN (Prepayment.Payment_Type ='Certificate' --Certificate payment
			AND Prepayment.Currency_ID =  1) 
		THEN Prepayment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cert_Payment_Cdn_Amt,
   	
	-- $US Cert payment
    	SUM(CASE 
		WHEN (Prepayment.Payment_Type ='Certificate'  -- Certificate payment
			AND Prepayment.Currency_ID = 2)
		THEN Prepayment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Cert_Payment_US_Amt,
	-- $Cdn Voucher payment
	SUM(CASE 
		WHEN (Prepayment.Payment_Type ='Voucher' --Certificate payment
			AND Prepayment.Currency_ID =  1) 
		THEN Prepayment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Voucher_Payment_Cdn_Amt,
   	
	-- $US Cert payment
    	SUM(CASE 
		WHEN (Prepayment.Payment_Type ='Voucher'  -- Certificate payment
			AND Prepayment.Currency_ID = 2)
		THEN Prepayment.Foreign_Currency_Amt_Collected
		ELSE 0
	        END) AS Voucher_Payment_US_Amt

	
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
	LEFT
	JOIN
	RP_Con_4_Location_EOD_Reconciliation_L0_Base_Con_Unit_Number vBtvoc
		ON vBtvoc.Business_Transaction_ID = Business_Transaction.Business_Transaction_ID
	LEFT 
	JOIN
	Vehicle_On_Contract voc
		ON vBtvoc.Voc_Business_Transaction_ID = voc.Business_Transaction_ID
LEFT OUTER JOIN 

    	Contract_Payment_Item 
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

	ON Business_Transaction.Business_Transaction_ID = Contract_Payment_Item.Business_Transaction_ID

LEFT OUTER JOIN

   	Cash_Payment 
		ON Contract_Payment_Item.Contract_Number = Cash_Payment.Contract_Number
     		AND Contract_Payment_Item.Sequence = Cash_Payment.Sequence 

LEFT OUTER JOIN

   	AR_Payment 
		ON Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
     		AND Contract_Payment_Item.Sequence = AR_Payment.Sequence 	

LEFT OUTER JOIN

	Credit_Card_Payment
	INNER 
	JOIN
	Credit_Card
		ON Credit_Card.Credit_Card_Key = Credit_Card_Payment.Credit_Card_Key
	INNER
	JOIN
	Credit_Card_Type
		ON Credit_Card.Credit_Card_Type_ID = Credit_Card_Type.Credit_Card_Type_ID

	ON Contract_Payment_Item.Contract_Number = Credit_Card_Payment.Contract_Number
	AND Contract_Payment_Item.Sequence = Credit_Card_Payment.Sequence 

LEFT OUTER JOIN

   	Prepayment 
		ON Contract_Payment_Item.Contract_Number = Prepayment.Contract_Number
     		AND Contract_Payment_Item.Sequence = Prepayment.Sequence 

/*where Business_Transaction.location_id = 20
and Business_Transaction.rbr_date = '2003/09/10'*/
GROUP BY
	Business_Transaction.RBR_Date, 
	Business_Transaction.Location_ID, 
	Loc1.Location, 
    	Business_Transaction.Transaction_Type, 
    	Business_Transaction.Contract_Number, 
    	Contract.Foreign_Contract_Number, 
	Contract_Payment_Item.Sequence,
	CASE WHEN Contract.Status = 'VD' AND Business_Transaction.Transaction_Description = 'Check In'
					THEN 'Void'
					WHEN Contract.Status = 'CA' AND Business_Transaction.Transaction_Description IN ('Open', 'Check Out')
					THEN 'Cancelled'
					ELSE Business_Transaction.Transaction_Description
				  END, 
    	Business_Transaction.Transaction_Date, 
    	Business_Transaction.User_ID,
	voc.Unit_Number,
	CASE 
			WHEN Business_Transaction.Signature_Required <> 0
				THEN 'S'
				ELSE NULL
			END,
	CASE 
			WHEN Business_Transaction.Entered_On_Handheld <> 0
				THEN 'H'
			WHEN Business_Transaction.Entered_On_Handheld = 0 AND Contract_Payment_Item.Payment_Type = 'Credit Card' 
				AND Credit_Card_Type.Electronic_Authorization = 1 AND Credit_Card_Payment.Terminal_ID IS NULL 
				THEN '*'
			ELSE NULL
			END
GO
