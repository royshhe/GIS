USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateAcctgAR]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
PURPOSE: To summarize the AR_Transaction table into the AR_Export
        table for an RBR date and set the invoice flags.
REQUIRES: CreateAcctgBT has already been called for this RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Jan 6, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K   Jan 11 1999 Accommodated table changes.
Don K   Jan 29 1999 Used new doc_ctrl_num strategy.
Don K   Mar 22 1999 Added sales_contract_number
Don K   May 5 1999  Make Invoice/Adjustment distinction based on contract AND
                        account
Don K   Aug 3 1999  Use business_transaction_export table.
Don K   Oct 25 1999 Don't populate count_charges and count_credits. They're not used.
Don K	Nov 16 1999 Fixed bug in sequence number generation.
Don K	Mar 17 2000 Use transaction date to determine invoice and adjustments.
Don K	Apr 14 2000 Split into CreateAcctgAR1 and CreateAcctgAR2
Don K	May 2 2000  Put back together into CreateAcctgAR
*/
CREATE PROCEDURE [dbo].[CreateAcctgAR]
        @RBRDate varchar(24)
AS
        DECLARE @dRBRDate datetime
        SELECT  @dRBRDate = CONVERT(datetime, NULLIF(@RBRDate, ''))
/* Insert records into ar_export table */
        /* Do detail accounts first */


DECLARE @RowFound Int
SELECT @RowFound = (
	SELECT
		COUNT(*)
	FROM
		ar_export
	WHERE	rbr_date = @dRBRDate)		 
IF @RowFound <=0
  BEGIN	        
        INSERT
          INTO  ar_export
                (
                rbr_date,
                customer_account,
                amount,
                contract_number,
                purchase_order_number,
                loss_of_use_claim_number,
                adjuster_first_name,
                adjuster_last_name,
                credit_card_key,
                location_id,
                authorization_number,
                confirmation_number,
                sales_contract_number,
                transaction_date,
                summary_level,
                ticket_number,
                issuing_jurisdiction,
                budget_claim_number,
                doc_ctrl_num_base,
                doc_ctrl_num_type,
                ITB_BU_ID
                )
        SELECT  @dRBRDate,
                ar.customer_account,
                ar.amount,
                bt.contract_number,
                ar.purchase_order_number,
                ar.loss_of_use_claim_number,
                ar.adjuster_first_name,
                ar.adjuster_last_name,
                ar.credit_card_key,
                bt.location_id,
                ar.authorization_number,
                bt.confirmation_number,
                bt.sales_contract_number,
                bt.transaction_date,
                'D',
                ar.ticket_number,
                ar.issuing_jurisdiction,
                ar.budget_claim_number,
                CASE
                WHEN    bt.contract_number IS NOT NULL THEN
                        /* ar trx applies to a contract */
                        /* we're padding left with zeroes. */
                        'C' + RIGHT(CONVERT(varchar,
                                bt.contract_number + 10000000000), 10)
                                +
                                CASE
                                WHEN ctrct.foreign_contract_number IS NOT NULL THEN
                                        'F'
                                WHEN dbpb.issue_interim_bills = 1 THEN
                                        'M'
                                ELSE
                                        'C'
                                END
                WHEN    bt.confirmation_number IS NOT NULL THEN
                        /* ar trx applies to a reservation */
                        /* we're padding left with zeroes. */
                        'R' + RIGHT(CONVERT(varchar,
                                bt.confirmation_number + 10000000000), 10)
                                + 'R'
                ELSE    --bt.sales_contract_number IS NOT NULL
                        /* ar trx applies to a sales contract */
                        /* we're padding left with zeroes. */
                        'S' + RIGHT(CONVERT(varchar,
                                bt.sales_contract_number + 10000000000), 10)
                                + 'S'
                END doc_ctrl_num_base,
                CASE WHEN ar.must_be_invoice = 1 THEN
                        'I'
                ELSE
                        NULL
                END doc_ctrl_num_type,
                 bt.business_transaction_id
          FROM  ar_transactions ar
          JOIN  business_transaction bt
            ON  ar.business_transaction_id = bt.business_transaction_id
          JOIN  business_transaction_export bte
            ON  bt.business_transaction_id = bte.business_transaction_id
           AND  bt.rbr_date = bte.rbr_date
          LEFT
          JOIN  contract ctrct
            ON  ctrct.contract_number = bt.contract_number
          LEFT
          JOIN  direct_bill_primary_billing dbpb
            ON  dbpb.contract_number = ctrct.contract_number
           AND  dbpb.contract_billing_party_id = -1
         WHERE  bt.rbr_date = @dRBRDate
                /* this includes accounts with a summary level D or no
                 * matching record in ar_credit_authorization.
                 */
           AND  ar.customer_account NOT IN
                (
                SELECT  customer_code
                  FROM  ar_credit_authorization
                 WHERE  summary_level != 'D'
                )
			order by bt.transaction_date
        /* Do location summary accounts next
         * These should all be credit card accounts.
         */
        INSERT
          INTO  ar_export
                (
                rbr_date,
                customer_account,
                amount,
                location_id,
                summary_level,
                doc_ctrl_num_base,
                doc_ctrl_num_type
                )
        SELECT  @dRBRDate,
                ar.customer_account,
                SUM(ar.amount),
                bt.location_id,
                'L' summary_level,

                'X' + ar.customer_account doc_ctrl_num_base,
                'I' doc_ctrl_num_type
          FROM  ar_transactions ar,
                business_transaction bt,
                business_transaction_export bte,
                ar_credit_authorization aca
         WHERE  ar.business_transaction_id = bt.business_transaction_id
           AND  bt.rbr_date = @dRBRDate
           AND  bt.business_transaction_id = bte.business_transaction_id
           AND  bt.rbr_date = bte.rbr_date
           AND  aca.customer_code = ar.customer_account
           AND  aca.summary_level = 'L' /* Location */

         GROUP
            BY  ar.customer_account, bt.location_id
        /* Do company summary accounts last
         * These should all be debit card accounts.
         */
        INSERT
          INTO  ar_export
                (
                rbr_date,
                customer_account,
                amount,
                summary_level,
                doc_ctrl_num_base,
                doc_ctrl_num_type
                )
        SELECT  @dRBRDate,
                ar.customer_account,
                SUM(ar.amount),
                'C' summary_level,
                'D' + ar.customer_account doc_ctrl_num_base,
                'I' doc_ctrl_num_type
          FROM  ar_transactions ar,
                business_transaction bt,
                business_transaction_export bte,
                ar_credit_authorization aca
         WHERE  ar.business_transaction_id = bt.business_transaction_id
           AND  bt.rbr_date = @dRBRDate
           AND  bt.business_transaction_id = bte.business_transaction_id
           AND  bt.rbr_date = bte.rbr_date
           AND  aca.customer_code = ar.customer_account
           AND  aca.summary_level = 'C' /* Company */
         GROUP
            BY  ar.customer_account

/* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  ar_export
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	transaction_date = 
		(
		SELECT	MIN(ar2.transaction_date)
		  FROM	ar_export ar2
		 WHERE	ar2.doc_ctrl_num_base = ar_export.doc_ctrl_num_base
		   AND	ar2.customer_account = ar_export.customer_account
		)
	   AND	ar_export_id =
		(
		SELECT	MIN(ar3.ar_export_id)
		  FROM	ar_export ar3
		 WHERE	ar3.doc_ctrl_num_base = ar_export.doc_ctrl_num_base
		   AND	ar3.customer_account = ar_export.customer_account
		   AND	ar3.transaction_date = ar_export.transaction_date
		)
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	ar_export arExists
		 WHERE	arExists.doc_ctrl_num_type = 'I'
		   AND	arExists.doc_ctrl_num_base = ar_export.doc_ctrl_num_base
		   AND	arExists.customer_account = ar_export.customer_account
		)

        /* set remaining transactions to be adjustments */
        UPDATE  ar_export
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 * fixed the sequence numbers for Interim billing due to the base code changed from II to MI	Peter 2014/01/28
 */
	UPDATE	ar_export
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	ar_export ar2
			 WHERE	(ar2.doc_ctrl_num_base =	ar_export.doc_ctrl_num_base
						 or left(ar2.doc_ctrl_num_base,11) =left(ar_export.doc_ctrl_num_base,11) 
								and right(ar_export.doc_ctrl_num_base,1)='M')
			   AND	ar2.doc_ctrl_num_type =	ar_export.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	ar_export ar3
			 WHERE	ar3.doc_ctrl_num_seq IS	NULL
			   AND	ar3.doc_ctrl_num_base =	ar_export.doc_ctrl_num_base
			   AND	ar3.doc_ctrl_num_type =	ar_export.doc_ctrl_num_type
			   AND	ar3.ar_export_id < ar_export.ar_export_id
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  ar_export
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  ar_export.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(ar2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  ar_export ar2
                         WHERE  ar2.doc_ctrl_num_base =
                                  ar_export.doc_ctrl_num_base
                           AND  ar2.customer_account = ar_export.customer_account

                           AND  ar2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL


  END



GO
