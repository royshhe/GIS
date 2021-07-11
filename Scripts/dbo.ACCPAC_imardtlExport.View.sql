USE [GISData]
GO
/****** Object:  View [dbo].[ACCPAC_imardtlExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: ACCPAC_imardtlExport
PURPOSE: To format the daily AR details from invoice for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 17, 2005
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE VIEW [dbo].[ACCPAC_imardtlExport]
AS
SELECT	30 as CNTBTCH,
	1 as CNTITEM,
	20 as CNTLINE,
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
	
	ISNULL(ar.authorization_number, '') TEXTDESC,
	ar.amount
  FROM	ar_export ar,
	rbr_date rbr
 WHERE	rbr.rbr_date = ar.rbr_date
   --AND	rbr.date_ar_generated IS NULL
   --AND	rbr.budget_close_datetime IS NOT NULL
   --AND	rbr.export_failed = 0






GO
