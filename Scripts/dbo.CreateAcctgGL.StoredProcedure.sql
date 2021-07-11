USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateAcctgGL]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: CreateAcctgGL
PURPOSE: To summarize the Sales Journal for an RBR date
REQUIRES: CreateAcctgBT has already been called for this RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Dec 23, 1998
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Jan 5 1999  Changed from a retrieve to an insert
Don K	Apr 23 1999 Don't export twice for the same rbr date.
Don K	Jun 21 1999 Exclude unbalanced transactions
Don K	Aug 3 1999  Use business_transaction_export table
*/
CREATE PROCEDURE [dbo].[CreateAcctgGL]
	@RBRDate varchar(24)
AS
DECLARE	@dRBRDate datetime
SELECT	@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate, ''))

DECLARE @RowFound Int
SELECT @RowFound = (
	SELECT
		COUNT(*)
	FROM
		journal_voucher_account_detail
	WHERE	rbr_date = @dRBRDate)		 
IF @RowFound <=0
  BEGIN	  
	INSERT
	  INTO	journal_voucher_account_detail
		(
		rbr_date,
		gl_account,
		total_amount
		)
	SELECT	@dRBRDate,
		Replace(sj.gl_account,'-', '') as gl_account,
		SUM(sj.amount)
	  FROM	sales_journal sj
	  JOIN	business_transaction bt
	    ON	sj.business_transaction_id = bt.business_transaction_id
	  JOIN	business_transaction_export bte
	    ON	bt.business_transaction_id = bte.business_transaction_id
	   AND	bt.rbr_date = bte.rbr_date
	 WHERE	bte.rbr_date = @dRBRDate
	 GROUP
	    BY	sj.gl_account
  
  END
GO
