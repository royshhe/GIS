USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ACCPAC_GetImgldtlByRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
Procedure NAME: ACCPAC_GetImgldtlByRBRDate
PURPOSE: To format the daily GL Detail for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED: Jan 5, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[ACCPAC_GetImgldtlByRBRDate] --  '2010-06-01','2010-06-30'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



Select * from 
(
SELECT 1 BATCHNBR,      
	(
	SELECT	COUNT(rbr2.rbr_date)
	  FROM	rbr_date rbr2
	 WHERE	rbr2.rbr_date <= rbr.rbr_date
	  AND	(rbr2.rbr_date between @startDate and @endDate)
	) JOURNALID,

	(
	SELECT	COUNT(jvad2.gl_account)
	  FROM	journal_voucher_account_detail jvad2
	 WHERE	jvad2.rbr_date = jvad.rbr_date
	   AND	jvad2.gl_account <= jvad.gl_account
	) *20 TRANSNBR,
	jvad.gl_account ACCTID,
	jvad.total_amount TRANSAMT,
	2 SCURNDEC,
	jvad.total_amount SCURNAMT,
	'CA' HCURNCODE,	
	'SP' RATETYPE,	
	'CAD' SCURNCODE,	
	jvad.rbr_date AS RATEDATE,
	1 CONVRATE,
	CONVERT(varchar, jvad.rbr_date, 101) + ' Daily Sales Summary' TRANSDESC,	
	CONVERT(varchar, jvad.rbr_date, 101) TRANSREF,	
	jvad.rbr_date as TRANSDATE,
	SRCELDGR='GL',	
	SRCETYPE='GS',
	--COMMENT	VALUES	PROCESSCMD	DESEXIST	DESDESC	DESSTAT	DESMCSW	DESCURN	DESDEC	DESQTYSW	DESQTYDEC	DESOPFLDS	ROUTEXIST	ROUTEDESC	ROUTESTAT	SRCEXIST	
	'GL GIS Import' SRCDESC 
	--ACTEXIST	ACTFMTTD	ACTDESC
	 FROM	journal_voucher_account_detail jvad,
	rbr_date rbr
 WHERE	rbr.rbr_date = jvad.rbr_date
	and (rbr.rbr_date between @startDate and @endDate)
) gldtl
order by gldtl.JOURNALID,TRANSNBR






GO
