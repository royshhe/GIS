USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_11_Inclusive_Rate_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_11_Inclusive_Rate_Main
PURPOSE: Select all the information needed for
	 Main report of Inclusive Rate Revenue Split Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/21
USED BY: Main report of Inclusive Rate Revenue Split Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_11_Inclusive_Rate_Main]
(
		@paramStartDate varchar(20) = '1999/04/27',
		@paramEndDate varchar(20) = '1999/04/27'
)
AS
-- convert strings to datetime
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

SELECT 	'1' AS Group_ID,
	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.RBR_Date,
   	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Contract_Number,
   	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Date_Time_In,
   	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Pick_Up_Location_Name,
    	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Rate_Name,
   	ISNULL(RP_Acc_11_Inclusive_Rate_L1_Time_Revenue.Inclusive_Time_Ravenue,0) AS Inclusive_Time_Ravenue,
    	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Location_Fee_Included,
	GL_Revenue_Account = CASE
		WHEN RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account IS NULL
		THEN NULL
		ELSE
			SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 1,5) + '-'
			+ SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 6,2 ) + '-'
			+ SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 8,1) + '-'
			+ SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 9,1)
		END,
	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Description,
   	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Amount,
   	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GST_Exempt,
   	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.PST_Exempt
FROM 	RP_Acc_11_Inclusive_Rate_L1_Contract_Info with(nolock)
	LEFT OUTER JOIN
   	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
		ON RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Contract_Number =
    			RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Contract_Number
	LEFT OUTER JOIN
   	RP_Acc_11_Inclusive_Rate_L1_Time_Revenue
		ON RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Contract_Number =
    			RP_Acc_11_Inclusive_Rate_L1_Time_Revenue.Contract_Number

WHERE	RP_Acc_11_Inclusive_Rate_L1_Contract_Info.RBR_Date BETWEEN @startDate AND @endDate
			
RETURN @@ROWCOUNT






















GO
