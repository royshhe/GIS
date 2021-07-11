USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintAdvanceDep]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Retrieve deposit details for a contract to be used in contract print
COMMENT: Return all advance deposits for contract
	 See below of definition of 'advance'
	 GetCtrctPrintDep will return all non-advance deposits
MOD HISTORY:
Name	Date		Comment
CPY 	3/16/99 	previously using VOC.checked_out, now using Contract.PUD
CPY	3/25/99 	return negative amounts using "-" instead of brackets
CPY 	4/06/99 	bug fix - remove inner join between Credit_Card_Type and
				Credit_Card_Payment to handle partial credit cards 
CPY 	4/07/99 	bug fix - if partial CC and CC Type Id is null, return 'Credit Card' 
CPY 	6/24/99 	return cash payment type if cash;
	   		- removed all selected distinct
		   	- added CC transaction columns 
CPY 	8/04/99 	added cash currency, exchange rate, foreign amount,
			and collected at location 
CPY	Dec 16 1999	Changed CC transaction type from 'Deposit' to 'Purchase'
CPY	Dec 22 1999	Changed CC transaction type from 'Refund' to 'Return'
CPY	Jan 10 2000	Changed swiped flag field to return 'M' or 'S' depending on 
			whether transaction was processed via Eigen
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintAdvanceDep] --1256161
	@CtrctNum	VarChar(10)
AS
DECLARE @iCtrctNum Int
DECLARE @dAdvanceDep Datetime
	
	SELECT	@iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	-- Get contract PU Date; round to beginning of day
	SELECT 	@dAdvanceDep = Cast(Floor(Cast(Pick_Up_On as Float)) as Datetime)
	FROM	Contract
	WHERE	Contract_Number = @iCtrctNum

	-- return all advance deposits for contract
	-- advance deposit is any contract payment item collected before
	--   contract's PU datetime
	SELECT	
		CPI.Payment_Type,
		ISNULL(CCT.Credit_Card_Type, 'Credit Card'),
		CPI.Collected_On,
		Contract_Amount = CPI.Amount,
		CCP.Terminal_ID,
		CC.Credit_Card_Number,
		CC.Expiry,
		CASE
			WHEN CPI.Amount < 0 THEN 'Return'
			ELSE 'Purchase'
		END as Transaction_Type,
		CCP.Authorization_Number,
		CCP.Trx_Remarks,
		CCP.Trx_Receipt_Ref_Num,
		CCP.Trx_ISO_Response_Code,
		CASE
			-- suppress M/S if not processed via Eigen; if no terminal id, 
			-- then the CC transaction was not processed via Eigen
			WHEN CCP.Terminal_Id IS NULL THEN ''  
			WHEN CCP.Swiped_Flag = 0 THEN 'M'
			WHEN CCP.Swiped_Flag = 1 THEN 'S'
			ELSE ''	-- default
		END,	
		'', '', '',
		CPI.Collected_At_Location_ID
	FROM	Contract_Payment_Item CPI
		Inner Join 
		Credit_Card_Payment CCP
		On  CPI.Contract_Number = CCP.Contract_Number	AND	CPI.Sequence = CCP.Sequence
        Inner Join 	Credit_Card CC
		On CCP.Credit_Card_Key = CC.Credit_Card_Key
		Left Join Credit_Card_Type CCT
		On CC.Credit_Card_Type_Id = CCT.Credit_Card_Type_ID
--
--      Credit_Card_Type CCT,
--		Credit_Card CC,
--		Credit_Card_Payment CCP,
--		Contract_Payment_Item CPI
	WHERE CPI.Contract_Number = @iCtrctNum
--	AND	CPI.Contract_Number = CCP.Contract_Number
--	AND	CPI.Sequence = CCP.Sequence
--	AND	CCP.Credit_Card_Key = CC.Credit_Card_Key
--	AND	CC.Credit_Card_Type_Id *= CCT.Credit_Card_Type_ID
	AND	CPI.Collected_On < @dAdvanceDep

	UNION ALL

	SELECT	
		CPI.Payment_Type,
		LT.Value AS Payment_Type,
		CPI.Collected_On,
		Contract_Amount = CPI.Amount,
		--'', '', '', '', '', '', '', '', '',
		CP.Terminal_ID,
		CP.Identification_Number,
		'',
		CASE
			WHEN CPI.Amount < 0 THEN 'Return'
			ELSE 'Purchase'
		END as Transaction_Type,
		CP.Authorization_Number,
		CP.Trx_Remarks,
		CP.Trx_Receipt_Ref_Num,
		CP.Trx_ISO_Response_Code,
		CASE
			-- suppress M/S if not processed via Eigen; if no terminal id, 
			-- then the CC transaction was not processed via Eigen
			WHEN CP.Terminal_Id IS NULL THEN ''  
			WHEN CP.Swiped_Flag = 0 THEN 'M'
			WHEN CP.Swiped_Flag = 1 THEN 'S'
			ELSE ''	-- default
		END,  
		Convert(Char(5), CP.Currency_Id), Convert(Char(10), CP.Exchange_Rate),
		Convert(Char(10), CP.Foreign_Currency_Amt_Collected),
		CPI.Collected_At_Location_ID
	FROM	Contract_Payment_Item CPI
		Inner Join 	Cash_Payment CP
		On CPI.Contract_Number = CP.Contract_Number AND	CPI.Sequence = CP.Sequence
		Inner Join 	Lookup_Table LT
		On LT.Code = CP.Cash_Payment_Type
--
--		Cash_Payment CP,
--		Contract_Payment_Item CPI,
--		Lookup_Table LT
	WHERE	CPI.Contract_Number = @iCtrctNum
--	AND	CPI.Contract_Number = CP.Contract_Number
--	AND	CPI.Sequence = CP.Sequence
	AND	CPI.Collected_On < @dAdvanceDep
	AND	LT.Category IN ('Cash Payment Method','Cash Refund Method')
--	AND	LT.Code = CP.Cash_Payment_Type

	UNION ALL

	SELECT	
		CPI.Payment_Type,
		ARM.Address_Name,
		CPI.Collected_On,
		Contract_Amount = CPI.Amount,
		'', '', '', '', '', '', '', '', '',
		'', '', '',
		CPI.Collected_At_Location_ID
	FROM	armaster ARM,
		Contract_Billing_Party CBP,
		AR_Payment AR,
		Contract_Payment_Item CPI
	WHERE	CPI.Contract_Number = @iCtrctNum
	AND	CPI.Contract_Number = AR.Contract_Number
	AND	CPI.Sequence = AR.Sequence
	AND	CPI.Contract_Number = CBP.Contract_Number
	AND	AR.Contract_Billing_Party_Id = CBP.Contract_Billing_Party_Id
	AND	CBP.Customer_Code = ARM.Customer_Code
	AND	ARM.Address_Type = 0		-- get company name
	AND	CPI.Collected_On < @dAdvanceDep
	ORDER BY CPI.Collected_On, CPI.Payment_Type

	RETURN @@ROWCOUNT
GO
