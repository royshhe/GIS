USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateAcctgBT]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To retrieve the list of business transactions to summarize
AUTHOR: Don Kirkby
DATE CREATED: Aug 3 1999
CALLED BY: Accounting
ENSURES: business transaction ids are stored in the Business_transaction_Export
	table and any transactions with unbalanced GL entries are eliminated.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CreateAcctgBT]
	@RBRDate varchar(24)
AS
DECLARE	@dRBRDate datetime
SELECT	@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate, ''))


DECLARE @RowFound Int
SELECT @RowFound = (
	SELECT
		COUNT(*)
	FROM
		business_transaction_export
	WHERE	rbr_date = @dRBRDate)		 
IF @RowFound <=0
  BEGIN	
	INSERT
	  INTO	business_transaction_export
		(
		rbr_date,
		business_transaction_id
		)
	SELECT	rbr_date,
		business_transaction_id
	  FROM	business_transaction
	 WHERE	rbr_date = @dRBRDate

	DELETE
	  FROM	business_transaction_export
	 WHERE	rbr_date = @dRBRDate
	   AND	business_transaction_id IN
		(
		-- unbalanced GL transactions
		SELECT	sj.business_transaction_id
		  FROM	sales_journal sj
		  JOIN	business_transaction bt
		    ON	bt.business_transaction_id = sj.business_transaction_id
		 WHERE	bt.rbr_date = @dRBRDate
		 GROUP
		    BY	sj.business_transaction_id
		HAVING	SUM(sj.amount) != 0
		)

  END









GO
