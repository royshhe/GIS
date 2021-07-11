USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInterimBillForBatch]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetInterimBillForBatch    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetInterimBillForBatch    Script Date: 2/16/99 2:05:41 PM ******/
/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetInterimBillForBatch]	 --  '2013-11-30 00:00'
@CutOffDate	VarChar(24)
AS

Set Rowcount 2000

DECLARE	@dCutOffDate DateTime
SELECT	@dCutOffDate = CONVERT(DateTime, NULLIF(@CutOffDate, ''))

SELECT	CON.Contract_Number,
	CON.Pick_Up_Location_Id,
	CON.Vehicle_Class_Code,
	CON.Rate_ID,
	CON.Rate_Assigned_Date,
	CON.Rate_Level,
	CON.Flex_Discount,
	CON.Member_Discount_ID,
	IB.Interim_Bill_Date,
	IB.Current_KM,
	VMY.Vehicle_Model_Id,
	VMY.PST_Rate,
	IB.Contract_Billing_Party_ID,
	( -- count how many months it has been since the current_km were updated.
	SELECT	COUNT(*)
	  FROM	interim_bill ib2
	 WHERE	ib.contract_number = ib2.contract_number
	   AND	ib.contract_billing_party_id = ib2.contract_billing_party_id
	   AND	ib.current_km = ib2.current_km
	   AND	ib.interim_bill_date > ib2.interim_bill_date
	) AS km_age
FROM	Contract CON,
	Contract_Billing_Party CBP,
	Direct_Bill_Primary_Billing DBPB,
	Interim_Bill IB,
	Vehicle_On_Contract VOC,
	Vehicle VEH,
	Vehicle_Model_Year VMY
WHERE	CON.Status = 'CO'
AND	CON.Contract_Number = CBP.Contract_Number
AND	CBP.Billing_Type = 'p'	-- Primary
AND	CBP.Billing_Method = 'Direct Bill'
AND	CON.contract_number = DBPB.Contract_Number
AND	CBP.Contract_billing_Party_Id = DBPB.Contract_Billing_Party_Id
AND	DBPB.Issue_Interim_Bills = CONVERT(Bit, '1')
AND	CON.Contract_Number = IB.Contract_Number
AND	IB.Interim_Bill_Date <= @dCutOffDate
AND	CBP.Contract_Billing_Party_Id = IB.Contract_Billing_Party_Id
AND	NOT EXISTS(	SELECT	DISTINCT 'X'
			FROM	AR_Payment
			WHERE	Contract_Number = IB.Contract_Number
			AND	Contract_Billing_Party_Id = IB.Contract_Billing_Party_Id
			AND	Interim_Bill_Date = IB.Interim_Bill_Date
		  )
AND	CON.Contract_Number = VOC.Contract_Number
AND	VOC.Unit_Number = VEH.Unit_Number
AND	VEH.Vehicle_Model_Id = VMY.Vehicle_Model_Id
AND	VOC.Actual_Check_In IS NULL
order by  CON.Contract_Number,   IB.Interim_Bill_Date


 









GO
