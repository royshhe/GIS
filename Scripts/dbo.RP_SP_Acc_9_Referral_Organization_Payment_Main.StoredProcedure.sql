USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_9_Referral_Organization_Payment_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










/*
PROCEDURE NAME: RP_SP_Acc_9_Referral_Organization_Payment_Main
PURPOSE: Select all the information needed for Referral Organization Payment Report.
	
AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Referral Organization Payment Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/14      Include Checked Out contracts with commission type = FLAT 
*/
CREATE Procedure [dbo].[RP_SP_Acc_9_Referral_Organization_Payment_Main]
(
	@RBR_Start_Date CHAR(10) 	= '1999/01/01',
	@RBR_End_Date 	CHAR(10) 	= '1999/11/30'
)
AS
--SET ANSI_NULLS OFF
SELECT 	Group_ID,
	Check_Out_RBR_Date,
	Check_In_RBR_Date,
	Organization_ID,
	Organization,
	Address,
	Payable,
   	Org_Type_ID,
   	Org_Type_Name,
	Staff,
   	Pick_Up_Location_ID,
   	Pick_Up_Location_Name,
	Contract_Number,
   	Customer_Name,
    	Confirm_Number=case 
                              WHEN foreign_confirm_number <>'' THEN
			foreign_confirm_number
		ELSE
			convert(varchar(20),confirmation_number)
		END, 
	Pick_Up_On,
   	FPO_Purchase,
	Referral_Fee_Commission,
	PAI_Total,
	LDW_Total,
	PEC_Cargo_Total,
	Time_Km_Total

FROM 	RP_Acc_9_Referral_Organization_Payment_L2_Main with(nolock)

WHERE
	-- when the commission is percentage, select contract if RBR date of CHECK IN is within requested dates
   	((Percentage IS NOT NULL
   	  AND
   	  Check_In_RBR_Date BETWEEN CAST(@RBR_Start_Date AS DATETIME)
			AND
			CAST(@RBR_End_Date AS DATETIME)
	 )
	 OR
	
	(Per_Day IS NOT NULL
   	  AND
   	  Check_In_RBR_Date BETWEEN CAST(@RBR_Start_Date AS DATETIME)
			AND
			CAST(@RBR_End_Date AS DATETIME)
	 )
	 OR
	
	-- when the commission paid is flat rate, select contract if RBR date of CHECK OUT is within requested dates
	 (Flat_Rate IS NOT NULL
   	  AND
   	  Check_Out_RBR_Date BETWEEN CAST(@RBR_Start_Date AS DATETIME)
			AND
			CAST(@RBR_End_Date AS DATETIME)
	 )
	)

RETURN @@ROWCOUNT

GO
