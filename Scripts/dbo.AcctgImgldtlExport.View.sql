USE [GISData]
GO
/****** Object:  View [dbo].[AcctgImgldtlExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











/****** Object:  View dbo.AcctgGlintdetExport    Script Date: 2/18/99 12:11:36 PM ******/
/****** Object:  View dbo.AcctgGlintdetExport    Script Date: 2/16/99 2:05:38 PM ******/
/****** Object:  View dbo.AcctgGlintdetExport    Script Date: 1/11/99 1:03:13 PM ******/
/*
VIEW NAME: AcctgImgldtlExport
PURPOSE: To format the daily GL transactions from 
	journal_voucher_account_detail for export to platinum.
AUTHOR: Don Kirkby
DATE CREATED: Jan 6, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Apr 23 1999 Exclude the current RBR date.
Jo Pan  Oct 18 1999 Changed journal_ctrl_num to be GIS + rbr_date
Don K	Nov 2 1999  Exclude old rbr dates with export_failed flag.
*/
CREATE VIEW [dbo].[AcctgImgldtlExport]
AS
SELECT'BUDGET' company_code,
	'GIS' + Convert(Varchar(8), rbr.rbr_date, 11)  journal_ctrl_num,
	(
	SELECT	COUNT(jvad2.gl_account)
	  FROM	journal_voucher_account_detail jvad2
	 WHERE	jvad2.rbr_date = jvad.rbr_date
	   AND	jvad2.gl_account <= jvad.gl_account
	) sequence_id,
	'BUDGET' rec_company_code,
	jvad.gl_account account_code,
	CONVERT(varchar, jvad.rbr_date, 101) + ' Daily Sales Summary' description,
	CONVERT(varchar, jvad.rbr_date, 101) document_1, 
	' ' document_2, 
	' ' reference_code,
	jvad.total_amount balance,
	jvad.total_amount balance_oper,
	jvad.total_amount nat_balance,
	'CAD' nat_cur_code,
	'1.00' rate,
	'1.0' rate_oper,
	' ' rate_type_home,
	' ' rate_type_oper
  FROM	journal_voucher_account_detail jvad,
	rbr_date rbr
 WHERE	rbr.rbr_date = jvad.rbr_date
   AND	rbr.date_gl_generated IS NULL
   AND	rbr.budget_close_datetime IS NOT NULL
   AND	rbr.export_failed = 0




















GO
