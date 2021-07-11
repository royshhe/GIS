USE [GISData]
GO
/****** Object:  View [dbo].[ACCPAC_imarhdrExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: ACCPAC_imarhdrExport
PURPOSE: To format the daily AR header for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 6, 2005
CALLED BY: Accounting
MOD HISTORY:

*/
CREATE View [dbo].[ACCPAC_imarhdrExport]
as	

SELECT	
	--30 as CNTBTCH,
	--1 AS CNTITEM,
	ar.customer_account IDCUST,	
	CASE
		WHEN ar.summary_level = 'D' THEN
			ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +
				RIGHT(CONVERT(varchar, 
				ar.doc_ctrl_num_seq + 1000), 3)
		ELSE /* L or C */
			SUBSTRING(ar.doc_ctrl_num_base + SPACE(8), 1, 9) +
				RIGHT(CONVERT(varchar, 
				ar.doc_ctrl_num_seq + 10000000), 7)
	END IDINVC,
	CASE
		WHEN ar.apply_to_doc_ctrl_num IS NULL THEN 1
		ELSE
			CASE
				WHEN ar.amount >= 0 THEN
				2
				ELSE
				3
			END
	END TEXTTRX,         -- document type	

	CASE
		WHEN ar.credit_card_key IS NOT NULL THEN
			CASE cct.electronic_authorization
			WHEN 1 THEN
				'' /* major credit card */
			ELSE
				cc.credit_card_number
			END
		WHEN ar.purchase_order_number IS NOT NULL THEN
			ar.purchase_order_number
		WHEN ar.loss_of_use_claim_number IS NOT NULL THEN
			SUBSTRING(ar.loss_of_use_claim_number + '/' + ar.adjuster_first_name + ' ' + ar.adjuster_last_name, 1, 20)
		ELSE
		''
	END CUSTPO,
	
	CASE 
		WHEN summary_level in ('L', 'C') THEN
			''
		WHEN ar.confirmation_number IS NOT NULL THEN
			resv.last_name + ', ' + resv.first_name
		WHEN ar.sales_contract_number IS NOT NULL THEN
			sasc.last_name + ', ' + sasc.first_name
		ELSE
			ctrct.last_name + ', ' + ctrct.first_name
	END INVCDESC,
	
	ISNULL(apply_to_doc_ctrl_num, '') INVCAPPLTO,
	
	CONVERT(varchar, ar.rbr_date, 101) DATEINVC, 
	1 AS SWMANTX 
	
	
	
	
	
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
-- WHERE	AR_Export.RBR_Date BETWEEN @startDate AND @endDate

--rbr.date_ar_generated IS NULL
--   AND	rbr.budget_close_datetime IS NOT NULL
--   AND	rbr.export_failed = 0

GO
