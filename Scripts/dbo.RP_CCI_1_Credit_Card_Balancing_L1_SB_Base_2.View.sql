USE [GISData]
GO
/****** Object:  View [dbo].[RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
VIEW NAME: RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2
PURPOSE: Get information about credit card payments for differenet type of
	 documents (Resevations, Contracts and Sales Accessory)
	
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: RP_CCI_1_Credit_Card_Balancing_L2_SB_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/20	change to exclude copied contract payments
Vivian Leung	2002/04/26	change to display Foreign confirmation numbers for Maestro and Internet reservations
*/
CREATE VIEW [dbo].[RP_CCI_1_Credit_Card_Balancing_L1_SB_Base_2]
AS

-- contract payments
SELECT Credit_Card_Payment.Credit_Card_Key, 
    	convert(varchar(15), Contract_Payment_Item.Contract_Number) AS Document_Number,
     	Contract_Payment_Item.Amount, 
    	Contract_Payment_Item.Collected_On, 
    	Contract_Payment_Item.RBR_Date, 
    	Credit_Card_Payment.Authorization_Number, 
    	Credit_Card_Payment.Terminal_ID, 
    	'Contract' AS Document_Type
FROM 	Contract_Payment_Item WITH(NOLOCK)
	INNER JOIN
    	Credit_Card_Payment 
		ON Contract_Payment_Item.Contract_Number = Credit_Card_Payment.Contract_Number
     		AND Contract_Payment_Item.Sequence = Credit_Card_Payment.Sequence
		AND Contract_Payment_Item.Copied_Payment = 0
WHERE Credit_Card_Payment.Terminal_ID IS NOT NULL
	AND (Contract_Payment_Item.Payment_Type = 'Credit Card')

UNION ALL

-- reservation payments
SELECT	Reservation_CC_Dep_Payment.Credit_Card_Key, 
    	convert(varchar(15), Reservation_Dep_Payment.Confirmation_Number) AS Document_Number,
     	Reservation_Dep_Payment.Amount, 
    	Reservation_Dep_Payment.Collected_On, 
    	Reservation_Dep_Payment.RBR_Date, 
    	Reservation_CC_Dep_Payment.Authorization_Number, 
    	Reservation_CC_Dep_Payment.Terminal_ID, 
    	'Reservation' AS Document_Type
FROM 	Reservation WITH(NOLOCK)
	inner join
	Reservation_Dep_Payment 	
	on reservation.confirmation_number = Reservation_Dep_Payment.confirmation_number
	INNER JOIN
    	Reservation_CC_Dep_Payment 
	ON Reservation_Dep_Payment.Confirmation_Number = Reservation_CC_Dep_Payment.Confirmation_Number
     	AND Reservation_Dep_Payment.Collected_On = Reservation_CC_Dep_Payment.Collected_On
WHERE Reservation_Dep_Payment.Payment_Type = 'Credit Card' 
    	AND Reservation_CC_Dep_Payment.Terminal_ID IS NOT NULL
	AND Reservation.foreign_confirm_number is null

UNION

SELECT	Reservation_CC_Dep_Payment.Credit_Card_Key, 
    	Reservation.Foreign_Confirm_Number AS Document_Number,
     	Reservation_Dep_Payment.Amount, 
    	Reservation_Dep_Payment.Collected_On, 
    	Reservation_Dep_Payment.RBR_Date, 
    	Reservation_CC_Dep_Payment.Authorization_Number, 
    	Reservation_CC_Dep_Payment.Terminal_ID, 
    	'Reservation' AS Document_Type
FROM 	Reservation WITH(NOLOCK)
	inner join
	Reservation_Dep_Payment 	
	on reservation.confirmation_number = Reservation_Dep_Payment.confirmation_number
	INNER JOIN
    	Reservation_CC_Dep_Payment 
	ON Reservation_Dep_Payment.Confirmation_Number = Reservation_CC_Dep_Payment.Confirmation_Number
     	AND Reservation_Dep_Payment.Collected_On = Reservation_CC_Dep_Payment.Collected_On
WHERE Reservation_Dep_Payment.Payment_Type = 'Credit Card' 
    	AND Reservation_CC_Dep_Payment.Terminal_ID IS NOT NULL
	AND Reservation.foreign_confirm_number is not null

UNION ALL
-- sales accessory payments
SELECT	Sales_Accessory_CrCard_Payment.Credit_Card_Key, 
    	convert(varchar(15), Sales_Accessory_Sale_Payment.Sales_Contract_Number) AS Document_Number,
     	Sales_Accessory_Sale_Payment.Amount, 
    	Sales_Accessory_Sale_Payment.Collected_On, 
    	Sales_Accessory_Sale_Payment.RBR_Date, 
    	Sales_Accessory_CrCard_Payment.Authorization_Number, 
    	Sales_Accessory_CrCard_Payment.Terminal_ID, 
    	'Acc.Sales' AS Document_Type
FROM 	Sales_Accessory_CrCard_Payment WITH(NOLOCK)
	INNER JOIN
    	Sales_Accessory_Sale_Payment 
		ON Sales_Accessory_CrCard_Payment.Sales_Contract_Number = Sales_Accessory_Sale_Payment.Sales_Contract_Number
WHERE Sales_Accessory_Sale_Payment.Payment_Type = 'Credit Card'
     	AND Sales_Accessory_CrCard_Payment.Terminal_ID IS NOT NULL








GO
