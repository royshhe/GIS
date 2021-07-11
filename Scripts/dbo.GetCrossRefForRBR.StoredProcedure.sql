USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCrossRefForRBR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/* 
** Author: Linda Qu 							**
** Date: Dec 23, 1999                                         		**
** Purpose:  Lists all transaction s for a given RBR date that would    **
**           normally be included on the location end of day report     **
** Parameter: @RBRDate-  e.g '19 Dec 1999' or 'Dec 19 1999' 		**
**           
*/
CREATE PROCEDURE [dbo].[GetCrossRefForRBR]
                 @RBRDate varchar(24)
AS


DECLARE @thisRBRDate DATETIME
IF @RBRDate = ''
	SELECT @thisRBRDate =
		(SELECT
			Max(RBR_Date)
		FROM
			RBR_Date
		WHERE
			Budget_Close_Datetime IS NOT NULL)
ELSE
	SELECT	@thisRBRDate = CAST(@RBRDate AS datetime)


PRINT ' ****************   Cross Reference For Each RBR Date   **************** '
PRINT ' ***  RBR Date:'+CONVERT(varchar(24),@thisRBRDate)+'                  Report DateTime:' + CONVERT(VARCHAR(20),GETDATE())+'  ***'
PRINT ''

SELECT 
'DonType'=br.Transaction_Type,
'Doc#'= br.Contract_Number,
'TransType'=CASE WHEN con.Status = 'VD' AND br.Transaction_Description = 'Check In'
					THEN 'Void'
					ELSE br.Transaction_Description
				  END,
'TransactionTime'=br.Transaction_Date,
'Location'=loc.Location

FROM business_transaction br,
Location loc,
Contract con

WHERE br.rbr_date=@thisRBRDate
AND br.Location_ID=loc.Location_ID
AND con.Contract_Number=br.Contract_Number

UNION

SELECT 
'DonType'=br.Transaction_Type,
'Doc#'= CASE
 --         WHEN br.Transaction_Type='con' THEN br.Contract_Number
          WHEN br.Transaction_Type='res' THEN br.Confirmation_Number
          WHEN br.Transaction_Type='sls' THEN br.Sales_Contract_Number
        END,
'TransType'=br.Transaction_Description,
'TransactionTime'=br.Transaction_Date,
'Location'=loc.Location

FROM business_transaction br,
Location loc

WHERE br.rbr_date=@thisRBRDate
AND br.Location_ID=loc.Location_ID
AND br.Transaction_type in ('res','sls')

ORDER BY transaction_type --,'Doc#'
GO
