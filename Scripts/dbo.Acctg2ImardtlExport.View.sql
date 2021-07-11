USE [GISData]
GO
/****** Object:  View [dbo].[Acctg2ImardtlExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: Acctg2ImardtlExport
PURPOSE: To format the daily AR details from invoice for export to platinum.
AUTHOR: Don Kirkby
DATE CREATED: Jan 6, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Apr 23 1999 Exclude the current RBR date.
Don K	Apr 28 1999 Set unit_code to 'EACH'
Don K	May 2 1999  qty_shipped is always 1 and unit_price >= 0
Don K	Nov 2 1999  exclude old rbr dates with export_failed flag set.
*/
CREATE VIEW [dbo].[Acctg2ImardtlExport]
AS
SELECT	'BUDGET' company_code,
	' ' process_ctrl_num,
	'GIS'+CONVERT(varchar, ar.ar_export_id) source_ctrl_num,
	' ' ord_ctrl_num,
	' ' trx_ctrl_num,
	1 sequence_id,
	CASE

	WHEN ar.amount >= 0 THEN
		2031
	ELSE
		2032
	END trx_type,
	' ' location_code, /* Needs value? */
	' ' item_code,
	ISNULL(ar.authorization_number, ' ') line_desc,
	1 qty_ordered,
	1 qty_shipped,
	CASE
	WHEN ar.amount >= 0 THEN
		0
	ELSE
		1
	END qty_returned,
	'EACH' unit_code,
	ABS(ar.amount) unit_price,
	0 unit_cost,
	'GIS' tax_code,
	' ' gl_rev_acct,
	0 discount_prc_flag,
	0 discount_amt,
	' ' rma_num,
	' ' return_code
  FROM	ar_export ar,
	rbr_date rbr
 WHERE	rbr.rbr_date = ar.rbr_date
   AND	rbr.date_ar_generated IS NULL
   AND	rbr.budget_close_datetime IS NOT NULL
   AND	rbr.export_failed = 0







GO
