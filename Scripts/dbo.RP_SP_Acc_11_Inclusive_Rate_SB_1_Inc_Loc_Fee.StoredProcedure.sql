USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_11_Inclusive_Rate_SB_1_Inc_Loc_Fee]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: RP_SP_Acc_11_Inclusive_Rate_SB_1_Inc_Loc_Fee
PURPOSE: Select information of each G/L account for
	 Total Inlcusive Revenue Amount (including Location fee) subreport of
	 Inclusive Rate Revenue Split Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Subreport (Including Location Fee) of Inclusive Rate Revenue Split Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/02/23	Do not select the inclusive time interval here
*/
CREATE Procedure [dbo].[RP_SP_Acc_11_Inclusive_Rate_SB_1_Inc_Loc_Fee]
(
		@RBR_Start_Date DATETIME = '1999/04/27',
		@RBR_End_Date DATETIME = '1999/04/27'
)

AS
SELECT 	1 AS GROUP_ID,
	SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 1,5) + '-'
	        + SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 6,2 ) + '-'
		    + SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 8,1) + '-'
		    + SUBSTRING(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account, 9,1)
    	AS GL_Revenue_Account,
	    RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GST_Exempt,
   	    RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.PST_Exempt,
	    RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Description,
   	    SUM(RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Amount) AS Amount   	

FROM	RP_Acc_11_Inclusive_Rate_L1_Contract_Info with(nolock)
	    LEFT OUTER JOIN
   	    RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO
		    ON RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Contract_Number =
    		    	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Contract_Number

WHERE   RP_Acc_11_Inclusive_Rate_L1_Contract_Info.Location_Fee_Included = 'Y'
        AND
        RP_Acc_11_Inclusive_Rate_L1_Contract_Info.RBR_Date BETWEEN @RBR_Start_Date AND @RBR_End_Date
        AND
        RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account IS NOT NULL

GROUP BY 	
	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GL_Revenue_Account,
	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.GST_Exempt,
   	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.PST_Exempt,
	RP_Acc_11_Inclusive_Rate_L3_OE_SA_FPO.Description


return @@ROWCOUNT
























GO
