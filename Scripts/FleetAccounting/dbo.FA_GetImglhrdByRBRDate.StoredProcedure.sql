USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetImglhrdByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
Procedure NAME: FA_GetImglhrdByRBRDate
PURPOSE: To format the daily GL header for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED: Jan 5, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[FA_GetImglhrdByRBRDate] -- '2008-12-01','2008-12-31', 'FA Sales AR'
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


SELECT  --rbr.rbr_date, 
        1 BATCHID,
	(
	SELECT	COUNT(rbr2.rbr_date)
	  FROM	#FA_RBR_Date rbr2
	 WHERE	rbr2.rbr_date <= rbr.rbr_date
	  AND	(rbr2.rbr_date between @startDate and @endDate)
	) BTCHENTRY,

	'GL' SRCELEDGER,
	'GS' SRCETYPE,
	CONVERT(varchar,  rbr.rbr_date, 106) +' ' +Transaction_Type+ ' Daily Sales Summary' JRNLDESC,
		
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
	
	CONVERT(varchar, rbr.rbr_date, 106) DATEENTRY,
	--CONVERT(varchar, rbr_date, 101) date_applied,
        1 DETAILCNT,
	0 SWREVERSE,
	1 SRCEXIST,
	'GL GIS FA Import' as SRCDESC
  FROM	(SELECT     rbr_date AS rbr_date, GL_Account, SUM(Amount) AS total_amount, Transaction_Type
				FROM         dbo.FA_Sales_Journal
				GROUP BY rbr_date, GL_Account, Transaction_Type ) jvad,
	#FA_RBR_Date rbr
 WHERE	rbr.rbr_date = jvad.rbr_date
	and (rbr.rbr_date between  @startDate and @endDate) And  (jvad.Transaction_Type=@TransactionType)
 group by rbr.rbr_date, jvad.Transaction_Type




GO
