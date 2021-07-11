USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContractChargeItem]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To insert a record into Contract_Charge_Item table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateContractChargeItem]
	@ContractNumber Varchar(20),
	@ChargeItemType	Varchar(1),
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
	@TicketNumber	Varchar(30),
	@Issuer         char(2),
	@IssuingDate	Varchar(24),
	@License_Number	Varchar(10),
	@Rental_Days	int = 0,
	
	@CFCIncluded 	Varchar(20)= 'False',
	@CFCDays Varchar(20)= '0',
	@CFCAmountIncl	Varchar(20)= '0'
  --QueryParam(43) = RateIncludesCFC
   -- QueryParam(44) = CFCDays
   -- QueryParam(45) = CFCAmountIncluded

AS
	/* 3/24/99 - cpy modified - changed convert @UnitAmount from decimal(9,2) to (9,3) */
	/* 4/28/99 - cpy modified - changed convert @Quantity from smallint to decimal(9,2) */
	-- Jun 22 1999 - Don K - Add business_transaction_id
	-- Jul 16 1999 - Don K - Use GETDATE() if @ChargedOn is not passed.

DECLARE @lastSeq SmallInt,
	@dtChargedOn datetime
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

If @PVRTIncluded = 'False'
	Select @PVRTIncluded = '0'
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

IF @ChargedOn = ''
	SELECT	@dtChargedOn = GETDATE()
ELSE
	SELECT	@dtChargedOn = CAST(@ChargedOn AS datetime)

	-- check for nulls
	-- for bit fields, default null values to '0'
	SELECT 	@ContractNumber = NULLIF(@ContractNumber, ""),
		@ChargeItemType	= NULLIF(@ChargeItemType, ""),
		@SalesAccessoryID = NULLIF(@SalesAccessoryID, ""),
		@OptionalExtraID = NULLIF(@OptionalExtraID, ""),
		@ChargeType 	= NULLIF(@ChargeType, ""),
		@ChargeItemDesc = NULLIF(@ChargeItemDesc, ""),
		@Amount 	= NULLIF(@Amount, ""),
		@GSTAmount 	= NULLIF(@GSTAmount, ""),
		@GSTExempt 	= ISNULL(NULLIF(@GSTExempt, ""), "0"),
		@GSTIncluded 	= ISNULL(NULLIF(@GSTIncluded, ""),"0"),
		@PSTAmount 	= NULLIF(@PSTAmount, ""),
		@PSTExempt 	= ISNULL(NULLIF(@PSTExempt, ""),"0"),
		@PSTIncluded 	= ISNULL(NULLIF(@PSTIncluded, ""),"0"),
		@PVRTAmount 	= NULLIF(@PVRTAmount, ""),
		@PVRTExempt 	= ISNULL(NULLIF(@PVRTExempt, ""),"0"),
		@PVRTIncluded 	= ISNULL(NULLIF(@PVRTIncluded, ""),"0"),

		@CRFIncluded 	= ISNULL(NULLIF(@CRFIncluded, ""),"0"),
		@VLFIncluded 	= ISNULL(NULLIF(@VLFIncluded, ""),"0"),
		@ERFIncluded 	= ISNULL(NULLIF(@ERFIncluded, ""),"0"),
		@CFCIncluded 	= ISNULL(NULLIF(@CFCIncluded, ""),"0"),

		@BillingPartyID = NULLIF(@BillingPartyID, ""),
		@UnitAmount 	= NULLIF(@UnitAmount, ""),
		@UnitType 	= NULLIF(@UnitType, ""),
		@Quantity 	= NULLIF(@Quantity, ""),
		@ChargedBy	= NULLIF(@ChargedBy, ""),
		@VSISeq		= NULLIF(@VSISeq, ""),
		@GSTAmountIncl	= NULLIF(@GSTAmountIncl, ""),
		@PSTAmountIncl	= NULLIF(@PSTAmountIncl, ""),
		@PVRTAmountIncl	= NULLIF(@PVRTAmountIncl, ""),

		@CRFAmountIncl	= NULLIF(@CRFAmountIncl, ""),
		@VLFAmountIncl	= NULLIF(@VLFAmountIncl, ""),
		@ERFAmountIncl	= NULLIF(@ERFAmountIncl, ""),
		@CFCAmountIncl	= NULLIF(@CFCAmountIncl, ""),

		@BusTrxID	= NULLIF(@BusTrxID, ""),
		@TicketNumber	= NULLIF(@TicketNumber, ""),
		@Issuer      	= NULLIF(@Issuer, ""),
		@IssuingDate	= NULLIF(@IssuingDate, ""),
		@License_Number	= NULLIF(@License_Number, "")
		

	-- get the current max sequence number
	SELECT 	@lastSeq = (	SELECT 	Max(Sequence)
				FROM	Contract_Charge_Item
				WHERE	Contract_Number =
					Convert(int, @ContractNumber))
	IF @lastSeq IS NULL
	BEGIN
		SELECT @lastSeq = -1
	END
	IF @SplitID = ''
	BEGIN
		SELECT @SplitID = Convert(varchar(20), @lastSeq)
	END
	INSERT INTO Contract_Charge_Item
		(Contract_Number,
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
		
		 CRF_Included,
		 VLF_Included,
		 ERF_Included,

		 GST_Exempt,
		 PST_Exempt,
		 PVRT_Exempt,
		 Contract_Billing_Party_ID,
		 Unit_Amount,
		 Unit_Type,
		 Quantity,
		 Charged_By,
		 Charged_On,
		 PVRT_Days,
		 
		 VLF_Days,
		 ERF_Days,
	  
		 Vehicle_Support_Incident_Seq,
		 GST_Amount_Included,
		 PST_Amount_Included,
		 PVRT_Amount_Included,

		 CRF_Amount_Included,
		 VLF_Amount_Included,
		 ERF_Amount_Included,

		 Business_Transaction_ID,
		 Ticket_Number,
		 Issuer,
		 Issuing_Date,
		 License_Number,
		 Manual_Qty_Copy,
		 CFC_Included,
		 CFC_Days,
		 CFC_Amount_Included		 	 
		 )

	VALUES
		(Convert(int,@ContractNumber),
		 @ChargeItemType,
		 @lastSeq + 1,
		 Convert(smallint, @SplitID),
		 Convert(smallint, @SalesAccessoryID),
		 Convert(smallint, @OptionalExtraID),
		 @ChargeType,
		 @ChargeItemDesc,
		 Convert(decimal(9,2), @Amount),
		 Convert(decimal(9,4), ISNULL(@GSTAmount, '0')),
		 Convert(decimal(9,4), ISNULL(@PSTAmount, '0')),
		 Convert(decimal(9,4), ISNULL(@PVRTAmount, '0')),
		 Convert(bit, @GSTIncluded),
		 Convert(bit, @PSTIncluded),
		 Convert(bit, @PVRTIncluded),

		 Convert(bit, @CRFIncluded),
		 Convert(bit, @VLFIncluded),
		 Convert(bit, @ERFIncluded),

		 Convert(bit, @GSTExempt),
		 Convert(bit, @PSTExempt),
		 Convert(bit, @PVRTExempt),
		 Convert(int, @BillingPartyID),
		 Convert(decimal(9,3), ISNULL(@UnitAmount, '0')),
		 @UnitType,
		 Convert(decimal(9,2), @Quantity),
		 @ChargedBy,
		 @dtChargedOn,

		 Convert(decimal(7,4), isnull(@PVRTDays,'0')),
		 Convert(decimal(7,4), isnull(@VLFDays,'0')),
		 Convert(decimal(7,4), isnull(@ERFDays,'0')),

		 Convert(int, @VSISeq),
		 Convert(decimal(7,4), isnull(@GSTAmountIncl,'0')),
		 Convert(decimal(7,4), isnull(@PSTAmountIncl,'0')),
		 Convert(decimal(7,4), isnull(@PVRTAmountIncl,'0')),

		 Convert(decimal(7,4), isnull(@CRFAmountIncl,'0')),
		 Convert(decimal(7,4), isnull(@VLFAmountIncl,'0')),
		 Convert(decimal(7,4), isnull(@ERFAmountIncl,'0')),

		 Convert(int, @BusTrxID),
		 @TicketNumber,
		 @Issuer,
		 Convert(Datetime,@IssuingDate),
		 @License_Number,
		 (Case When convert(decimal(9,2),isnull(@Quantity,'0'))= @Rental_Days Then 0
			 Else 1
		 End ),
		 Convert(bit, @CFCIncluded),
		 Convert(decimal(7,4), isnull(@CFCDays,'0')),
 	     Convert(decimal(7,4), isnull(@CFCAmountIncl,'0')) 
	   
 )
	RETURN @@ROWCOUNT




/****** Object:  StoredProcedure [dbo].[UpdateContractChargeItem]    Script Date: 07/20/2017 09:55:11 ******/
SET ANSI_NULLS OFF
GO
