USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResvn]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateResvn    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateResvn    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResvn    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResvn    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: CreateResvn
PURPOSE: To create a reservation

AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Reservation
MOD HISTORY:
Name    Date        	Comments
Don K	Oct 23 1998 	Defaults new fields for Maestro
Don K	Nov 3 1998	Added params for new Maestro Fields
Dan M	Dec 7 1998	Added GuarDepAmount, CustCode, SwipedFlag
CPY     Jan 12 1999     Renamed phone number columns
Don K	Feb 4 1999	Convert blank to NULL for @IATA parameter
*/
CREATE PROCEDURE [dbo].[CreateResvn]
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
	@SpecComment 		Varchar(512),
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
DECLARE @dRateAssignedDate Datetime
DECLARE @randomNumber int
DECLARE @newForeignConfNum Varchar(20)

	SELECT	@ForeignConfirmNum = NULLIF(@ForeignConfirmNum, ''),
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
		@RateLevel = NULLIF(@RateLevel,''),
		@DiscountId = NULLIF(@DiscountId,''),
		@FlexDisc = NULLIF(@FlexDisc,''),
		@Status = NULLIF(@Status,''),
		@MarketingSrcId = NULLIF(@MarketingSrcId,''),
		@QuotedRateId = NULLIF(@QuotedRateId,''),
		@GuarDepAmount = NULLIF(@GuarDepAmount,''),
		@CustCode = NULLIF(@CustCode,''), 
		@EmailAddr = NULLIF(@EmailAddr,''),
		@CouponCode = NULLIF(@CouponCode,''),
		@CID = NULLIF(@CID,''),
		@RateCode = NULLIF(@RateCode,''),
		@ResBookingCity = NULLIF(@ResBookingCity,''),
		@TruckResType = NULLIF(@TruckResType,''),
		@ReservationRevenue = NULLIF(@ReservationRevenue,''),
		@FlatDisc = NULLIF(@FlatDisc,''),
		@CouponDescription = NULLIF(@CouponDescription,'')
		
	if @TruckResType is null
		Select @TruckResType='aroundtown'


	IF @RateAssignedDate = ''
		BEGIN
		IF @SourceCode != 'Maestro'
			SELECT @dRateAssignedDate = Getdate()
		END
	ELSE
		SELECT @dRateAssignedDate = Convert(Datetime, @RateAssignedDate)
	-- 980915 - cpy - added update_ctrl to insert (default to getdate())
	INSERT INTO Reservation
		(Foreign_Confirm_Number, Marketing_Source_ID,
		 Credit_Card_Type_ID, Drop_Off_Location_ID,
		 Pick_Up_Location_ID,
		 Vehicle_Class_Code, Pick_Up_On, Drop_Off_On,
		 Smoking_Non_Smoking, Flight_Number, IATA_Number,
		 First_Name, Last_Name, Contact_Phone_Number,
		 Business_Phone_Number, Payment_Method,
		 Deposit_Method, Flex_Discount, Special_Comments,
		 Customer_ID, Affiliated_BCD_Org_ID,
		 Referring_Employee_ID, Discount_ID, Rate_Level, Rate_ID,
		 Date_Rate_Assigned, Status, Cancellation_Reason,
		 Fax_Number, Fax_Confirmation, Deposit_Waived,
		 Maestro_Guarantee, Copied, Last_Changed_By, Last_Changed_On,
		 BCD_Rate_Org_ID, Referring_Org_ID, Program_Number,
		 Update_Ctrl,
		/* New Maestro fields */
		source_code,
		prepay_indicator,
		fastbreak_indicator,
		executive_action_indicator,
		applicant_status_indicator,
		perfect_drive_indicator,
		guaranteed_rate_indicator,
		company_name
		,bcd_number 
		, guarantee_credit_card_key,
		Quoted_Rate_Id,
		Guarantee_Deposit_Amount,
		Customer_Code,
		Swiped_Flag, 
		Email_Address,
        Coupon_Code,
		CID,
		Rate_Code,
		Res_Booking_City,
		Truck_Res_Type,
		Reservation_Revenue,
		Flat_Discount,
		Coupon_Description		
		)
	VALUES	(@ForeignConfirmNum, Convert(SmallInt, @MarketingSrcId),
		 @CCTypeId, Convert(SmallInt, @DOLocId),
		 Convert(SmallInt, @PULocId),
		 @VehClassCode, Convert(Datetime, @PUDatetime),
		 Convert(Datetime, @DODatetime),
		 @SmokingPref, @FlightNum, @IATA,
		 @FirstName, @LastName, @ContactPhone,
		 @BusPhone, @PayMethod,
		 @DepMethod, Convert(Decimal(7,4), @FlexDisc), @SpecComment,
		 Convert(Int, @CustId), Convert(Int, @OrgId),
		 Convert(SmallInt, @RefEmpId),
		 @DiscountId, @RateLevel, Convert(Int, @RateId),
		 @dRateAssignedDate, @Status, @CancelReason,
		 @FaxNumber, Convert(Bit, @FaxConf), Convert(Bit, @DepositWaived),
		 Convert(Bit, @MaestroGuarantee), Convert(Bit, @Copied),
		 @LastChangedBy, Convert(Datetime, @LastChangedOn),
		 Convert(Int, @BCDOrgId), Convert(Int, @RefOrgId), @BCN,
		 GetDate(),
		/* New Maestro Fields */
		NULLIF(@SourceCode, ''),
		CONVERT(bit, NULLIF(@PrepayInd, '')),
		CONVERT(bit, NULLIF(@FastBreakInd, '')),
		CONVERT(bit, NULLIF(@ExecInd, '')),
		CONVERT(bit, NULLIF(@ApplicantInd, '')),
		CONVERT(bit, NULLIF(@PerfDriveInd, '')),
		CONVERT(bit, NULLIF(@GuaRateInd, '')),
		NULLIF(@CompanyName, '')
		, NULLIF(@BCDNum, '') 
		, CONVERT(int, NULLIF(@GuaCCKey, '')),
		CONVERT(Int, @QuotedRateId),
		Convert(decimal(9,2), @GuarDepAmount),
		@CustCode,
		Convert(bit,@SwipedFlag), 
		@EmailAddr,
        @CouponCode,
		@CID,
		@RateCode,
		@ResBookingCity,
		@TruckResType,
		@ReservationRevenue,
		@FlatDisc,
		@CouponDescription 
		)
		
		
	if @SourceCode='Internet' and (@ForeignConfirmNum = '' or @ForeignConfirmNum is null)
         Begin
	    
			select @randomNumber= 1000+RAND( (DATEPART(mi, GETDATE()) * 600000 )+ (DATEPART(ss, GETDATE()) * 1000 )+ DATEPART(ms, GETDATE()) )*1000			
			select @newForeignConfNum = 'I'+ Right(Left(  convert(varchar ,@randomNumber),4),2)
				+convert(varchar(10),@@IDENTITY) +'VAN'

		--print @newForeignConfNum
		
		   
		--Update Reservation Set	 Maestro_Guarantee=1

		--WHERE ( Foreign_Confirm_Number LIKE 'i%') AND ( Status IN ('a')) and Source_Code='Internet'


 
 	
            exec UpdateResWithForeignConfNum @@IDENTITY, @newForeignConfNum
            -- fix the ggarantee flag here for now.  It can be fixed from the web in the future upload
            --Update Reservation Set	 Maestro_Guarantee=1
            --where   Foreign_Confirm_Number=	 @newForeignConfNum
        end 
     Else
        Begin
			select @randomNumber= 1000+RAND( (DATEPART(mi, GETDATE()) * 600000 )+ (DATEPART(ss, GETDATE()) * 1000 )+ DATEPART(ms, GETDATE()) )*1000			
			select @newForeignConfNum = 'G'+ Right(Left(  convert(varchar ,@randomNumber),4),2)
					+convert(varchar(10),@@IDENTITY) +'VAN'

			--print @newForeignConfNum
			
			   
			--Update Reservation Set	 Maestro_Guarantee=1

			--WHERE ( Foreign_Confirm_Number LIKE 'i%') AND ( Status IN ('a')) and Source_Code='Internet'


 
 	
            exec UpdateResWithForeignConfNum @@IDENTITY, @newForeignConfNum
            -- fix the ggarantee flag here for now.  It can be fixed from the web in the future upload
            --Update Reservation Set	 Maestro_Guarantee=1
            --where   Foreign_Confirm_Number=	 @newForeignConfNum
        End
         
		
	RETURN @@IDENTITY
GO
