USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationDepPayment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the deposit payments for a reservation
AUTHOR: Don Kirkby
DATE CREATED: Oct 3 1999
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationDepPayment]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	reservation_dep_payment WITH(UPDLOCK)
	 WHERE	confirmation_number = @nConfirmNum







GO
