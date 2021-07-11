USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_11_Inclusive_Rate_SB_1_Time_Revenue_Inc_Loc_Fee]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: RP_SP_Acc_11_Inclusive_Rate_SB_1_Time_Revenue_Inc_Loc_Fee
PURPOSE: Calculate total inclusive time revenue for
	 Total Inclusive Revenue by Account (including Location fee) subreport of
	 Inclusive Rate Revenue Split Report

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/02/23
USED BY: Subreport (Including Location Fee) of Inclusive Rate Revenue Split Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE Procedure [dbo].[RP_SP_Acc_11_Inclusive_Rate_SB_1_Time_Revenue_Inc_Loc_Fee]
(
		@RBR_Start_Date DATETIME = '1999/04/27',
		@RBR_End_Date DATETIME = '1999/04/27'
)

AS
SELECT 	SUM(RP_Acc_11_Inclusive_Rate_L1_Time_Revenue.Inclusive_Time_Ravenue) AS Time_Revenue

FROM
	RP_Acc_11_Inclusive_Rate_L1_Contract_Info with(nolock)
	JOIN    
   	RP_Acc_11_Inclusive_Rate_L1_Time_Revenue
		    ON RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Contract_Number =
    			    RP_Acc_11_Inclusive_Rate_L1_Time_Revenue.Contract_Number
WHERE   RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Location_Fee_Included = 'Y'
        AND
        RP_Acc_11_Inclusive_Rate_L1_Contract_Info.RBR_Date BETWEEN @RBR_Start_Date AND @RBR_End_Date


return @@ROWCOUNT















GO
