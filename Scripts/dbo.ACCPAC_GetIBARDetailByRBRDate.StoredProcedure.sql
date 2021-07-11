USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ACCPAC_GetIBARDetailByRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*
Procedure NAME: ACCPAC_GetIBARDetailByRBRDate  '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB Ar Invoice for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED:Sep 5, 2006
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[ACCPAC_GetIBARDetailByRBRDate] --'2005-08-16','2005-08-20'
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramAdjustment bit =0
AS



-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime	

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT  
       30 as CNTBTCH,
	ardtl.IB_AR_ID as CNTITEM,
        (
	 SELECT	COUNT(ardtl2.IB_AR_ID)
	 FROM	dbo.IB_AR_Header arhrd2
		INNER JOIN
		dbo.IB_AR_Detail ardtl2 
			ON arhrd2.IB_AR_ID = ardtl2.IB_AR_ID
		 WHERE	ardtl2.IB_AR_ID = ardtl.IB_AR_ID
                  and ardtl2.Revenue_Account<=ardtl.Revenue_Account
		  AND	(arhrd2.rbr_date between @startDate and @endDate)
	) *20  CNTLINE,
        
	(
	case when INV_Total.TotalAmount>=0 then
		ardtl.Amount
	when INV_Total.TotalAmount<0 then
		-ardtl.Amount
	end) AMTEXTN,
	 
	'' TEXTDESC,
	ardtl.Revenue_Account IDACCTREV

		
     
FROM    dbo.IB_AR_Header arhrd
	INNER JOIN
	dbo.IB_AR_Detail ardtl
		ON arhrd.IB_AR_ID = ardtl.IB_AR_ID
	INNER JOIN
	dbo.IB_Invoice_Total_Amount_vw INV_Total
		ON arhrd.IB_AR_ID=INV_Total.IB_AR_ID

WHERE	(arhrd.RBR_Date BETWEEN @startDate AND @endDate)
	and 
	( 
		((arhrd.apply_to_doc_ctrl_num is null or arhrd.apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((arhrd.apply_to_doc_ctrl_num is not null and arhrd.apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	 )	

ORDER BY ardtl.IB_AR_ID  


GO
