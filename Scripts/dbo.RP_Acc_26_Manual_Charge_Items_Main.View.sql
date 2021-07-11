USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_26_Manual_Charge_Items_Main]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO













/*
VIEW NAME: RP_Acc_5_CSR_Summary_Activity_Main_L1
PURPOSE: Select only the core records for the CSR Summary Activity Report.
	 Data for the 6 subreports is retrieved
	 in the separate views named "RP_Acc_5_CSR_Summary_subreport_name_SB_Base_1"
		
AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: CSR Summary Activity Report
MOD HISTORY:
Name 		Date		Comments
Vinnie		2017/01/26	Updated code to include GST, PST, and PVRT
*/
CREATE VIEW [dbo].[RP_Acc_26_Manual_Charge_Items_Main]
AS

	-- Get manual charge items for GIS contracts
	SELECT	
		CCI.Contract_Number ,
		c.status,
		'Manual' as Charge_Item_Type,
		cci.Charge_Type as Charge_Type_ID,
		LT.Value,
		Unit_Type,
		Unit_Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Quantity, 
		amount,
		cci.Charged_By,
		cci.business_transaction_id
	FROM	Contract_Charge_Item CCI inner	JOIN 
			Contract C  ON CCI.Contract_Number = C.Contract_Number  
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Manual'
	WHERE	CCI.Charge_Item_Type = 'm'
	AND	NULLIF(C.Foreign_Contract_Number,'') IS NULL

	UNION ALL

	-- Get manual charge items for Foreign (rentback) contracts
	SELECT	
		CCI.Contract_Number,
		c.status,
		'Rentback' as Charge_Item_Type,
		cci.Charge_Type as Charge_Type_ID,
		LT.Value,
		Unit_Type,
		Unit_Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Quantity, 
		amount,
		cci.Charged_By,
		cci.business_transaction_id 
	FROM	Contract_Charge_Item CCI inner	JOIN 
			Contract C  ON CCI.Contract_Number = C.Contract_Number
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Rentback'
	WHERE	CCI.Charge_Item_Type = 'm'
	AND	NULLIF(C.Foreign_Contract_Number,'') IS NOT NULL

	UNION ALL

	-- Get adjustment charge items
	SELECT	
		cci.Contract_Number,
		c.status,
		'Adjustment' as Charge_Item_Type,
		cci.Charge_Type as Charge_Type_ID,
		LT.Value,
		Unit_Type,
		Unit_Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Quantity, 
		amount,
		cci.Charged_By,
		cci.business_transaction_id 
	FROM	Contract_Charge_Item CCI inner	JOIN 
			Contract C  ON CCI.Contract_Number = C.Contract_Number
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Adjustment'
	WHERE	Charge_Item_Type = 'a'

	UNION ALL

	-- Get reimbursement charge items
	SELECT	
		cci.Contract_Number,
		c.status,
		'Reimbursement' as Charge_Item_Type,
		cci.Charge_Type as Charge_Type_ID,
		LT.Value,
		Unit_Type,
		Unit_Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Quantity, 
		amount,
		cci.Charged_By,
		cci.business_transaction_id
	FROM	Contract_Charge_Item CCI inner	JOIN 
			Contract C  ON CCI.Contract_Number = C.Contract_Number 
		LEFT JOIN Lookup_Table LT
		  ON CCI.Charge_Type = LT.Code
		 AND LT.Category = 'Charge Type Reimbursement'
	WHERE	Charge_Item_Type = 'r'

	UNION ALL

	-- Get reimbursements
	SELECT	
		CRD.Contract_Number,
		c.status,
		'Reimbursement' as Charge_Item_Type,
		'9999' as Charge_Type_ID,
		Reimbursement_Reason as Item_Description,
		'Flat' as Unit_Type,
		Flat_Amount ,
		GST_Amount = 0,
		PST_Amount = 0,
		PVRT_Amount = 0,
		'1' as Quantity, 
		Flat_Amount as amount,
		CRD.Entered_By,
		CRD.business_transaction_id 
--select *		
	FROM	Contract_Reimbur_And_Discount CRD inner	JOIN 
			Contract C  ON CRD.Contract_Number = C.Contract_Number 
	WHERE	Type = 'Reimbursement'












GO
