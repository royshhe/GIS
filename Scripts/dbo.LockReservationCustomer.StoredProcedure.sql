USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationCustomer]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the Reservation and Customer for a confirmation number
AUTHOR: Niem Phan
DATE CREATED: Oct 13 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationCustomer]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	reservation AS RES WITH(UPDLOCK)
	JOIN		customer AS CUS WITH(UPDLOCK)
	ON		RES.customer_id = CUS.customer_id

	 WHERE	confirmation_number = @nConfirmNum






GO
