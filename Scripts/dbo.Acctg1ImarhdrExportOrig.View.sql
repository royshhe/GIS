USE [GISData]
GO
/****** Object:  View [dbo].[Acctg1ImarhdrExportOrig]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  View dbo.AcctgIrheaderExportOriginals    Script Date: 2/18/99 12:11:39 PM ******/
/****** Object:  View dbo.AcctgIrheaderExportOriginals    Script Date: 2/16/99 2:05:38 PM ******/
/*
VIEW NAME: Acctg1ImarhdrExportOrig
PURPOSE: To export only the original invoices and credit memos
AUTHOR: Don Kirkby
DATE CREATED: Feb 1, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Jack Jian Mar 02, 2001 Add new field
Jack Jian Mar 05, 2001 change hold_flag to int type , apply_trx_type to int , recurring_flag to 1 or 0
*/
CREATE VIEW [dbo].[Acctg1ImarhdrExportOrig]
AS

--  Programmer:   Jack Jian
--  Date:		Mar 02, 2001
--  Details:	Add New field date_aging for new platium version.

--  SELECT	*
select 
	company_code ,
	process_ctrl_num ,
	source_ctrl_num                   ,
	order_ctrl_num ,
	trx_ctrl_num ,
	doc_desc     ,                                        
	doc_ctrl_num,     
	apply_to_num,     
	convert(int , apply_trx_type) as apply_trx_type , 
	trx_type    ,
	date_applied                   ,
	date_doc                       ,
	date_shipped                  , 
	date_due ,
	' ' as date_aging ,  			--  New field
	customer_code ,
	ship_to_code ,
	salesperson_code ,
	territory_code ,
	comment_code ,
	posting_code ,
	terms_code ,
	cust_po_num          ,
	 convert(int,hold_flag) as hold_flag,
	hold_desc ,
	( case 
		when trx_type = 2031 then 
			0                                     -- Invoice
		when trx_type = 2032 then 
			1			-- Credit memo
	end ) recurring_flag ,
	recurring_code , 		         
	tax_code ,
	nat_cur_code ,
	rate_type_home ,
	rate_type_oper ,
	rate_home   ,
	rate_oper   ,
	prepay_discount ,
	prepay_amt  ,
	prepay_doc_num ,
	processed_flag ,
	date_processed 

  FROM	Acctg1ImarhdrExport
 WHERE	apply_to_num = '' or apply_to_num = ' '





















GO
