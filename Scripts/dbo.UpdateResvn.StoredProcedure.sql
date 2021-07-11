USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResvn]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: UpdateResvn
PURPOSE: To update a reservation

AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Reservation
MOD HISTORY:
Name    Date        	Comments
Don K	Nov 4 1998 	Added new fields for Maestro
Dan M	Dec 7 1998	Added GuarDepAmount, CustCode, SwipedFlag
CPY     Jan 12 1998     Renamed phone number columns
Don K	Feb 4 1999	Convert blank to NULL for @IATA parameter
Don K	Mar 10 2000	Delete quoted rate AFTER removing reference on reservation.
*/
CREATE PROCEDURE [dbo].[UpdateResvn]
	@ConfirmNum		Varchar(20),
	@ForeignConfirmNum 	Varchar(20),
	@BCN 			Varchar(15),
	@PULocId 		Varchar(5),
	@PUDatetime 		Varchar(17),
	@DODatetime 		Varchar(17),
	@DOLocId 		Varchar(5),
	@VehClassCode 		Varchar(1),
	@FlightNum 		Varchar(10),
	@SmokingPref 		Varchar(1),
	@CustId 		Varchar(10),
	@LastName 		Varchar(25),
	@FirstName 		Varchar(25),
	@ContactPhone 		Varchar(35),
	@BusPhone 		Varchar(35),
	@FaxNumber 		Varchar(35),
	@FaxConf 		Varchar(1),
	@PayMethod 		Varchar(20),
	@CCTypeId 		Varchar(3),
	@DepositWaived 		Varchar(1),
	@DepMethod 		Varchar(20),
	@BCDOrgId 		Varchar(10),
	@OrgId 			Varchar(10),
	@RefOrgId 		Varchar(10),
	@RefEmpId 		Varchar(15),
	@IATA 			Varchar(10),
	@RateId 		Varchar(10),
	@RateAssignedDate 	Varchar(24),
	@RateLevel 		Varchar(1),
	@DiscountId 		Varchar(1),
	@FlexDisc 		Varchar(7),
	@SpecComment 		Varchar(255),
	@LastChangedBy 		Varchar(20),
	@LastChangedOn 		Varchar(24),
	@MaestroGuarantee 	Varchar(1),
	@Copied 		Varchar(1),
	@Status 		Varchar(1),
	@CancelReason 		Varchar(255),
 	@MarketingSrcId 	Varchar(5),
	@SourceCode		varchar(10),
	@PrepayInd		varchar(1),
	@FastBreakInd		varchar(1),
	@ExecInd		varchar(1),
	@ApplicantInd		varchar(1),
	@PerfDriveInd		varchar(1),
	@GuaRateInd		varchar(1),
	@CompanyName		varchar(30),
	@BCDNum			varchar(10),
	@GuaCCKey		varchar(11),
	@QuotedRateId		Varchar(10),
	@GuarDepAmount		Varchar(10),
	@CustCode		Varchar(15),
	@SwipedFlag		Char(1), 
	@EmailAddr		Varchar(50),
    @CouponCode		Varchar(50),
	@CID		Varchar(50)='',
	@RateCode	Varchar(10)='',
	@ResBookingCity	Varchar(15)='',
	@TruckResType Varchar(20)='aroundtown',
	@ReservationRevenue Varchar(20)='',	
	@FlatDisc Varchar(10)='',
	@CouponDescription	Varchar(100)=''	

	
AS
DECLARE @iConfirmNum Int
DECLARE @oldQuotedRateID Int
	-- 980915 - cpy - added Update_Ctrl to update
	SELECT	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,'')),
		@ForeignConfirmNum = NULLIF(@ForeignConfirmNum, ''),
		@BCN  = NULLIF(@BCN, ''),
		@PULocId = NULLIF(@PULocId,''),
		@PUDatetime = NULLIF(@PUDatetime,''),
		@DODatetime = NULLIF(@DODatetime,''),
		@DOLocId = NULLIF(@DOLocId,''),
		@VehClassCode = NULLIF(@VehClassCode,''),
		@CustId = NULLIF(@CustId,''),
		@LastName = NULLIF(@LastName,''),
		@FirstName = NULLIF(@FirstName,''),
		@PayMethod = NULLIF(@PayMethod,''),
		@CCTypeId = NULLIF(@CCTypeId,''),
		@DepMethod = NULLIF(@DepMethod,''),
		@BCDOrgId = NULLIF(@BCDOrgId,''),
		@OrgId = NULLIF(@OrgId,''),
		@RefOrgId = NULLIF(@RefOrgId,''),
		@RefEmpId = NULLIF(@RefEmpId,''),
		@IATA = NULLIF(@IATA,''),
		@RateId = NULLIF(@RateId,''),
		@RateAssignedDate = NULLIF(@RateAssignedDate,''),
		@RateLevel = NULLIF(@RateLevel,''),
		@DiscountId = NULLIF(@DiscountId,''),
		@FlexDisc = NULLIF(@FlexDisc,''),
		@Status = NULLIF(@Status,''),
		@MarketingSrcId = NULLIF(@MarketingSrcId,''),
		@QuotedRateId = NULLIF(@QuotedRateId,''),
		@GuarDepAmount = NULLIF(@GuarDepAmount,''),
		@CustCode = NULLIF(@CustCode,''), 
		@EmailAddr = NULLIF(@EmailAddr,''),
		@CouponCode= NULLIF(@CouponCode,''),
		@CID = NULLIF(@CID,''),
		@RateCode = NULLIF(@RateCode,''),
		@ResBookingCity = NULLIF(@ResBookingCity,''),
		@TruckResType = NULLIF(@TruckResType,''),
		@ReservationRevenue =NULLIF(@ReservationRevenue,''),
		@FlatDisc = NULLIF(replace(@FlatDisc,'$',''),''),
		@CouponDescription = NULLIF(@CouponDescription,'')
		
		
if @TruckResType is null
	Select @TruckResType='aroundtown'

--temp fixed, need to fixed on frontend.
if @iConfirmNum<>'' 
	begin
		if @cid is null 
			select @CID=nullif(CID,'') from reservation where Confirmation_Number = @iConfirmNum
		if @RateCode is null 
			select @RateCode=nullif(Rate_Code,'') from reservation where Confirmation_Number = @iConfirmNum
		if @ResBookingCity is null
			select @ResBookingCity=nullif(Res_Booking_City,'') from reservation where Confirmation_Number = @iConfirmNum
		
	end

-- get the quoted rate currently attached to this reservation
Select @oldQuotedRateID =
	(Select
		Quoted_Rate_ID
	From
		Reservation
	Where
		Confirmation_Number = @iConfirmNum)

	-- update reservation record
	UPDATE 	Reservation
	SET 	Foreign_Confirm_Number = @ForeignConfirmNum,
		Marketing_Source_ID = Convert(SmallInt, @MarketingSrcId),
		Credit_Card_Type_ID = @CCTypeId,
		Drop_Off_Location_ID = Convert(SmallInt, @DOLocId),
		Pick_Up_Location_ID = Convert(SmallInt, @PULocId),
		Vehicle_Class_Code = @VehClassCode,
		Pick_Up_On = Convert(Datetime, @PUDatetime),
		Drop_Off_On = Convert(Datetime, @DODatetime),
		Smoking_Non_Smoking = @SmokingPref,
		Flight_Number = @FlightNum,
		IATA_Number = @IATA,
		First_Name = @FirstName,
		Last_Name = @LastName,
		Contact_Phone_Number = @ContactPhone,
		Business_Phone_Number = @BusPhone,
		Payment_Method = @PayMethod,
		Deposit_Method = @DepMethod,
		Flex_Discount = Convert(Decimal(7,4), @FlexDisc),
		Special_Comments = @SpecComment,
		Customer_ID = Convert(Int, @CustId),
		Affiliated_BCD_Org_ID = Convert(Int, @OrgId),
		Referring_Employee_ID = Convert(SmallInt, @RefEmpId),
		Discount_ID = @DiscountId,
		Rate_Level = @RateLevel,
		Rate_ID = Convert(Int, @RateId),
		Date_Rate_Assigned = Convert(Datetime, @RateAssignedDate),
		Status = @Status,
		Cancellation_Reason = @CancelReason,
		Fax_Number = @FaxNumber,
		Fax_Confirmation = Convert(Bit, @FaxConf),
		Deposit_Waived = Convert(Bit, @DepositWaived),
		Maestro_Guarantee = Convert(Bit, @MaestroGuarantee),
		Copied = Convert(Bit, @Copied),
		Last_Changed_By = @LastChangedBy,
		Last_Changed_On = Convert(Datetime, @LastChangedOn),
		BCD_Rate_Org_ID = Convert(Int, @BCDOrgId),
		Referring_Org_ID = Convert(Int, @RefOrgId),
		Program_Number = @BCN,
		Update_Ctrl = GetDate(),
		/* New Maestro fields */
		source_code = NULLIF(@SourceCode, ''),
		prepay_indicator = CONVERT(bit, NULLIF(@PrepayInd, '')),
		fastbreak_indicator = CONVERT(bit, NULLIF(@FastBreakInd, '')),
		executive_action_indicator = CONVERT(bit, NULLIF(@ExecInd, '')),
		applicant_status_indicator = CONVERT(bit, NULLIF(@ApplicantInd, '')),
		perfect_drive_indicator = CONVERT(bit, NULLIF(@PerfDriveInd, '')),
		guaranteed_rate_indicator = CONVERT(bit, NULLIF(@GuaRateInd, '')),
		company_name = NULLIF(@CompanyName, ''),
		bcd_number = NULLIF(@BCDNum, ''),
		guarantee_credit_card_key = CONVERT(int, NULLIF(@GuaCCKey, '')),
		Quoted_Rate_Id = Convert(Int, @QuotedRateId),
		Guarantee_Deposit_Amount = Convert(decimal(9,2),@GuarDepAmount),
		Customer_Code = @CustCode,
		Swiped_Flag = Convert(bit,@SwipedFlag), 
		Email_Address = @EmailAddr,
        Coupon_code=@CouponCode,
		CID=@CID,
		Rate_Code=@RateCode,
		Res_Booking_City=@ResBookingCity,
		Truck_Res_Type=@TruckResType,
		Reservation_Revenue=@ReservationRevenue,
		Flat_Discount=@FlatDisc,
		Coupon_Description=	@CouponDescription	
		 
		
	WHERE	Confirmation_Number = @iConfirmNum

-- check if this reservation is changing from using a quoted rate to a GIS rate
--If @oldQuotedRateID IS NOT NULL And @QuotedRateID IS NULL
--	-- then this reservation was previously saved with a quoted rate, so 
--	-- cleanup the old quoted rate data since it's not needed anymore
--	-- This can only be done when the reservation is no longer referencing it.
--	Begin
--		-- 2/25/99 - cpy bug fix - changed order of delete
--		Delete From Quoted_Rate_Category
--			Where Quoted_Rate_ID = @oldQuotedRateID
--
--		Delete From Quoted_Time_Period_Rate
--			Where Quoted_Rate_ID = @oldQuotedRateID
--
--		Delete From Quoted_Rate_Restriction
--			Where Quoted_Rate_ID = @oldQuotedRateID
--
--		Delete From Quoted_Included_Optional_Extra
--			Where Quoted_Rate_ID = @oldQuotedRateID
--
--		Delete From Quoted_Vehicle_Rate
--			Where Quoted_Rate_ID = @oldQuotedRateID
--
--	End


	RETURN @iConfirmNum

GO
