USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepCR]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResDepCR    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepCR    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetResDepCR] --1549819
	@ConfirmNum	VarChar(10)
AS
	/* 981203 - cpy - modified to return latest outstanding amount,
			  ie. non-forfeited, non-refunded, positive amount
			  note: there should only be at most 1 outstanding
				amount, but if there is > 1, this sp only
				returns the most recent */
	/* 6/22/99 - added Trx columns */
	/* 10/13/99 - do type conversion and nullif outside of SQL statement */
DECLARE	@iConfirmNum Int

	SELECT	@iConfirmNum = CONVERT(Int, NULLIF(@ConfirmNum,''))

-- 	SET ROWCOUNT 1
	SELECT	'Transaction_Type' =
			Case
				When RDP.Amount < 0 Then
					'Refund'
				Else
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
		RDP.Collected_On,
		CC.Customer_ID,		
		RCDP.Trx_ISO_Response_Code,
		RCDP.Trx_Remarks,
		'1'  As ResDeposit
		
	FROM	Credit_Card CC,
		Reservation_CC_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	and rdp.sequence=rcdp.sequence
	AND	RCDP.Credit_Card_Key = CC.Credit_Card_Key
	AND 	RCDP.Confirmation_Number = @iConfirmNum
	AND	(RDP.Forfeited = 0 or RDP.Forfeited=1 and RDP.refunded=1)-- if Forfeited been refunded, neet to show on the contraft too.
	--AND	RDP.Refunded = 0
--	AND	RDP.Amount >= 0   --Missing refund entry if reservation retrieve on contract open. Peter/20110720
	ORDER BY RDP.Collected_On
	RETURN @@ROWCOUNT
GO
