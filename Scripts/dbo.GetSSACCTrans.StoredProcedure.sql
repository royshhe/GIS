USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSACCTrans]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
PURPOSE: To return credit card transaction amount and the amount already has been refunded for the given contract..
MOD HISTORY:
Name    Date        Comments

*/
CREATE PROCEDURE [dbo].[GetSSACCTrans] --29919, '4030000010001234'

	@ContractNum varchar(20), @Credit_Card_number varchar(20)
AS
	/* 4/16/99 - cpy bug fix - apply nullif check on @RefundedContractNum */
	/* 9/27/99 - do type conversion outside of select */

Declare @AlreadyRefunded decimal(9,2),
	@CtrctNum Int

SELECT @CtrctNum = Convert(int, NULLIF(@ContractNum,''))

Select @AlreadyRefunded =
	(Select
		SUM(SASP.Amount)
	From
		Sales_Accessory_Sale_Payment SASP,
		Sales_Accessory_Sale_Contract SASC
	Where
		SASC.Refunded_Contract_No = @CtrctNum
		And SASC.Sales_Contract_Number = SASP.Sales_Contract_Number)

SELECT      Amount,@AlreadyRefunded as AlreadyRefunded, Trx_Receipt_Ref_Num
FROM        dbo.Credit_Card_Transaction
Where
	Sales_Contract_Number = @CtrctNum and Credit_Card_Number=@Credit_Card_number and Void=0 and Amount>0
Return 1






GO
