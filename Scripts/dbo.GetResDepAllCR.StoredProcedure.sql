USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepAllCR]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetResDepAllCR] -- 1544903
	@ConfirmNum	VarChar(10)
AS
	/* 6/16/99 - copied from GetResDepCR; only difference is that all records
			records are returned */
	/* 10/13/99 - do type conversion and nullif outside of SQL statement */

DECLARE	@iConfirmNum Int

	SELECT	@iConfirmNum = CONVERT(Int, NULLIF(@ConfirmNum,''))
	-- note: if forfeit flag AND refund flag are both turned on at
	-- 	 the same time, record is listed as "Forfeit"
	SELECT	'Transaction_Type' =
			Case
				WHEN RDP.Forfeited = 1 THEN
					'Forfeit'
				When RDP.Amount < 0 Then
					'Refund'
				WHEN RDP.Amount >= 0 Then
					'Deposit'
			End,
		RDP.Collected_At_Location_ID,
		CC.Credit_Card_Type_ID,
		CC.Credit_Card_Number,
		CC.Short_Token,
		CC.Last_Name,
		CC.First_Name,
		CC.Expiry,
		ABS(RDP.Amount),
		RCDP.Trx_Receipt_Ref_Num,
		RCDP.Authorization_Number,
		Convert(Char(1),RCDP.Swiped_Flag),
		Terminal_ID,
		RDP.Collected_By,
		CONVERT(VarChar, RDP.Collected_On, 111) Collected_On,
		CC.Customer_ID,                
       		RCDP.Trx_ISO_Response_Code, 
		RCDP.Trx_Remarks,
		Convert(char(1),RDP.Forfeited),
		Convert(char(1),rdp.refunded)

	FROM	Credit_Card CC,
		Reservation_CC_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	and rdp.sequence=rcdp.sequence
	AND	RCDP.Credit_Card_Key = CC.Credit_Card_Key
	AND 	RCDP.Confirmation_Number = @iConfirmNum
	ORDER BY RDP.Collected_On

	RETURN @@ROWCOUNT
GO
