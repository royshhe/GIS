USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_3_Accounts_Receivable_Daily_Transaction]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_3_Accounts_Receivable_Daily_Transaction
PURPOSE: Select all the information needed for Accounts Receivable Daily Transaction Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Accounts Receivable Daily Transaction Report
MOD HISTORY:
Name 		Date		Comments
*/

CREATE PROCEDURE [dbo].[RP_SP_Acc_3_Accounts_Receivable_Daily_Transaction]
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999'
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime

SELECT	@startDate	= CONVERT(datetime, @paramStartDate),
		@endDate	= CONVERT(datetime, @paramEndDate)	
	
SELECT AR_Export.AR_Export_ID,
    	AR_Export.RBR_Date AS Business_OR_Apply_OR_Invoice_Date,     	
	Invoice_Number = CASE
		WHEN AR_Export.summary_level = 'D' THEN
			Replace(AR_Export.doc_ctrl_num_base, 'C000', '') + 
           AR_Export.doc_ctrl_num_type +
			RIGHT(CONVERT(varchar,
			AR_Export.doc_ctrl_num_seq + 1000), 3)
		ELSE /* L or C */
			SUBSTRING(AR_Export.doc_ctrl_num_base + SPACE(8), 1, 9) +
			RIGHT(CONVERT(varchar,
			AR_Export.doc_ctrl_num_seq + 10000000), 7)
		END,
    	Replace(AR_Export.Apply_To_Doc_Ctrl_Num, 'C000', '') AS Apply_To_Number,
    	AR_Export.Customer_Account AS Customer,
    	Location.Location AS Territory,
    	AR_Export.Amount AS Net_Amount,
	Document_Type = CASE
		WHEN AR_Export.Amount >= 0 THEN
			'Debit'
		WHEN AR_Export.Amount <  0 THEN
			'Credit'
		END
FROM 	AR_Export with(nolock)
	LEFT OUTER JOIN
    	Location
		ON AR_Export.Location_ID = Location.Location_ID
WHERE 	AR_Export.RBR_Date BETWEEN @startDate AND @endDate

RETURN @@ROWCOUNT
























GO
