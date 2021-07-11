USE [GISData]
GO
/****** Object:  View [dbo].[Acctg2ImardtlExportAdj]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/*
VIEW NAME: AcctgImardtlExportAdj
PURPOSE: To export only the adjustments
AUTHOR: Don Kirkby
DATE CREATED: Apr 22, 1999
CALLED BY: Accounting

MOD HISTORY:
Name       Date         	Comments
Jack Jian  Mar 02 2001	Add new field for new platium
*/ 

CREATE VIEW [dbo].[Acctg2ImardtlExportAdj]
AS

-- Programmer:   Jack Jian
-- Date:		Mar 02, 2001
-- Details:	Add new field 'Weight' and put default value '0'
-- SELECT	*
Select 
	company_code ,
	process_ctrl_num ,
	source_ctrl_num,
             ord_ctrl_num ,
	trx_ctrl_num ,
	sequence_id ,
	trx_type    ,
	location_code ,
	item_code ,
	line_desc    ,
	qty_ordered ,
	qty_shipped ,
	qty_returned ,
	unit_code ,
	unit_price  ,
	unit_cost   ,
	'0' as weight ,   -- New field
	tax_code ,
	gl_rev_acct ,
	discount_prc_flag ,
	discount_amt ,
	rma_num ,
	return_code ,
	' ' as reference_code  -- New field

  FROM	Acctg2ImardtlExport

 WHERE	source_ctrl_num IN
	(
	SELECT	source_ctrl_num
	  FROM	Acctg1ImarhdrExportAdj
	)





















GO
