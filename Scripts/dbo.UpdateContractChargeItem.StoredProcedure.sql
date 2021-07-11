USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContractChargeItem]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: UpdateContractChargeItem
PURPOSE: To update the Contract_Charge_Item table. (Adapted from Create command)
AUTHOR: Don Kirkby
DATE CREATED: Apr 19, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
Don K	Apr 26 1999 Once a vehicle_support_incident_seq has been set, it cannot be changed.
Don K	Jun 22 1999 Add business_transaction_id
*/
CREATE PROCEDURE [dbo].[UpdateContractChargeItem]
	@ContractNumber Varchar(20),
	@ChargeItemType	Varchar(1),
	@Sequence	varchar(6),
	@SplitID	Varchar(20),
	@SalesAccessoryID Varchar(20),
	@OptionalExtraID Varchar(20),
	@ChargeType 	Varchar(35),
	@ChargeItemDesc Varchar(255),
	@Amount 	Varchar(20),
	@GSTAmount 	Varchar(20),
	@PSTAmount 	Varchar(20),
	@PVRTAmount 	Varchar(20),
	@GSTIncluded 	Varchar(20),
	@PSTIncluded 	Varchar(20),
	@PVRTIncluded 	Varchar(20),
	
    @CRFIncluded 	Varchar(20),
	@VLFIncluded 	Varchar(20),
	@ERFIncluded 	Varchar(20),

	@GSTExempt 	Varchar(20),
	@PSTExempt 	Varchar(20),
	@PVRTExempt 	Varchar(20),
	@BillingPartyID Varchar(20),
	@UnitAmount 	Varchar(20),
	@UnitType 	Varchar(20),
	@Quantity 	Varchar(20),
	@ChargedBy	Varchar(20),
	@ChargedOn	Varchar(24),
	@PVRTDays	Varchar(20),
	@VLFDays  Varchar(20),
	@ERFDays Varchar(20),

	@VSISeq		Varchar(20),
	@GSTAmountIncl	Varchar(20),
	@PSTAmountIncl	Varchar(20),
	@PVRTAmountIncl	Varchar(20),

	@CRFAmountIncl	Varchar(20),
	@VLFAmountIncl	Varchar(20),
	@ERFAmountIncl	Varchar(20),

	@BusTrxID	Varchar(11),
	@CFCIncluded 	Varchar(20)= 'False',
	@CFCDays Varchar(20)= '0',
	@CFCAmountIncl	Varchar(20)= '0'
AS
	/* 4/28/99 - cpy modified - changed convert @Quantity from smallint to decimal(9,2) */

DECLARE 	@nSequence SmallInt,
		@nSplitID smallint,
		@nContractNumber Integer
If @GSTIncluded = 'True'
	Select @GSTIncluded = '1'
If @GSTIncluded = 'False'
	Select @GSTIncluded = '0'
If @PSTIncluded = 'True'
	Select @PSTIncluded = '1'
If @PSTIncluded = 'False'
	Select @PSTIncluded = '0'
If @PVRTIncluded = 'True'
	Select @PVRTIncluded = '1'
If @PVRTIncluded = 'False'
	Select @PVRTIncluded = '0'

 
If @CRFIncluded = 'True'
	Select @CRFIncluded = '1'
If @CRFIncluded = 'False'
	Select @CRFIncluded = '0'
If @VLFIncluded = 'True'
	Select @VLFIncluded = '1'
If @VLFIncluded = 'False'
	Select @VLFIncluded = '0'
If @ERFIncluded = 'True'
	Select @ERFIncluded = '1'
If @ERFIncluded = 'False'
	Select @ERFIncluded = '0'
If @CFCIncluded = 'True'
	Select @CFCIncluded = '1'
If @CFCIncluded = 'False'
	Select @CFCIncluded = '0'

If @GSTExempt = 'True'
	Select @GSTExempt = '1'
If @GSTExempt = 'False'
	Select @GSTExempt = '0'
If @PSTExempt = 'True'
	Select @PSTExempt = '1'
If @PSTExempt = 'False'
	Select @PSTExempt = '0'
If @PVRTExempt = 'True'
	Select @PVRTExempt = '1'
If @PVRTExempt = 'False'
	Select @PVRTExempt = '0'
	-- check for nulls
	-- for bit fields, default null values to '0'
	SELECT 	@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, "")),
		@ChargeItemType	= NULLIF(@ChargeItemType, ""),
		@SalesAccessoryID = NULLIF(@SalesAccessoryID, ""),
		@OptionalExtraID = NULLIF(@OptionalExtraID, ""),
		@ChargeType 	= NULLIF(@ChargeType, ""),
		@ChargeItemDesc = NULLIF(@ChargeItemDesc, ""),
		@Amount 	= NULLIF(@Amount, ""),
		@GSTAmount 	= NULLIF(@GSTAmount, ""),
		@GSTExempt 	= ISNULL(NULLIF(@GSTExempt, ""), "0"),
		@GSTIncluded 	= ISNULL(NULLIF(@GSTIncluded, ""),"0"),


		@CRFIncluded 	= ISNULL(NULLIF(@CRFIncluded, ""),"0"),
		@VLFIncluded 	= ISNULL(NULLIF(@VLFIncluded, ""),"0"),
		@ERFIncluded 	= ISNULL(NULLIF(@ERFIncluded, ""),"0"),
		@CFCIncluded 	= ISNULL(NULLIF(@CFCIncluded, ""),"0"),

		@PSTAmount 	= NULLIF(@PSTAmount, ""),
		@PSTExempt 	= ISNULL(NULLIF(@PSTExempt, ""),"0"),
		@PSTIncluded 	= ISNULL(NULLIF(@PSTIncluded, ""),"0"),
		@PVRTAmount 	= NULLIF(@PVRTAmount, ""),
		@PVRTExempt 	= ISNULL(NULLIF(@PVRTExempt, ""),"0"),
		@PVRTIncluded 	= ISNULL(NULLIF(@PVRTIncluded, ""),"0"),
		@BillingPartyID = NULLIF(@BillingPartyID, ""),
		@UnitAmount 	= NULLIF(@UnitAmount, ""),
		@UnitType 	= NULLIF(@UnitType, ""),
		@Quantity 	= NULLIF(@Quantity, ""),
		@ChargedBy	= NULLIF(@ChargedBy, ""),
		@ChargedOn	= NULLIF(@ChargedOn, ""),
		@VSISeq		= NULLIF(@VSISeq, ""),
		@GSTAmountIncl	= NULLIF(@GSTAmountIncl, ""),
		@PSTAmountIncl	= NULLIF(@PSTAmountIncl, ""),
		@PVRTAmountIncl	= NULLIF(@PVRTAmountIncl, ""),

		@CRFAmountIncl	= NULLIF(@CRFAmountIncl, ""),
		@VLFAmountIncl	= NULLIF(@VLFAmountIncl, ""),
		@ERFAmountIncl	= NULLIF(@ERFAmountIncl, ""),
		@CFCAmountIncl	= NULLIF(@CFCAmountIncl, ""),

		@nSequence	= CAST(NULLIF(@Sequence, '') AS smallint),
		@nSplitID	= CAST(NULLIF(@SplitID, '') AS smallint),
		@BusTrxID	= NULLIF(@BusTrxID, "")

	UPDATE	Contract_Charge_Item
	   SET	Rental_Charge_Split_ID = Convert(smallint, @SplitID),
		Sales_Accessory_ID = Convert(smallint, @SalesAccessoryID),
		Optional_Extra_ID = Convert(smallint, @OptionalExtraID),
		Charge_Type = @ChargeType,
		Charge_description = @ChargeItemDesc,
		Amount = Convert(decimal(9,2), @Amount),
		GST_Amount = Convert(decimal(9,4), ISNULL(@GSTAmount, '0')),
		PST_Amount = Convert(decimal(9,4), ISNULL(@PSTAmount, '0')),
		PVRT_Amount = Convert(decimal(9,4), ISNULL(@PVRTAmount, '0')),
		GST_Included = Convert(bit, @GSTIncluded),
		PST_Included = Convert(bit, @PSTIncluded),
		PVRT_Included = Convert(bit, @PVRTIncluded),

		CRF_Included = Convert(bit, @CRFIncluded),
		VLF_Included = Convert(bit, @VLFIncluded),
		ERF_Included =Convert(bit, @ERFIncluded),

		GST_Exempt = Convert(bit, @GSTExempt),
		PST_Exempt = Convert(bit, @PSTExempt),
		PVRT_Exempt = Convert(bit, @PVRTExempt),
		Contract_Billing_Party_ID = Convert(int, @BillingPartyID),
		Unit_Amount = Convert(decimal(9,3), ISNULL(@UnitAmount, '0')),
		Unit_Type = @UnitType,
		Quantity = Convert(decimal(9,2), @Quantity),
		Charged_By = @ChargedBy,
		Charged_On = Convert(Datetime, @ChargedOn),
		PVRT_Days = Convert(decimal(7,4), @PVRTDays),

		VLF_Days =Convert(decimal(7,4), @VLFDays),
		ERF_Days = Convert(decimal(7,4), @ERFDays),

		-- Once VSISeq has been set, it can't be changed
		Vehicle_Support_Incident_Seq = ISNULL(Vehicle_Support_Incident_Seq, Convert(int, @VSISeq)),
		GST_Amount_Included = Convert(decimal(7,4), @GSTAmountIncl),
		PST_Amount_Included = Convert(decimal(7,4), @PSTAmountIncl),
		PVRT_Amount_Included = Convert(decimal(7,4), @PVRTAmountIncl),

		CRF_Amount_Included= Convert(decimal(7,4), @CRFAmountIncl),
		VLF_Amount_Included= Convert(decimal(7,4), @VLFAmountIncl),
		ERF_Amount_Included=Convert(decimal(7,4), @ERFAmountIncl),
		CFC_Included=Convert(bit, @CFCIncluded),
		CFC_Days=Convert(decimal(7,4), @CFCDays),
		CFC_Amount_Included = Convert(decimal(7,4), @CFCAmountIncl),  	 	 

		Business_Transaction_ID = Convert(int, @BusTrxID)
	 WHERE	Contract_Number = @nContractNumber
	   AND	Charge_Item_Type = @ChargeItemType
	   AND	Sequence = @nSequence
	RETURN @@ROWCOUNT



 
/****** Object:  StoredProcedure [dbo].[GetResRateInclusion]    Script Date: 07/14/2017 13:25:04 ******/
SET ANSI_NULLS ON
GO
