USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepAllCA]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetResDepAllCA] -- 1465057
	@ConfirmNum	Varchar(10)
AS
	/* 6/15/99 - copied from GetResDepCA; only difference is that all records
			records are returned */
	/* 10/13/99 - do type conversion and nullif outside of SQL statement */
DECLARE @iConfirmNum Int

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
		RCDP.Cash_Payment_Type,
		RCDP.Foreign_Currency_Amt_Collected,
		RCDP.Currency_ID,
		RCDP.Exchange_Rate,
		ABS(RDP.Amount),
		RCDP.Identification_Number,
		RCDP.Trx_Receipt_Ref_Num,
		RCDP.Authorization_Number,
		isnull(Convert(Char(1),RCDP.Swiped_Flag),'0'),
		RCDP.Terminal_ID,
		RDP.Collected_By,
		RDP.Collected_On,
		RCDP.Trx_ISO_Response_Code,
		RCDP.Trx_Remarks
	FROM	Reservation_Cash_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	and rdp.sequence=rcdp.sequence
	AND	RDP.Confirmation_Number = @iConfirmNum

	RETURN @@ROWCOUNT

GO
