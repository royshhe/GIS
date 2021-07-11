USE [GISData]
GO
/****** Object:  View [dbo].[AcctgImglhdrExport]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











/****** Object:  View dbo.AcctgGlinthdrExport    Script Date: 2/18/99 12:11:36 PM ******/
/****** Object:  View dbo.AcctgGlinthdrExport    Script Date: 2/16/99 2:05:38 PM ******/
/****** Object:  View dbo.AcctgGlinthdrExport    Script Date: 1/11/99 1:03:13 PM ******/
/*
VIEW NAME: AcctgImglhdrExport
PURPOSE: To format the daily GL header for export
	to platinum.
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	Apr 23 1999 Exclude the current RBR date.
Jo Pan  Oct 18 1999 Changed journal_ctrl_num to be GIS + rbr_date
Don K	Nov 2 1999  Exclude old rbr_dates with export_failed flag.
*/
CREATE VIEW [dbo].[AcctgImglhdrExport]
AS
SELECT	'GIS' journal_type,
	'GIS' + Convert(Varchar(8), rbr_date, 11)  journal_ctrl_num,
	CONVERT(varchar, rbr_date, 101) + ' Daily Sales Summary' journal_description,
	CONVERT(varchar, GETDATE(), 101) date_entered,
	CONVERT(varchar, rbr_date, 101) date_applied,
	0 recurring_flag,
	0 repeating_flag,
	0 reversing_flag,
	0 type_flag,
	0 intercompany_flag,
	'BUDGET' company_code,
	' ' home_cur_code, 
	' ' oper_cur_code, 
	CONVERT(varchar, rbr_date, 101) document_1, 
	0 processed_flag,
	' ' date_processed
  FROM	rbr_date
 WHERE	rbr_date IN 
	(
	SELECT	jvad.rbr_date
	  FROM	journal_voucher_account_detail jvad
	)
   AND	date_gl_generated IS NULL
   AND	budget_close_datetime IS NOT NULL
   AND	export_failed = 0

















GO
