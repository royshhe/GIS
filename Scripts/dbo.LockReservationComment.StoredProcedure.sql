USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockReservationComment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
PURPOSE: To lock the reservation comments for a reservation
AUTHOR: Cindy Yee
DATE CREATED: Oct 6 1999
CALLED BY: Reservation
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockReservationComment]
	@ConfirmNum varchar(11)
AS
	DECLARE @nConfirmNum integer
	SELECT  @nConfirmNum = CAST(NULLIF(@ConfirmNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	reservation_comment WITH(UPDLOCK)
	 WHERE	confirmation_number = @nConfirmNum







GO
