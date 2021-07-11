USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationCashDepPayment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Reservation Cash Dep Payment for a contract
AUTHOR: Niem Phan
DATE CREATED: Oct 6 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationCashDepPayment]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Reservation_Cash_Dep_Payment WITH(UPDLOCK)
	 WHERE	confirmation_number = @nConfirmNum






GO
