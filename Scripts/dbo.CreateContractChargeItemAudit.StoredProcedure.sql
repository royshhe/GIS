USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractChargeItemAudit]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To create an audit trail copy of a contract charge item
AUTHOR:	Don Kirkby
DATE CREATED: Jul 1, 1999 (Oh, Canada)
CALLED BY: Contract
MOD HISTORY:
Name	Date	    Comments
*/
CREATE PROCEDURE [dbo].[CreateContractChargeItemAudit]
	@ContractNumber	varchar(11),
	@ChargeItemType	varchar(1),
	@SplitID	varchar(6),
	@SalesAccessoryID varchar(6),
	@OptionalExtraID varchar(6),
	@ChargeType	varchar(2),
	@ChargeItemDesc	varchar(50),
	@Amount		varchar(11),
	@GSTAmount	varchar(11),
	@PSTAmount	varchar(11),
	@PVRTAmount	varchar(11),
	@GSTIncluded	varchar(1),
	@PSTIncluded	varchar(1),
	@PVRTIncluded	varchar(1),
	@GSTExempt	varchar(1),
	@PSTExempt	varchar(1),
	@PVRTExempt	varchar(1),
	@BillingPartyID	varchar(11),
	@UnitAmount	varchar(11),
	@UnitType	varchar(20),
	@Quantity	varchar(11),
	@VSISeq		varchar(11),
	@ChargedBy	varchar(20),
	@ChargedOn	varchar(24),
	@PVRTDays	varchar(9),
	@GSTAmountIncl	varchar(9),
	@PSTAmountIncl	varchar(9),
	@PVRTAmountIncl	varchar(9),
	@BusTrxID	varchar(11)
AS
	DECLARE	@iSeq smallint,
		@iCtrctNum int,
		@dtChargedOn datetime
	SELECT	@iCtrctNum = Convert(int, NULLIF(@ContractNumber, ''))
	SELECT	@iSeq =
		(
		SELECT	ISNULL(MAX(sequence), 0) + 1
		  FROM	contract_charge_item_audit
		 WHERE	contract_number = @iCtrctNum
		)

	IF @ChargedOn = ''
		SELECT	@dtChargedOn = GETDATE()
	ELSE
		SELECT	@dtChargedOn = Convert(Datetime, @ChargedOn)

	INSERT
	  INTO	contract_charge_item_audit
		(
		Contract_Number,
		Charge_Item_Type,
		Sequence,
		Rental_Charge_Split_ID,
		Sales_Accessory_ID,
		Optional_Extra_ID,
		Charge_Type,
		Charge_description,
		Amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		GST_Included,
		PST_Included,
		PVRT_Included,
		GST_Exempt,
		PST_Exempt,
		PVRT_Exempt,
		Contract_Billing_Party_ID,
		Unit_Amount,
		Unit_Type,
		Quantity,
		Vehicle_Support_Incident_Seq,
		Charged_By,
		Charged_On,
		PVRT_Days,
		GST_Amount_Included,
		PST_Amount_Included,
		PVRT_Amount_Included,
		Business_Transaction_ID)
	VALUES	(
		@iCtrctNum,
		NULLIF(@ChargeItemType,	''),
		@iSeq,
		Convert(smallint, NULLIF(@SplitID, '')),
		Convert(smallint, NULLIF(@SalesAccessoryID, '')),
		Convert(smallint, NULLIF(@OptionalExtraID, '')),
		NULLIF(@ChargeType, ''),
		NULLIF(@ChargeItemDesc,	''),
		Convert(decimal(9,2), NULLIF(@Amount, '')),
		Convert(decimal(9,2), NULLIF(@GSTAmount, '')),
		Convert(decimal(9,2), NULLIF(@PSTAmount, '')),
		Convert(decimal(9,2), NULLIF(@PVRTAmount, '')),	
		Convert(bit, NULLIF(@GSTIncluded, '')),
		Convert(bit, NULLIF(@PSTIncluded, '')),	
		Convert(bit, NULLIF(@PVRTIncluded, '')),
		Convert(bit, NULLIF(@GSTExempt,	'')),
		Convert(bit, NULLIF(@PSTExempt,	'')),
		Convert(bit, NULLIF(@PVRTExempt, '')),
		Convert(int, NULLIF(@BillingPartyID, '')),
		Convert(decimal(9,3), NULLIF(@UnitAmount, '')),	
		NULLIF(@UnitType, ''),
		Convert(decimal(9,2), NULLIF(@Quantity,	'')),
		Convert(int, NULLIF(@VSISeq, '')),
		NULLIF(@ChargedBy, ''),
		@dtChargedOn,
		Convert(decimal(7,4), NULLIF(@PVRTDays,	'')),
		Convert(decimal(7,4), NULLIF(@GSTAmountIncl, '')),
		Convert(decimal(7,4), NULLIF(@PSTAmountIncl, '')),
		Convert(decimal(7,4), NULLIF(@PVRTAmountIncl, '')),
		Convert(int, NULLIF(@BusTrxID, ''))
		)
	RETURN @@ROWCOUNT











GO
