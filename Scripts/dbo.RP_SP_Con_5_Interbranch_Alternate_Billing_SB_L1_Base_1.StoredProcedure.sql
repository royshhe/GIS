USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_5_Interbranch_Alternate_Billing_SB_L1_Base_1]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PROCEDURE NAME: RP_SP_Con_5_Interbranch_Alternate_Billing_SB_L1_Base_1
PURPOSE: Select all the information needed for
	 Alternate Billing Subreport of Interbranch Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Alternate Billing Subreport of Interbranch Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE Procedure [dbo].[RP_SP_Con_5_Interbranch_Alternate_Billing_SB_L1_Base_1]
		@BusinessTransactionID int = 100000,
		@ContractNumber int = 10687	
AS
SELECT	Contract_Payment_Item.Contract_Number,
		Contract_Billing_Party.Billing_Method,
		armaster.address_name AS Organization,
		MIN(Voucher_Alternate_Billing.Description) AS Voucher_Description,			
		SUM(Contract_Payment_Item.Amount) AS Total_Billed
FROM		Contract_Payment_Item with(nolock)
		INNER JOIN
		AR_Payment
			ON Contract_Payment_Item.Contract_Number = AR_Payment.Contract_Number
			AND Contract_Payment_Item.Sequence = AR_Payment.Sequence
		INNER JOIN
		Contract_Billing_Party
			ON AR_Payment.Contract_Number = Contract_Billing_Party.Contract_Number
			AND AR_Payment.Contract_Billing_Party_ID = Contract_Billing_Party.Contract_Billing_Party_ID
		LEFT OUTER JOIN
		armaster
			ON Contract_Billing_Party.Customer_Code = armaster.customer_code
		LEFT OUTER JOIN
		Voucher_Alternate_Billing
			ON Contract_Billing_Party.Contract_Number = Voucher_Alternate_Billing.Contract_Number
			AND Contract_Billing_Party.Contract_Billing_Party_ID = Voucher_Alternate_Billing.Contract_Billing_Party_ID
WHERE	(Contract_Billing_Party.Billing_Method = 'Direct Bill'
		OR Contract_Billing_Party.Billing_Method = 'Voucher'
		OR Contract_Billing_Party.Billing_Method = 'Loss Of Use')
		AND
		(armaster.ship_to_code = '')
		AND
		(armaster.address_type = 0)
		AND
		(Contract_Payment_Item.Business_Transaction_ID <= @BusinessTransactionID)
		AND
		(Contract_Payment_Item.Contract_Number = @ContractNumber)
GROUP BY	Contract_Payment_Item.Contract_Number,
		Contract_Billing_Party.Billing_Method,
		Voucher_Alternate_Billing.Description,
		armaster.address_name

return @@ROWCOUNT


















GO
