USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ACCPAC_GetIBAPHeaderByRBRDate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--ACCPAC_GetARInvoiceByRBRDate '1 sep 2006', '15 sep 2006'

/*
Procedure NAME: ACCPAC_GetIBAPHeaderByRBRDate '1 sep 2006', '26 sep 2006'
PURPOSE: To format the daily IB AR for export to ACCPAC
AUTHOR: Roy He
DATE CREATED: Aug 6, 2006
CALLED BY: Accounting
MOD HISTORY:
*/

CREATE PROCEDURE [dbo].[ACCPAC_GetIBAPHeaderByRBRDate] 
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramAdjustment bit =0
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
	ap.IB_AP_ID as CNTITEM,
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
	
	
	CASE 
		WHEN dbo.Contract.Foreign_Contract_Number IS NOT NULL THEN
			dbo.Contract.Foreign_Contract_Number	
		ELSE
			dbo.Contract.last_name + ', ' + dbo.Contract.first_name
	END	INVCDESC,
	
	ISNULL(apply_to_doc_ctrl_num, '') INVCAPPLTO,
	
	CONVERT(varchar, ap.rbr_date, 101) DATEINVC, 

	CONVERT(varchar, ap.rbr_date, 101) DATEASOF,
	1 AS SWTAXBL,   
	abs(sum(apdtl.Amount)) AMTGROSTOT,	   
	1 as CNTPAYM,
	CONVERT(varchar, ap.rbr_date, 101) DATEDUE,	
	abs(sum(apdtl.Amount)) AMTDUE
	
 FROM   dbo.IB_AP_Header ap 
	INNER JOIN
	dbo.IB_AP_Detail apdtl
		ON ap.IB_AP_ID = apdtl.IB_AP_ID
	INNER JOIN
	dbo.RBR_Date rbr 
		ON rbr.RBR_Date = ap.RBR_Date 
	INNER JOIN
	dbo.Contract 
		ON ap.Contract_Number = dbo.Contract.Contract_Number


WHERE	(ap.RBR_Date BETWEEN @startDate AND @endDate)
	and ( 
		((apply_to_doc_ctrl_num is null or apply_to_doc_ctrl_num='') and (@paramAdjustment=0)) 
		or 
		((apply_to_doc_ctrl_num is not null and apply_to_doc_ctrl_num<>'') and (@paramAdjustment=1))
	     )	 
GROUP BY ap.IB_AP_ID,ap.Vendor_Code,ap.doc_ctrl_num_base, ap.doc_ctrl_num_type, ap.doc_ctrl_num_seq,ap.rbr_date,ap.Apply_To_Doc_Ctrl_Num,dbo.Contract.Foreign_Contract_Number,dbo.Contract.Last_Name,dbo.Contract.First_Name
ORDER BY ap.IB_AP_ID
GO
