USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVehicleRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[CreateVehicleRate]
@RateName varchar(25),
@PurposeID varchar(4),
@IncentiveUpsell char(1),
@FlexDiscountAllowed char(1),
@DiscountAllowed char(1),
@FrequentFlyerAllowed char(1),
@CommissionPaid char(1),
@ReferralFeePaid char(1),
@InsuranceTransferAllowed char(1),
@KmDropOffCharge char(1),
@WarrantyRepairRate char(1),
@ManufacturerID varchar(25),
@ContractComments varchar(255),
@OtherComments varchar(255),
@SpecialRestrictions varchar(255),
@RestrictionViolationRateName varchar(35),
@RestrictionLevel char(1),
@GST char(1),
@PST char(1),
@PRVT char(1),
@LocationSpecificFees char(1),
@FPOPurchased varchar(1),
@LicenseFee char(1),
@ERF char(1),
@CFC char(1),
@AmountMark varchar(25),
@ChangedBy varchar(25),
@CalendarDayRate char(1),
@UnderageCharge char(1)


AS
Declare @thisDate datetime
Declare @RestrictionViolationRateID int
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @thisDate = getDate()
Select @RestrictionViolationRateID = (Select Distinct Rate_ID from Vehicle_Rate
					where Rate_Name=@RestrictionViolationRateName
					And Termination_Date='Dec 31 2078 11:59PM')
	-- 981110 - cpy - added NULLIF check for special_restrictions
Insert Into Vehicle_Rate
	(Effective_Date,Termination_date,Rate_Name,Rate_Purpose_ID,Upsell,
	Flex_Discount_Allowed,Discount_Allowed,Frequent_Flyer_Plans_Honoured,
	Commission_Paid,Referral_Fee_Paid,Insurance_Transfer_Allowed,
	Km_Drop_Off_Charge,Warranty_Repair_Allowed,Manufacturer_ID,
	Contract_Remarks,Other_Remarks,Last_Changed_By,Last_Changed_On,
	Special_Restrictions,Violated_Rate_ID,Violated_Rate_Level,
	GST_Included,PST_Included,PVRT_Included,Location_Fee_Included,
	FPO_Purchased,License_Fee_Included,ERF_Included, CFC_Included, Amount_Markup,Calendar_Day_Rate,Underage_Charge)
Values
	(@thisDate,'Dec 31 2078 11:59PM',@RateName,Convert(smallint,@PurposeID),
	Convert(bit,@IncentiveUpsell),Convert(bit,@FlexDiscountAllowed),

	Convert(bit,@DiscountAllowed),Convert(bit,@FrequentFlyerAllowed),
	Convert(bit,@CommissionPaid),Convert(bit,@ReferralFeePaid),
	Convert(bit,@InsuranceTransferAllowed),Convert(bit,@KmDropOffCharge),
	Convert(bit,@WarrantyRepairRate),Convert(tinyint,NULLIF(@ManufacturerID, '')),
	@ContractComments,@OtherComments,@ChangedBy,
	@thisDate, NULLIF(@SpecialRestrictions,''),
	@RestrictionViolationRateID,@RestrictionLevel,
	Convert(bit,@GST),Convert(bit,@PST),Convert(bit,@PRVT),
	Convert(bit,@LocationSpecificFees), Convert(bit,@FPOPurchased),
	Convert(bit,@LicenseFee),Convert(bit,@ERF),Convert(bit,@CFC), Convert(decimal(9,2),NULLIF(@AmountMark,'')),Convert(bit,@CalendarDayRate),CONVERT(bit,@UnderageCharge))
	
Return @@IDENTITY

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

GO
