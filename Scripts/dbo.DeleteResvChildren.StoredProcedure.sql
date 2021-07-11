USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteResvChildren]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteResvChildren    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResvChildren    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResvChildren    Script Date: 1/11/99 1:03:15 PM ******/
/*
PROCEDURE NAME: DeleteResvChildren
PURPOSE: To delete all child records of a Maestro Reservation.
AUTHOR: Don Kirkby
DATE CREATED: Dec 1, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: Child records have been dropped
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteResvChildren]
	@ConfirmNum	varchar(11)
AS
	DECLARE @nConfirmNum int,
		@nQRateId int
	SELECT	@nConfirmNum = CONVERT(int, NULLIF(@ConfirmNum, ''))
	SELECT	@nQRateId = (	SELECT quoted_rate_id
				  FROM reservation
				 WHERE confirmation_number = @nConfirmNum
			    )
	UPDATE	reservation
	   SET	quoted_rate_id = NULL
	 WHERE	confirmation_number = @nConfirmNum
	DELETE
	  FROM	quoted_rate_category
	 WHERE	quoted_rate_id = @nQRateId
	DELETE
	  FROM	quoted_time_period_rate
	 WHERE	quoted_rate_id = @nQRateId
	DELETE
	  FROM	quoted_rate_restriction
	 WHERE	quoted_rate_id = @nQRateId
	DELETE
	  FROM	quoted_included_optional_extra
	 WHERE	quoted_rate_id = @nQRateId
	DELETE
	  FROM	quoted_vehicle_rate
	 WHERE	quoted_rate_id = @nQRateId
	DELETE
	  FROM	Reserved_Rental_Accessory
	 WHERE	Confirmation_Number = @nConfirmNum
	DELETE	
	  FROM	Reservation_Comment
	 WHERE	Confirmation_Number = @nConfirmNum












GO
