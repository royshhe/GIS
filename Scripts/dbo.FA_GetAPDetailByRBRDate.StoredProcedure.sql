USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetAPDetailByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
Procedure NAME: FA_GetAPDetailByRBRDate  '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB Ar Invoice for export
	to ACCPAc
AUTHOR: Roy He
DATE CREATED:Sep 5, 2006
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
CREATE procedure [dbo].[FA_GetAPDetailByRBRDate] --'2005-08-16','2005-08-20'
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
	apdtl.AP_ID as CNTITEM,
        (
	 SELECT	COUNT(apdtl2.AP_ID)
	 FROM	dbo.FA_AP_Header aphrd2
		INNER JOIN
		dbo.FA_AP_Detail apdtl2 
			ON aphrd2.AP_ID = apdtl2.AP_ID
		 WHERE	apdtl2.AP_ID = apdtl.AP_ID
                  and apdtl2.Expense_Account<=apdtl.Expense_Account
		  AND	(aphrd2.rbr_date between @startDate and @endDate)
	) *20  CNTLINE,
        
	(
	case when aphrd.Amount>=0 then
		apdtl.Amount
	when aphrd.Amount<0 then
		-apdtl.Amount
	end) AMTDIST,	 
	'' TEXTDESC,
	apdtl.Expense_Account IDGLACCT

		
     
FROM    dbo.FA_AP_Header aphrd
	INNER JOIN
	dbo.FA_AP_Detail apdtl
		ON aphrd.AP_ID = apdtl.AP_ID
--	INNER JOIN
--	dbo.FA_AP_Invoice_Total_vw INV_Total
--		ON aphrd.AP_ID=INV_Total.AP_ID

WHERE	(aphrd.RBR_Date BETWEEN @startDate AND @endDate)
	and 
	( 
		((aphrd.apply_to_doc_ctrl_num is null or aphrd.apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((aphrd.apply_to_doc_ctrl_num is not null and aphrd.apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	 )	
	And aphrd.Transaction_Type =@TransactionType

ORDER BY apdtl.AP_ID  





GO
