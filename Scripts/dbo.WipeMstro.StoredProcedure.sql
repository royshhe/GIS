USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[WipeMstro]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.WipeMstro    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.WipeMstro    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.WipeMstro    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.WipeMstro    Script Date: 11/23/98 3:55:35 PM ******/
/*
PROCEDURE NAME: WipeMstro
PURPOSE: To delete all the maestro reservations and related records
AUTHOR: Don Kirkby
DATE CREATED: Sep 25, 1998
CALLED BY: Testing only
REQUIRES:
ENSURES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[WipeMstro]
AS
	DECLARE @cntRows int
	DELETE
	  FROM	batch_error_log
	SELECT	@cntRows = @@ROWCOUNT
	DELETE
	  FROM	maestro
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_rate_category
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_time_period_rate
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_rate_restriction
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_included_optional_extra
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_vehicle_rate
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	
	DELETE
	  FROM	credit_card
	  FROM	reservation res
	 WHERE	res.guarantee_credit_card_key = credit_card.credit_card_key
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	frequent_flyer_plan_member
	  FROM	reservation res
	 WHERE	res.customer_id = frequent_flyer_plan_member.customer_id
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	customer
	  FROM	reservation res
	 WHERE	res.customer_id = customer.customer_id
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reserved_rental_accessory
	  FROM	reservation res
	 WHERE	res.confirmation_number = reserved_rental_accessory.confirmation_number
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reservation_comment
	  FROM	reservation res
	 WHERE	res.confirmation_number = reservation_comment.confirmation_number
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reservation_change_history
	  FROM	reservation res
	 WHERE	res.confirmation_number = reservation_change_history.confirmation_number
	   AND	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reservation
	 WHERE	foreign_confirm_number IS NOT NULL
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	SELECT	@cntRows












GO
