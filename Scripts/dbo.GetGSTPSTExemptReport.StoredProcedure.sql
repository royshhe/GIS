USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGSTPSTExemptReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--drop procedure GETgstpstexemptreport 2000
/*
PURPOSE: Lists all closed contracts if either PST or GST is exempt
         for the specified year. Note this serves as a ad-hoc report. 
         Requirments and layout may be changed later. 
AUTHOR: LQ
DATE: Jan 25, 2001
MOD HISTORY:
Name    Date        Comments
LQ   Jan 25 2001    Created
*/

 
CREATE PROCEDURE [dbo].[GetGSTPSTExemptReport] 
                 @reportyear char(4)
AS
SET NOCOUNT ON 
DECLARE @intYEAR  SMALLINT

SELECT @intYear = CONVERT(SMALLINT, @reportyear) 
PRINT '*------ GST/PST exempt during the year of ' + @reportyear +' ------*'
PRINT '* Report Generated Date:'+  CONVERT (VARCHAR(20),GETDATE(),102)
PRINT '*----------------------------------------------------*'
SELECT 'Month'=DATEPART (MONTH, bt.RBR_DATE),'Contract#'=con.CONTRACT_NUMBER 
FROM 	Contract con
	INNER JOIN 
	Business_Transaction bt
	ON 
        	con.Status='CI'
        	AND   BT.Transaction_Type='Con'
                AND   BT.Transaction_Description='Check In'
                AND   BT.Contract_Number=Con.Contract_Number
         
WHERE DATEPART(YEAR,bt.RBR_DATE)=@intYEAR
      AND (con.GST_EXEMPT_NUM+con.PST_EXEMPT_NUM) IS NOT NULL 
GROUP BY DATEPART(MONTH, bt.RBR_Date), con.CONTRACT_NUMBER
ORDER BY DATEPART(MONTH,bt.RBR_Date)
SET NOCOUNT OFF
RETURN 0

GO
