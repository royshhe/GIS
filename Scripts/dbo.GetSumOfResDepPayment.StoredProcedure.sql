USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSumOfResDepPayment]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetSumOfResDepPayment    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetSumOfResDepPayment    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSumOfResDepPayment    Script Date: 1/11/99 1:03:17 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetSumOfResDepPayment] --'1544761'
	@ConfirmationNumber Varchar(10)
AS
	DECLARE	@nConfirmationNumber Integer
	SELECT	@nConfirmationNumber = CONVERT(Int, NULLIF(@ConfirmationNumber, ''))

	SELECT	Sum(Amount)
	FROM	Reservation_Dep_Payment
	WHERE	Confirmation_Number = @nConfirmationNumber
	AND	Amount > 0
	AND	Forfeited = 0
	AND	Refunded = 0
	RETURN @@ROWCOUNT














GO
