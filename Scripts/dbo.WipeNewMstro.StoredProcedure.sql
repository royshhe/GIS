USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[WipeNewMstro]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.WipeNewMstro    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.WipeNewMstro    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.WipeNewMstro    Script Date: 1/11/99 1:03:18 PM ******/
/*
PROCEDURE NAME: WipeNewMstro
PURPOSE: To delete maestro reservations and related records
AUTHOR: Don Kirkby
DATE CREATED: Sep 25, 1998
CALLED BY: Testing only
REQUIRES:
ENSURES:
MOD HISTORY:
Name    Date        Comments
Don K	Dec 9 1998  Just delete reservations newer than Dec 1
Don K	Feb 26 1999 Take all transaction dates and don't drop Customer/Credit Card/FreqFlyer
			Also exclude reservations that are referred to by contracts.
*/
CREATE PROCEDURE [dbo].[WipeNewMstro]
AS
	DECLARE @cntRows int
	SELECT	resv.confirmation_number,
		resv.quoted_rate_id,
		resv.customer_id,
		resv.guarantee_credit_card_key,
		mstro.maestro_id,
		bel.batch_start_date
	  INTO	#resv
	  FROM	maestro mstro
		LEFT JOIN 	reservation resv
		ON mstro.confirmation_number= resv.confirmation_number 
		LEFT JOIN 		batch_error_log bel
		ON 	 mstro.maestro_id =bel.maestro_id
--	 WHERE	resv.confirmation_number =* mstro.confirmation_number
--	   AND	bel.maestro_id =* mstro.maestro_id
--	   AND	mstro.transaction_date > 'dec 1 1998'
/* If we don't have a complete maestro table, use the following instead:
        SELECT  resv.confirmation_number,
                resv.quoted_rate_id,
                resv.customer_id,
                resv.guarantee_credit_card_key
          INTO  #resv
          FROM  reservation resv
         WHERE  source_code = 'Maestro'
*/
-- Delete everything from these two tables
	DELETE
	  FROM	batch_error_log
	 WHERE	batch_start_date IN (SELECT batch_start_date FROM #resv)
	SELECT	@cntRows = @@ROWCOUNT
	DELETE
	  FROM	maestro
	  FROM	#resv
	 WHERE	maestro.maestro_id = #resv.maestro_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT

-- Now exclude any reservations that have become contracts.
	DELETE
	  FROM	#resv
	  FROM	contract ctrct
	 WHERE	ctrct.confirmation_number = #resv.confirmation_number

	DELETE
	  FROM	reserved_rental_accessory
	  FROM	#resv
	 WHERE	#resv.confirmation_number
			= reserved_rental_accessory.confirmation_number
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
        DELETE
          FROM  reserved_sales_accessory
          FROM  #resv
         WHERE  #resv.confirmation_number
                        = reserved_sales_accessory.confirmation_number
        SELECT  @cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reservation_comment
	  FROM	#resv
	 WHERE	#resv.confirmation_number = reservation_comment.confirmation_number
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	reservation_change_history
	  FROM	#resv
	 WHERE	#resv.confirmation_number = reservation_change_history.confirmation_number
	SELECT	@cntRows = @cntRows + @@ROWCOUNT

        DELETE
          FROM  reservation_dep_payment
          FROM  #resv
         WHERE  #resv.confirmation_number = reservation_dep_payment.confirmation_number
        SELECT  @cntRows = @cntRows + @@ROWCOUNT

        DELETE
          FROM  ar_transactions
          FROM  #resv, business_transaction bt
         WHERE  #resv.confirmation_number = bt.confirmation_number
           AND  ar_transactions.business_transaction_id = bt.business_transaction_id
        SELECT  @cntRows = @cntRows + @@ROWCOUNT
        DELETE
          FROM  ar_export
          FROM  #resv
         WHERE  #resv.confirmation_number = ar_export.confirmation_number
        SELECT  @cntRows = @cntRows + @@ROWCOUNT
        DELETE
          FROM  business_transaction
          FROM  #resv
         WHERE  #resv.confirmation_number = business_transaction.confirmation_number
        SELECT  @cntRows = @cntRows + @@ROWCOUNT
        DELETE
          FROM  tarp_export
          FROM  #resv
         WHERE  #resv.confirmation_number = tarp_export.confirmation_number
        SELECT  @cntRows = @cntRows + @@ROWCOUNT

        DELETE
          FROM  business_transaction

          FROM  #resv
         WHERE  #resv.confirmation_number = business_transaction.confirmation_number

	DELETE
	  FROM	reservation
	  FROM	#resv
	 WHERE	reservation.confirmation_number = #resv.confirmation_number
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_rate_category
	  FROM	#resv
	 WHERE	#resv.quoted_rate_id = quoted_rate_category.quoted_rate_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_time_period_rate
	  FROM	#resv

	 WHERE	#resv.quoted_rate_id = quoted_time_period_rate.quoted_rate_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_rate_restriction
	  FROM	#resv
	 WHERE	#resv.quoted_rate_id = quoted_rate_restriction.quoted_rate_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_included_optional_extra
	  FROM	#resv
	 WHERE	#resv.quoted_rate_id = quoted_included_optional_extra.quoted_rate_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	quoted_vehicle_rate
	  FROM	#resv
	 WHERE	#resv.quoted_rate_id = quoted_vehicle_rate.quoted_rate_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT

/* For now, we're not going to delete these three tables.	
	DELETE
	  FROM	credit_card
	  FROM	#resv
	 WHERE	#resv.guarantee_credit_card_key = credit_card.credit_card_key
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	frequent_flyer_plan_member
	  FROM	#resv
	 WHERE	#resv.customer_id = frequent_flyer_plan_member.customer_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	DELETE
	  FROM	customer
	  FROM	#resv
	 WHERE	#resv.customer_id = customer.customer_id
	SELECT	@cntRows = @cntRows + @@ROWCOUNT
	SELECT	@cntRows
*/
GO
