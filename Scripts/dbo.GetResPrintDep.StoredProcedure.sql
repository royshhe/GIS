USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResPrintDep]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Retrieve deposit details for a reservation for the reservation print
MOD HISTORY:
Name	Date		Comment
CPY	8/16/99 	- created to merge together GetResDepCA, GetResDepCR 
CPY	11/14/99 	- added Forfeited flag 
CPY	dec 17 1999	- changed transaction type desc from 'Deposit' to 'Purchase'
CPY	Dec 22 1999	- changed transaction type desc from 'Refund' to 'Return'
CPY	Jan 10 2000	- Changed swiped flag field to return 'M' or 'S' depending on 
			whether transaction was processed via Eigen
*/


--select * from Reservation_CC_Dep_Payment
--select * from reservation_Cash_Dep_Payment

CREATE PROCEDURE [dbo].[GetResPrintDep]  --1089599 1465059
	@ConfirmNum	VarChar(10)
AS

DECLARE @iConfirmNum Int

	SELECT	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	
	SELECT	RDP.Payment_Type,
		ISNULL(CCT.Credit_Card_Type, 'Credit Card'),
		RDP.Collected_On,
		RDP.Amount,
		RCDP.Terminal_ID,
		CC.Credit_Card_Number,
		CC.Expiry,
		CASE
			WHEN RDP.Amount < 0 THEN 'Return' -- aka 'Refund'
			ELSE 'Purchase'		-- aka 'Deposit'
		END as Transaction_Type,
		RCDP.Authorization_Number,
		RCDP.Trx_Remarks,
		RCDP.Trx_Receipt_Ref_Num,
		RCDP.Trx_ISO_Response_Code,
		CASE
			-- suppress M/S if not processed via Eigen; if no terminal id, 
			-- then the CC transaction was not processed via Eigen
			WHEN RCDP.Terminal_Id IS NULL THEN ''  
			WHEN RCDP.Swiped_Flag = 0 THEN 'M'
			WHEN RCDP.Swiped_Flag = 1 THEN 'S'
			ELSE ''	-- default
		END,  --Convert(Char(1), RCDP.Swiped_Flag) as Swiped,
		'', '', '',
		RDP.Collected_At_Location_ID,
		Convert(Char(1), RDP.Forfeited) as Forfeited


FROM	Reservation_CC_Dep_Payment RCDP 
INNER JOIN  	Reservation_Dep_Payment RDP 
	On  RCDP.Confirmation_Number = RDP.Confirmation_Number 
  	    AND	RCDP.Collected_On= RDP.Collected_On 
		 And  RCDP.sequence =RDP.sequence
INNER JOIN Credit_Card CC
	On RCDP.Credit_Card_Key = CC.Credit_Card_Key
LEFT JOIN  	Credit_Card_Type CCT
	On CC.Credit_Card_Type_Id = CCT.Credit_Card_Type_ID
		
		
	
--
--	FROM	Credit_Card_Type CCT,
--		Credit_Card CC,
--		Reservation_CC_Dep_Payment RCDP,
--		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = @iConfirmNum
--	AND	RDP.Confirmation_Number = RCDP.Confirmation_Number
--	AND	RDP.Collected_On = RCDP.Collected_On
--	and rdp.sequence=rcdp.sequence
--	AND	RCDP.Credit_Card_Key = CC.Credit_Card_Key
--	AND	CC.Credit_Card_Type_Id *= CCT.Credit_Card_Type_ID

	UNION ALL

	SELECT	RDP.Payment_Type,
		LT.Value AS Payment_Type,
		RDP.Collected_On,
		RDP.Amount,
		RCDP.Terminal_ID,
		RCDP.Identification_Number,
		'',
		CASE
			WHEN RDP.Amount < 0 THEN 'Return'
			ELSE 'Purchase'
		END as Transaction_Type,
		RCDP.Authorization_Number,
		RCDP.Trx_Remarks,
		RCDP.Trx_Receipt_Ref_Num,
		RCDP.Trx_ISO_Response_Code,
		CASE
			-- suppress M/S if not processed via Eigen; if no terminal id, 
			-- then the CC transaction was not processed via Eigen
			WHEN RCDP.Terminal_Id IS NULL THEN ''  
			WHEN RCDP.Swiped_Flag = 0 THEN 'M'
			WHEN RCDP.Swiped_Flag = 1 THEN 'S'
			ELSE ''	-- default
		END,  
		Convert(Char(5), RCDP.Currency_Id),
		Convert(Char(10), RCDP.Exchange_Rate),
		Convert(Char(10), RCDP.Foreign_Currency_Amt_Collected),
		RDP.Collected_At_Location_ID,
		Convert(Char(1), RDP.Forfeited)
	FROM	Reservation_Cash_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP,
		Lookup_Table LT
	WHERE	RDP.Confirmation_Number = @iConfirmNum
	AND	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	and rdp.sequence=rcdp.sequence
	AND	RCDP.Cash_Payment_Type = LT.Code
	AND	LT.Category IN ('Cash Payment Method','Cash Refund Method')

	ORDER BY 3, 1

	RETURN @@ROWCOUNT
GO
