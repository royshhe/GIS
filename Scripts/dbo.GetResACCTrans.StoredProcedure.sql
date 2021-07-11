USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResACCTrans]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
PURPOSE: To return credit card transaction amount and the amount already has been refunded for the given contract..
MOD HISTORY:
Name    Date        Comments

*/
CREATE PROCEDURE [dbo].[GetResACCTrans] --29919, '4030000010001234'

	@ConfirmationNum varchar(20), @Credit_Card_number varchar(20)
AS
	/* 4/16/99 - cpy bug fix - apply nullif check on @RefundedContractNum */
	/* 9/27/99 - do type conversion outside of select */

SELECT     dbo.Reservation_Dep_Payment.Amount, dbo.Reservation_Dep_Payment.Refunded, dbo.Reservation_CC_Dep_Payment.Trx_Receipt_Ref_Num
FROM         dbo.Reservation_CC_Dep_Payment INNER JOIN
                      dbo.Reservation_Dep_Payment ON 
                      dbo.Reservation_CC_Dep_Payment.Confirmation_Number = dbo.Reservation_Dep_Payment.Confirmation_Number AND 
                      dbo.Reservation_CC_Dep_Payment.Collected_On = dbo.Reservation_Dep_Payment.Collected_On
WHERE     (dbo.Reservation_Dep_Payment.Refunded = 0) and dbo.Reservation_Dep_Payment.Amount>0 and dbo.Reservation_Dep_Payment.Confirmation_Number=@ConfirmationNum
Return 1







GO
