USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdResDepPaymentForfeited]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdResDepPaymentForfeited    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdResDepPaymentForfeited    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdResDepPaymentForfeited    Script Date: 1/11/99 1:03:17 PM ******/
/*
PURPOSE: To update a record in Reservation_Dep_Payment table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 26 - Moved the data conversion out of the where clause */
CREATE PROCEDURE [dbo].[UpdResDepPaymentForfeited]
	@ConfirmationNumber	Varchar(10)
AS
	Declare @nConfirmationNumber Integer

	Select	@nConfirmationNumber = CONVERT(Integer, NULLIF(@ConfirmationNumber, ''))

	UPDATE	Reservation_Dep_Payment
	
	SET	Forfeited = CONVERT(Bit, 1)
	
	WHERE	Confirmation_Number = @nConfirmationNumber
	AND	Amount > 0
	AND	Forfeited = 0
	AND	Refunded = 0
	
RETURN @@ROWCOUNT














GO
