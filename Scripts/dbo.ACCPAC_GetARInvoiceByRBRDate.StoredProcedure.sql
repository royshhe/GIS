USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ACCPAC_GetARInvoiceByRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
Procedure NAME: ACCPAC_GetARInvoiceByRBRDate
PURPOSE: To format the daily AR for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 6, 2005
CALLED BY: Accounting
MOD HISTORY:

*/
CREATE PROCEDURE [dbo].[ACCPAC_GetARInvoiceByRBRDate] --'29 Jun 2017', '29 Jun 2017'
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramAdjustment bit =0
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@GLReceivablesClearAcct varchar(50)

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT    @GLReceivablesClearAcct=GL_Receivables_Clear_Acct
FROM         System_Values

SELECT 
	
	30 as CNTBTCH,
	1 as CNTITEM,
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
		WHEN ar.apply_to_doc_ctrl_num IS NULL THEN 
			CASE
				WHEN ar.amount >= 0 THEN
				1
				ELSE
				3
			END
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
				isnull(cc.credit_card_number,'')
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

	CONVERT(varchar, ar.rbr_date, 101) DATEASOF,
	1 AS SWMANTX,

        -- Invoice Detail
        20 as CNTLINE,	
	ISNULL(ar.authorization_number, '') TEXTDESC,
	abs(ar.amount) AMTEXTN,
	@GLReceivablesClearAcct as IDACCTREV,
	1 as CNTPAYM
	
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

WHERE	(ar.RBR_Date BETWEEN @startDate AND @endDate)
	and ( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 

--rbr.date_ar_generated IS NULL
--   AND	rbr.budget_close_datetime IS NOT NULL
--   AND	rbr.export_failed = 0
GO
