USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepCA]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetResDepCA    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepCA    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepCA    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepCA    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResDepCA]
	@ConfirmNum	Varchar(10)
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
DECLARE @iConfirmNum Int

	SELECT @iConfirmNum = CONVERT(Int, NULLIF(@ConfirmNum,''))

	SELECT	'Transaction_Type' =
			Case
				When RDP.Amount < 0 Then
					'Refund'
				Else
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
		Convert(Char(1),RCDP.Swiped_Flag),
		RCDP.Terminal_ID,
		RDP.Collected_By,
		RDP.Collected_On,
		RCDP.Trx_ISO_Response_Code,
		RCDP.Trx_Remarks,
		'1'  As ResDeposit
	FROM	Reservation_Cash_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	and rdp.sequence=rcdp.sequence
	AND	RDP.Confirmation_Number = @iConfirmNum
	AND	RDP.Forfeited = 0
	AND	RDP.Refunded = 0
	AND	RDP.Amount >= 0
	RETURN @@ROWCOUNT

GO
