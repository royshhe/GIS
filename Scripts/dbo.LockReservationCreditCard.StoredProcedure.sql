USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationCreditCard]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Reservation and Credit Card for a confirmation number
AUTHOR: Niem Phan
DATE CREATED: Oct 13 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationCreditCard]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	reservation AS RES WITH(UPDLOCK)
	JOIN		credit_card AS CC WITH(UPDLOCK)
	ON		RES.guarantee_credit_card_key = CC.credit_card_key

	 WHERE	confirmation_number = @nConfirmNum






GO
