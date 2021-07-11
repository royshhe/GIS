USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_2_Sales_Journal]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: RP_SP_Acc_2_Sales_Journal
PURPOSE: Select all the information needed for Sales Journal Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/13
USED BY: Sales Journal Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/03	Show Maestro reservation number instead of GIS reservation number for reservation
*/

CREATE PROCEDURE [dbo].[RP_SP_Acc_2_Sales_Journal]
(
	@paramRevLocID varchar(20) = '*',
	@paramSalesType varchar(20) = '*',
	@paramStartDate varchar(20) = '22 April 1999',
	@paramEndDate varchar(20) = '22 April 1999'
)
AS

-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
		@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramRevLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramRevLocID
	END 

-- end of fixing the problem

SELECT	
--	SUBSTRING(Sales_Journal.GL_Account, 1, 5)
--	+ '-' + SUBSTRING(Sales_Journal.GL_Account, 6, 2)
--	+ '-' + SUBSTRING(Sales_Journal.GL_Account, 8, 1)         
--	+ 
--        (case 
--		when SUBSTRING(Sales_Journal.GL_Account, 9, 1)<>'' then
--		'-' + SUBSTRING(Sales_Journal.GL_Account, 9, 1)
--                else
--                ''
--        end
--        ) 
     Sales_Journal.GL_Account  AS GL_Account_Number, 	--(Will Apply to Platinum and ACCPAC)
	ISNULL(glchart.account_description, '*** Undefined ***') AS GL_Account_Name,
	RP_Acc_2_Sales_Journal_L1_Base_1.RBR_Date,
	RP_Acc_2_Sales_Journal_L1_Base_1.Transaction_Date,
    	Document_Number = CASE WHEN RP_Acc_2_Sales_Journal_L1_Base_1.Foreign_Document_Number IS NULL
				THEN CONVERT(varchar, RP_Acc_2_Sales_Journal_L1_Base_1.Document_Number)
				ELSE RP_Acc_2_Sales_Journal_L1_Base_1.Foreign_Document_Number
			  END,
    	RP_Acc_2_Sales_Journal_L1_Base_1.Document_Type,
	RP_Acc_2_Sales_Journal_L1_Base_1.Transaction_Description,
    	RP_Acc_2_Sales_Journal_L1_Base_1.Revenue_Location_ID,
	Location.Location AS Revenue_Location_Name,
    	RP_Acc_2_Sales_Journal_L1_Base_1.Sales_Type,
    	Debit = CASE
		WHEN	Sales_Journal.Amount >= 0 THEN Sales_Journal.Amount
     		ELSE 0
	        END,
    	Credit = CASE
		WHEN Sales_Journal.Amount < 0 THEN ABS(Sales_Journal.Amount)
     		ELSE 0
	        END
FROM 	RP_Acc_2_Sales_Journal_L1_Base_1 with(nolock) 	 
	INNER JOIN
    	Sales_Journal
		ON RP_Acc_2_Sales_Journal_L1_Base_1.Business_Transaction_ID = Sales_Journal.Business_Transaction_ID
	INNER JOIN
	Location
		ON Location.Location_ID= RP_Acc_2_Sales_Journal_L1_Base_1.Revenue_Location_ID
	LEFT OUTER JOIN
	glchart
 		ON Replace(Sales_Journal.GL_Account, '-','') = glchart.account_code

WHERE
	(@paramRevLocID = "*" or CONVERT(INT, @tmpLocID) = RP_Acc_2_Sales_Journal_L1_Base_1.Revenue_Location_ID)
	AND
	(@paramSalesType = "*" or @paramSalesType = RP_Acc_2_Sales_Journal_L1_Base_1.Sales_Type)
	AND
	RP_Acc_2_Sales_Journal_L1_Base_1.RBR_Date BETWEEN @startDate AND @endDate

RETURN @@ROWCOUNT
GO
