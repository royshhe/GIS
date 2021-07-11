USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetARHeaderByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--FA_GetARInvoiceByRBRDate '1 sep 2006', '15 sep 2006'

/*
Procedure NAME: FA_GetARHeaderByRBRDate '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB AR for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 6, 2006
CALLED BY: Accounting
MOD HISTORY:
*/

CREATE PROCEDURE [dbo].[FA_GetARHeaderByRBRDate] 
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramAdjustment bit =0,
	@TransactionType Varchar(24)=''
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@minIBARID int

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



/*SELECT   @minIBARID=(select min(IB_AR_ID) from IB_AR_Header  
	where (RBR_Date BETWEEN @startDate AND @endDate) and 
		( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 )-1
*/

--select * from IB_AR_Detail

SELECT 
	
	30 as CNTBTCH,
	ar.AR_ID as CNTITEM,
	ar.customer_account IDCUST,	
	ar.doc_ctrl_num_base + ar.doc_ctrl_num_type +	RIGHT(CONVERT(varchar, 	ar.doc_ctrl_num_seq + 1000), 3)	IDINVC,
	CASE
		WHEN ar.apply_to_doc_ctrl_num IS NULL THEN 
			CASE
				WHEN sum(ardtl.Amount) >= 0 THEN
				1
				ELSE
				3
			END
		ELSE
			CASE
				WHEN sum(ardtl.Amount) >= 0 THEN
				2
				ELSE
				3
			END
	END TEXTTRX,         -- document type	

	'' CUSTPO,
	
--	CASE 
--		WHEN dbo.Contract.Foreign_Contract_Number IS NOT NULL THEN
--			dbo.Contract.Foreign_Contract_Number	
--		ELSE
--			dbo.Contract.last_name + ', ' + dbo.Contract.first_name
--	END	INVCDESC,
  ar.Document_Description INVCDESC,
	
	ISNULL(apply_to_doc_ctrl_num, '') INVCAPPLTO,
	
	CONVERT(varchar, ar.rbr_date, 106) DATEINVC, 

	CONVERT(varchar, ar.rbr_date, 106) DATEASOF,
	1 AS SWMANTX,      
	1 as CNTPAYM,
	CONVERT(varchar, ar.rbr_date, 106) DATEDUE,
	abs(sum(ardtl.Amount)) AMTDUE
	
 FROM   dbo.FA_AR_Header ar 
	INNER JOIN
	dbo.FA_AR_Detail ardtl
		ON ar.AR_ID = ardtl.AR_ID
--	INNER JOIN
--	dbo.RBR_Date rbr 
--		ON rbr.RBR_Date = ar.RBR_Date 
--	INNER JOIN
--	dbo.Contract 
--		ON ar.Contract_Number = dbo.Contract.Contract_Number


WHERE	(ar.RBR_Date BETWEEN @startDate AND @endDate)
	and ( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 
And ar.Transaction_Type =@TransactionType

GROUP BY ar.AR_ID,ar.customer_account,ar.doc_ctrl_num_base, ar.doc_ctrl_num_type, ar.doc_ctrl_num_seq,ar.rbr_date,ar.Apply_To_Doc_Ctrl_Num, ar.Document_Description--,dbo.Contract.Foreign_Contract_Number,dbo.Contract.Last_Name,dbo.Contract.First_Name
ORDER BY ar.AR_ID


GO
