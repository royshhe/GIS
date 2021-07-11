USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationChangeHistory]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the change history for a reservation
AUTHOR: Don Kirkby
DATE CREATED: Oct 3 1999
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationChangeHistory]
	@ConfirmNum varchar(11)
AS

	DECLARE @nConfirmNum integer
	SELECT @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	reservation_change_history WITH(UPDLOCK)
	 WHERE	confirmation_number = @nConfirmNum







GO
