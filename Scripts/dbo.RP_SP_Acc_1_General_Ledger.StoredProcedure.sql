USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_1_General_Ledger]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_1_General_Ledger
PURPOSE: Select all the information needed for General Ledger Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: General Ledger Report
MOD HISTORY:
Name 		Date		Comments
Joseph T.           Sep 10, 1999	Add filtering to improve performance
*/

CREATE Procedure [dbo].[RP_SP_Acc_1_General_Ledger]
(
	@paramStartDate varchar(20) = '15 April 1999',
	@paramEndDate varchar(20) = '15 April 1999',
	@paramRevLocID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

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

	
SELECT	GL_Account_Number,
	ISNULL(GL_Account_Name, '*** Undefined ***') As GL_Account_Name,
	Document_Type,
	Document_Number,
	Revenue_Location_Name,
	Revenue_Location_ID,
	SUM(Debit)				AS Debit_Total,
	SUM(Credit)				AS Credit_Total,
	SUM(Debit) - SUM(Credit)		AS JV_Sum
FROM	RP_Acc_1_General_Ledger_L2_Base_1 with(nolock)
WHERE	
	RBR_Date BETWEEN @startDate AND @endDate
	AND
	(@paramRevLocID = "*" or CONVERT(INT, @tmpLocID) = Revenue_Location_ID)
GROUP BY	GL_Account_Number,
		GL_Account_Name,
		Document_Type,
		Document_Number,
		Revenue_Location_Name,
		Revenue_Location_ID
			
RETURN @@ROWCOUNT

GO
