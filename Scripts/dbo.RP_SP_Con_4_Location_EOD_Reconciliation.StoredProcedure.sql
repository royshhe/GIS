USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_4_Location_EOD_Reconciliation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------        Programmer :  Jack Jian
------- 	  Date :             JUN 15, 2001
-------        Details:           CREATE THIS NEW SP INSTEAD OF USING RP_SP_Con_4_Location_EOD_Reconciliation FOR THE PERFORMANCE PURPOSE ...
-------                               THIS SP IS USED IN THE MAIN REPORT OF THE LOCATION END OF DAY REPORT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RP_SP_Con_4_Location_EOD_Reconciliation] --'1','19 dec 2012'

(
	@paramLocID varchar(20) = '*',
	@paramBusDate varchar(20) = '01 MAY 2000'
)
AS

-- convert strings to datetime

DECLARE 	@busDate datetime
SELECT	@busDate	= CONVERT(datetime, '00:00:00 ' + @paramBusDate)


-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 

-- end of fixing the problem

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
	Unit_Number = CASE WHEN Vehicle.Foreign_Vehicle_Unit_Number IS NULL
			THEN CONVERT(varchar, vMain.Unit_Number)
			ELSE Vehicle.Foreign_Vehicle_Unit_Number
		      END,
    	isnull(Signature_Flag,'') Signature_Flag,
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
  	Cert_Payment_US_Amt,
   	Voucher_Payment_Cdn_Amt,
  	Voucher_Payment_US_Amt,
  	CASE WHEN isnull(POReq.po_num_reqd_flag,0) <> 0 or POReq.CID='S/Voucher'
			THEN '*'
			ELSE NULL
	END as PO_Req_Flag

FROM	(

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
	  	Cert_Payment_US_Amt,
	   	Voucher_Payment_Cdn_Amt,
	  	Voucher_Payment_US_Amt
	FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Con with(nolock)
	WHERE
	 	(@paramLocID = '*' or CONVERT(INT, @tmpLocID) = Location_ID)
		AND
		DATEDIFF(dd, @busDate, RBR_Date) = 0
		and not (user_id='5 Litre Refund' and Payment_Sequence is null)--except for those only have business transaction case for example, refund but not go through and only create business transantions. peter/12.19
	
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
		0,
		0,
		0,
		0
	FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Res with(nolock)
	WHERE
	 	(@paramLocID = '*' or CONVERT(INT, @tmpLocID) = Location_ID)
		AND
		DATEDIFF(dd, @busDate, RBR_Date) = 0
	
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
		0,
		0,
		0,
		0
	FROM	RP_Con_4_Location_EOD_Reconciliation_L1_Base_Sls with(nolock)
	WHERE
	 	(@paramLocID = '*' or CONVERT(INT, @tmpLocID) = Location_ID)
		AND
		DATEDIFF(dd, @busDate, RBR_Date) = 0

) vMain
	LEFT
	JOIN
	Vehicle
		ON Vehicle.Unit_Number = vMain.Unit_Number
	left join RP_Con_4_Location_EOD_Reconciliation_L1_Base_POReq POReq
		on vMain.Document_Number=POReq.Contract_number

ORDER BY 
    	Document_Type,
	RBR_Date,
	Location_ID,
	Location_Name,
    	Document_Number,
    	Foreign_Document_Number, 
	Payment_Sequence,	
    	Transaction_Description


--RETURN @@ROWCOUNT





GO
