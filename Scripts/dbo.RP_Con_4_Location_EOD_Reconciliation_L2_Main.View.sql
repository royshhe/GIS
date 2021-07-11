USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L2_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: RP_Con_4_Location_EOD_Reconciliation_L2_Main
PURPOSE: Get all information required for Location End Of Day Reconciliation Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Location End Of Day Reconciliation Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/24	Add the payment sequence field

*/
CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L2_Main]
AS
SELECT 
	RBR_Date, 
	Location_ID, 
	Location_Name, 
    	Document_Type, 
    	Document_Number, 
    	Foreign_Document_Number,
	Payment_Sequence, 
    	Transaction_Description, 
    	Transaction_Date, 
    	User_ID, 
	Unit_Number, 
    	Signature_Flag,
    	Handheld_Flag,
   	Cash_Payment_Cdn_Amt,
  	Cash_Payment_US_Amt,
	DebitCard_Payment_Cdn_Amt,
	Mail_Refund_Cdn_Amt,
	CC_Budget_Amt,
	--CC_Sears_Amt,
	CC_Novus_Amt,
	CC_AMEX_Amt,
	CC_Diners_Amt,
	CC_JCB_Amt,
	CC_MC_Amt,
	CC_VISA_Amt,
	Direct_Billing_Amt,
   	Cert_Payment_Cdn_Amt,
  	Cert_Payment_US_Amt
FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con WITH(NOLOCK)

UNION ALL

SELECT 
	RBR_Date, 
	Location_ID, 
	Location_Name, 
    	Document_Type, 
    	Document_Number, 
    	Foreign_Document_Number, 
	NULL, 
    	Transaction_Description, 
    	Transaction_Date, 
    	User_ID, 
	Unit_Number, 
    	Signature_Flag,
    	Handheld_Flag,
   	Cash_Payment_Cdn_Amt,
  	Cash_Payment_US_Amt,
	DebitCard_Payment_Cdn_Amt,
	Mail_Refund_Cdn_Amt,
	CC_Budget_Amt,
	--CC_Sears_Amt,
	CC_Novus_Amt,
	CC_AMEX_Amt,
	CC_Diners_Amt,
	CC_JCB_Amt,
	CC_MC_Amt,
	CC_VISA_Amt,
	Direct_Billing_Amt,
	0,--Certificate payment Cnd$ amount
	0 --Certificate payment US$ amount
FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Res WITH(NOLOCK)

UNION ALL

SELECT 
	RBR_Date, 
	Location_ID, 
	Location_Name, 
    	Document_Type, 
    	Document_Number, 
    	Foreign_Document_Number, 
	NULL, 
    	Transaction_Description, 
    	Transaction_Date, 
    	User_ID, 
	Unit_Number, 
    	Signature_Flag,
    	Handheld_Flag,
   	Cash_Payment_Cdn_Amt,
  	Cash_Payment_US_Amt,
	DebitCard_Payment_Cdn_Amt,
	Mail_Refund_Cdn_Amt,
	CC_Budget_Amt,
	--CC_Sears_Amt,
	CC_Novus_Amt,
	CC_AMEX_Amt,
	CC_Diners_Amt,
	CC_JCB_Amt,
	CC_MC_Amt,
	CC_VISA_Amt,
	Direct_Billing_Amt,
	0,--Certificate payment Cnd$ amount
	0 --Certificate payment US$ amount
FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Sls WITH(NOLOCK)
GO
