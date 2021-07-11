USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRefundFlag]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
create PROCEDURE [dbo].[UpdateRefundFlag]
	@ContractNumber	Varchar(12),
	@CreditCardNumber varchar(20)
AS
	Declare @nContractNumber Integer

	Select	@nContractNumber = CONVERT(Integer, NULLIF(@ContractNumber, ''))

	UPDATE	Refund_history
	
	SET	status = CONVERT(Bit, 1)
	
	WHERE	Contract_Number = @nContractNumber
		and Credit_Card_Number=@CreditCardNumber
	
RETURN @@ROWCOUNT
















GO
