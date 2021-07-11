USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ACCPAC_GetImglhrdByRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
Procedure NAME: ACCPAC_GetImglhrdByRBRDate
PURPOSE: To format the daily GL header for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED: Jan 5, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[ACCPAC_GetImglhrdByRBRDate] -- '2010-06-01','2010-06-30'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT  --rbr.rbr_date, 
        1 BATCHID,
	(
	SELECT	COUNT(rbr2.rbr_date)
	  FROM	rbr_date rbr2
	 WHERE	rbr2.rbr_date <= rbr.rbr_date
	  AND	(rbr2.rbr_date between @startDate and @endDate)
	) BTCHENTRY,

	'GL' SRCELEDGER,
	'GS' SRCETYPE,
	CONVERT(varchar,  rbr.rbr_date, 101) + ' Daily Sales Summary' JRNLDESC,
		
	sum(
		(case 
			when jvad.total_amount>0 then jvad.total_amount
			else 0
		 end)
            ) as JRNLDR,
	sum(
		(case 
			when jvad.total_amount<0 then jvad.total_amount * (-1)
			else 0
		 end)
            ) as JRNLCR,
	
	CONVERT(varchar, rbr.rbr_date, 101) DATEENTRY,
	--CONVERT(varchar, rbr_date, 101) date_applied,
        1 DETAILCNT,
	0 SWREVERSE,
	1 SRCEXIST,
	'GL GIS Import' as SRCDESC
  FROM	journal_voucher_account_detail jvad,
	rbr_date rbr
 WHERE	rbr.rbr_date = jvad.rbr_date
	and (rbr.rbr_date between  @startDate and @endDate)
 group by rbr.rbr_date
order by rbr.rbr_date


GO
