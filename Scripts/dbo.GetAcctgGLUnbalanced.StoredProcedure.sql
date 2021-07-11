USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAcctgGLUnbalanced]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetAcctgGLUnbalanced
PURPOSE: To retrieve any unbalanced GL transactions
REQUIRES: CreateAcctgBT has already been called for this RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Jun 21 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Aug 3 1999  Use business_transaction_export table.
*/
CREATE PROCEDURE [dbo].[GetAcctgGLUnbalanced]
	@RBRDate varchar(24)
AS
DECLARE	@dRBRDate datetime
SELECT	@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate, ''))
	SELECT	CAST(bt.business_transaction_id AS varchar) + ' for ' +
		  CASE WHEN bt.contract_number IS NOT NULL THEN
			'Contract ' + CAST(bt.contract_number AS varchar)
		  WHEN bt.confirmation_number IS NOT NULL THEN
			'Reservation ' + CAST(bt.confirmation_number AS varchar)
		  WHEN bt.sales_contract_number IS NOT NULL THEN
			'Sales Contract ' + CAST(bt.sales_contract_number AS varchar)
		  END,
		bt.transaction_date,
		bt.transaction_description
	  FROM	business_transaction bt
	 WHERE	bt.rbr_date = @dRBRDate
	   AND	bt.business_transaction_id NOT IN
		(
		SELECT	bte.business_transaction_id
		  FROM	business_transaction_export bte
		 WHERE	bte.rbr_date = @dRBRDate
		)
	 ORDER
	    BY	bt.business_transaction_id















GO
