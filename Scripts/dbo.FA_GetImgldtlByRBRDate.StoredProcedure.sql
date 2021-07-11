USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetImgldtlByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
Procedure NAME: FA_GetImgldtlByRBRDate
PURPOSE: To format the daily GL Detail for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED: Jan 5, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[FA_GetImgldtlByRBRDate] -- '2008-12-01','2008-12-31', 'FA Sales AR'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@TransactionType Varchar(24)=''
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	


-- FA has its own RBR Date
CREATE TABLE #FA_RBR_Date
(
	[RBR_Date] [datetime] NOT NULL,
	
) ON [PRIMARY]
Insert Into  #FA_RBR_Date 
      Select @startDate

WHILE (SELECT Max([RBR_Date]) FROM #FA_RBR_Date) <  @endDate
BEGIN
   Insert Into  #FA_RBR_Date 
      Select DateAdd(day, 1, Max(RBR_Date))
   From #FA_RBR_Date

END



SELECT 1 BATCHNBR,      
	(
	SELECT	COUNT(rbr2.rbr_date)
	  FROM	#FA_RBR_Date rbr2
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
	CONVERT(varchar,  jvad.rbr_date, 106)  AS RATEDATE,
	1 CONVRATE,
	Transaction_Type  TRANSDESC,	
	CONVERT(varchar, jvad.rbr_date, 106) TRANSREF,	
	CONVERT(varchar,  jvad.rbr_date, 106)  as TRANSDATE,
	SRCELDGR='GL',	
	SRCETYPE='GS',
	--COMMENT	VALUES	PROCESSCMD	DESEXIST	DESDESC	DESSTAT	DESMCSW	DESCURN	DESDEC	DESQTYSW	DESQTYDEC	DESOPFLDS	ROUTEXIST	ROUTEDESC	ROUTESTAT	SRCEXIST	
	'GL GIS FA Import' SRCDESC 
	--ACTEXIST	ACTFMTTD	ACTDESC
	 FROM	(SELECT     rbr_date AS rbr_date, GL_Account, SUM(Amount) AS total_amount, Transaction_Type
				FROM         dbo.FA_Sales_Journal
				GROUP BY rbr_date, GL_Account, Transaction_Type ) jvad,
	#FA_RBR_Date rbr
 WHERE	rbr.rbr_date = jvad.rbr_date
	and (rbr.rbr_date between @startDate and @endDate) And (jvad.Transaction_Type=@TransactionType)
--order by BTCHENTRY,sequence_id








GO
