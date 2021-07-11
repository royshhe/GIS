USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidateRefund]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ValidateRefund    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRefund    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRefund    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidateRefund    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To return the amount and the amount already has been refunded for the given contract..
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[ValidateRefund]
@RefundedContractNum varchar(20)
AS
	/* 4/16/99 - cpy bug fix - apply nullif check on @RefundedContractNum */
	/* 9/27/99 - do type conversion outside of select */

Declare @AlreadyRefunded decimal(9,2),
	@iRefundedCtrctNum Int

SELECT @iRefundedCtrctNum = Convert(int, NULLIF(@RefundedContractNum,''))

Select @AlreadyRefunded =
	(Select
		SUM(SASP.Amount)
	From
		Sales_Accessory_Sale_Payment SASP,
		Sales_Accessory_Sale_Contract SASC
	Where
		SASC.Refunded_Contract_No = @iRefundedCtrctNum
		And SASC.Sales_Contract_Number = SASP.Sales_Contract_Number)
Select
	Amount, @AlreadyRefunded
From
	Sales_Accessory_Sale_Payment
Where
	Sales_Contract_Number = @iRefundedCtrctNum
Return 1















GO
