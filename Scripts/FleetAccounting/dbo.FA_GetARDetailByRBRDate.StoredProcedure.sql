USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetARDetailByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
Procedure NAME: FA_GetARDetailByRBRDate  '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB Ar Invoice for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED:Sep 5, 2006
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[FA_GetARDetailByRBRDate] --'2005-08-16','2005-08-20'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramAdjustment bit =0,
	@TransactionType Varchar(24)=''
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT  
       30 as CNTBTCH,
	ardtl.AR_ID as CNTITEM,
        (
	 SELECT	COUNT(ardtl2.AR_ID)
	 FROM	dbo.FA_AR_Header arhrd2
		INNER JOIN
		dbo.FA_AR_Detail ardtl2 
			ON arhrd2.AR_ID = ardtl2.AR_ID
		 WHERE	ardtl2.AR_ID = ardtl.AR_ID
                  and ardtl2.Revenue_Account<=ardtl.Revenue_Account
		  AND	(arhrd2.rbr_date between @startDate and @endDate)
	) *20  CNTLINE,
        
	(
	case when arhrd.Amount>=0 then
		ardtl.Amount
	when  arhrd.Amount<0 then
		-ardtl.Amount
	end) AMTEXTN,
	 
	'' TEXTDESC,
	ardtl.Revenue_Account IDACCTREV

		
     
FROM    dbo.FA_AR_Header arhrd
	INNER JOIN
	dbo.FA_AR_Detail ardtl
		ON arhrd.AR_ID = ardtl.AR_ID
--	INNER JOIN
--	dbo.FA_Invoice_Total_Amount_vw INV_Total
--		ON arhrd.AR_ID=INV_Total.AR_ID

WHERE	(arhrd.RBR_Date BETWEEN @startDate AND @endDate)
	and 
	( 
		((arhrd.apply_to_doc_ctrl_num is null or arhrd.apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((arhrd.apply_to_doc_ctrl_num is not null and arhrd.apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	 )	
  And arhrd.Transaction_Type =@TransactionType

ORDER BY ardtl.AR_ID  




GO
