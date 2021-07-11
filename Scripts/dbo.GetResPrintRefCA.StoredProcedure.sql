USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResPrintRefCA]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE PROCEDURE [dbo].[GetResPrintRefCA]
	@ConfirmNum Varchar(10)
AS
DECLARE @iConfirmNum  Int

	/* 8/16/99 - return reservation total cash refund amount */

	SELECT 	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	SELECT	SUM(RDP.Amount) * -1
	FROM	Reservation_Cash_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = @iConfirmNum
	AND	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	AND	RCDP.Cash_Payment_Type = '-2'	-- 'Direct Refund'
	AND	RDP.Amount < 0
	AND	RDP.Payment_Type = 'Cash'

	RETURN @@ROWCOUNT











GO
