USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetAPHeaderByRBRDate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--FA_GetAPHeaderByRBRDate '1 Jul 2007', '30 Jun 2009', 0, 'FA Sales AR'

/*
Procedure NAME: FA_GetAPHeaderByRBRDate '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB AR for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 6, 2006
CALLED BY: Accounting
MOD HISTORY:
*/

CREATE PROCEDURE [dbo].[FA_GetAPHeaderByRBRDate] 
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



/*SELECT   @minIBARID=(select min(IB_AP_ID) from IB_AP_Header  
	where (RBR_Date BETWEEN @startDate AND @endDate) and 
		( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 )-1
*/

--select * from IB_AP_Detail

SELECT 
	
	30 as CNTBTCH,
	ap.AP_ID as CNTITEM,
	ap.Vendor_Code IDVEND,	
	ap.doc_ctrl_num_base + ap.doc_ctrl_num_type +	RIGHT(CONVERT(varchar, 	ap.doc_ctrl_num_seq + 1000), 3)	IDINVC,
	CASE
		WHEN ap.apply_to_doc_ctrl_num IS NULL THEN 
			CASE
				WHEN sum(apdtl.Amount) >= 0 THEN
				1
				ELSE
				3
			END
		ELSE
			CASE
				WHEN sum(apdtl.Amount) >= 0 THEN
				2
				ELSE
				3
			END
	END TEXTTRX,         -- document type		
	CASE
		WHEN ap.apply_to_doc_ctrl_num IS NULL THEN 
			CASE
				WHEN sum(apdtl.Amount) >= 0 THEN
				12
				ELSE
				32
			END
		ELSE
			CASE
				WHEN sum(apdtl.Amount) >= 0 THEN
				22
				ELSE
				32
			END
	END IDTRX,         -- document type		
	
	Document_Description	INVCDESC,
	
    ISNULL(apply_to_doc_ctrl_num, '') INVCAPPLTO,
	
	CONVERT(varchar, ap.rbr_date, 106) DATEINVC, 

	CONVERT(varchar, ap.rbr_date, 106) DATEASOF,
	1 AS SWTAXBL,   
	abs(sum(apdtl.Amount)) AMTGROSTOT,	   
	1 as CNTPAYM,
	CONVERT(varchar, ap.rbr_date, 106) DATEDUE,	
	abs(sum(apdtl.Amount)) AMTDUE
	
 FROM   dbo.FA_AP_Header ap 
	INNER JOIN
	dbo.FA_AP_Detail apdtl
		ON ap.AP_ID = apdtl.AP_ID
--	INNER JOIN
--	dbo.RBR_Date rbr 
--		ON rbr.RBR_Date = ap.RBR_Date 
--	INNER JOIN
--	dbo.Contract 
--		ON ap.Contract_Number = dbo.Contract.Contract_Number



WHERE	(ap.RBR_Date BETWEEN @startDate AND @endDate)
	and ( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 
	And ap.Transaction_Type=	@TransactionType 
GROUP BY ap.AP_ID,ap.Vendor_Code,ap.doc_ctrl_num_base, ap.doc_ctrl_num_type, ap.doc_ctrl_num_seq,ap.rbr_date,ap.Apply_To_Doc_Ctrl_Num,Document_Description
ORDER BY ap.AP_ID


GO
