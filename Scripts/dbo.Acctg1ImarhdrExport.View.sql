USE [GISData]
GO
/****** Object:  View [dbo].[Acctg1ImarhdrExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: Acctg1ImarhdrExport
PURPOSE: To format the daily AR header for export to platinum.
AUTHOR: Don Kirkby
DATE CREATED: Jan 6, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Mar 22 1999 Added sales_accessory_sale_contract
Don K	Apr 23 1999 Exclude the current RBR date.
Don K	Apr 28 1999 Set values for rate_type_home, rate_type_oper, 
			and nat_cur_code
Don K	May 6 1999  Set date_shipped for reservations.
Don K	Nov 2 1999  exclude old rbr dates with export_failed flag set.
*/
CREATE VIEW [dbo].[Acctg1ImarhdrExport]
AS
SELECT	'BUDGET' company_code,
	' ' process_ctrl_num,
	'GIS'+CONVERT(varchar, ar.ar_export_id) source_ctrl_num,
	' ' order_ctrl_num,
	' ' trx_ctrl_num,
	CASE 
	WHEN summary_level in ('L', 'C') THEN
		' '
	WHEN ar.confirmation_number IS NOT NULL THEN
		resv.last_name + ', ' + resv.first_name
	WHEN ar.sales_contract_number IS NOT NULL THEN
		sasc.last_name + ', ' + sasc.first_name
	ELSE
		ctrct.last_name + ', ' + ctrct.first_name
	END doc_desc,
	CASE
	WHEN ar.summary_level = 'D' THEN
		ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +
			RIGHT(CONVERT(varchar, 
			ar.doc_ctrl_num_seq + 1000), 3)
	ELSE /* L or C */
		SUBSTRING(ar.doc_ctrl_num_base + SPACE(8), 1, 9) +
			RIGHT(CONVERT(varchar, 
			ar.doc_ctrl_num_seq + 10000000), 7)
	END doc_ctrl_num,
	ISNULL(apply_to_doc_ctrl_num, ' ') apply_to_num,
	CASE
	WHEN ar.apply_to_doc_ctrl_num IS NULL THEN
		' '
	ELSE
		'2031' /* Assume the original is always an invoice */
	END apply_trx_type,
	CASE
	WHEN ar.amount >= 0 THEN
		2031
	ELSE
		2032
	END trx_type,
	CONVERT(varchar, ar.rbr_date, 101) date_applied,
	CONVERT(varchar, ar.rbr_date, 101) date_doc,
	CASE
	WHEN ar.summary_level IN ('L', 'C') THEN
		CONVERT(varchar, ar.rbr_date, 101) 
	ELSE
		COALESCE(
			CONVERT(varchar, ctrct.pick_up_on, 101), 
			CONVERT(varchar, sasc.sales_date_time, 101), 
			CONVERT(varchar, resv.pick_up_on, 101), 
			' '
			)
	END date_shipped,
	' ' date_due,
	ar.customer_account customer_code,
	' ' ship_to_code,
	' ' salesperson_code,
	CASE
	WHEN ar.summary_level = 'D' THEN
		COALESCE(
			cloc.platinum_territory_code,
			rloc.platinum_territory_code,
			sloc.platinum_territory_code,
			' '
			)
	ELSE
		ISNULL(iloc.platinum_territory_code, ' ')
	END territory_code,
	' ' comment_code,
	' ' posting_code,
	' ' terms_code,
	CASE
	WHEN ar.credit_card_key IS NOT NULL THEN
		CASE cct.electronic_authorization
		WHEN 1 THEN
			' ' /* major credit card */
		ELSE
			cc.credit_card_number
		END
	WHEN ar.purchase_order_number IS NOT NULL THEN
		ar.purchase_order_number
	WHEN ar.loss_of_use_claim_number IS NOT NULL THEN
		SUBSTRING(ar.loss_of_use_claim_number + '/' + ar.adjuster_first_name + ' ' + ar.adjuster_last_name, 1, 20)
	ELSE
		' '
	END cust_po_num,
	' ' hold_flag,
	' ' hold_desc,
	' ' recurring_flag,
	' ' recurring_code,
	' ' tax_code,
	'CAD' nat_cur_code,
	'BUY' rate_type_home,
	'BUY' rate_type_oper,
	1 rate_home,
	1 rate_oper,
	' ' prepay_discount,
	0 prepay_amt,
	' ' prepay_doc_num,
	0 processed_flag,
	' ' date_processed
  FROM	ar_export ar
  JOIN	rbr_date rbr 
    ON	rbr.rbr_date = ar.rbr_date
  LEFT
  JOIN		contract ctrct 
	  JOIN	location cloc 
	    ON	ctrct.pick_up_location_id = cloc.location_id
    ON	ar.contract_number = ctrct.contract_number
  LEFT
  JOIN		reservation resv
	  JOIN	location rloc 
	    ON	resv.pick_up_location_id = rloc.location_id
    ON	ar.confirmation_number = resv.confirmation_number
  LEFT
  JOIN		sales_accessory_sale_contract sasc
	  JOIN	location sloc
	    ON	sasc.sold_at_location_id = sloc.location_id
    ON	ar.sales_contract_number = sasc.sales_contract_number
  LEFT
  JOIN		credit_card cc
	  JOIN	credit_card_type cct 
	    ON	cc.credit_card_type_id = cct.credit_card_type_id
    ON	ar.credit_card_key = cc.credit_card_key
  LEFT
  JOIN	location iloc 
    ON	ar.location_id = iloc.location_id
 WHERE	rbr.date_ar_generated IS NULL
   AND	rbr.budget_close_datetime IS NOT NULL
   AND	rbr.export_failed = 0







GO
