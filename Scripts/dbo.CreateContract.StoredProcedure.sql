USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateContract]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Contract table.
MOD HISTORY:
Name    Date        Comments
*/

-- Don K - May 5 1999 - Set Foreign_Contract_Number to NULL instead of blank
CREATE PROCEDURE [dbo].[CreateContract]
	@ConfirmNum 	Varchar(10),
	@CustId		Varchar(10),
	@RefOrgId 	Varchar(10),
	@PULocId 	Varchar(5),
	@PUDatetime 	Varchar(24),

	@DOLocId 	Varchar(5),
	@DODatetime 	Varchar(24),
	@VehClassCode 	Varchar(1),
	@LastName 	Varchar(25),
	@FirstName 	Varchar(25),
	
	@RenterDriving 	Varchar(1),
	@BirthDate 	Varchar(24),
	@Gender 	Varchar(1),
	@Phone 		Varchar(35),
	@Addr1 		Varchar(50),
	
	@Addr2 		Varchar(50),
	@City 		Varchar(20),
	@Province 	Varchar(20),
	@Country 	Varchar(20),
	@PostalCode 	Varchar(10),
	
	@FaxNumber 	Varchar(35),
	@EmailAddr 	Varchar(50),
	@SmokingPref 	Varchar(1),
	@CompanyName 	Varchar(30),
	@CompanyPhone 	Varchar(35),
	
	@LocalPhone 	Varchar(35),
	@LocalAddr1 	Varchar(50),
	@LocalAddr2 	Varchar(20),
	@LocalCity 	Varchar(20),
	@DoNotExtendRental 	Varchar(1),
	
	@DoNotExtendReason	Varchar(255),
	@RateId 	Varchar(10),
	@RateAssignedDate 	Varchar(24),
	@RateLevel 	Varchar(1),
	@FlexDiscount 	Varchar(7),
	
	@MemberDiscountId 	Varchar(1),
	@FreqFlyerPlanId 	Varchar(5),
	@PreAuthMethod	Varchar(20),
	@BCDOrgId 	Varchar(10),
	@BCN  		Varchar(10),
	
	@LDWDeclinedReason 	Varchar(20),
	@LDWDeclinedDetails 	Varchar(255),
	@IATANumber 	Varchar(10),
	@RefEmployeeId 	Varchar(5),
	@PrintComment 	Varchar(255),
	
	@Copied		Varchar(1),
	@Status		Varchar(2),
	@ApplyViolationRate 	Varchar(1),
	@SubVehClassCode 	Varchar(1),
	@DoNotReplaceVeh	Varchar(1),
	
	@LastUpdateBy 	Varchar(20),
	@LastUpdateDate Varchar(24),
	@FFMemberNum	Varchar(20),
	@QuotedRateId   Varchar(10),
	@ForeignContractNumber Varchar(20),
	
	@ContractCurrencyID 	Varchar(10),
	@PercentageTax1 	Varchar(10),
	@PercentageTax2		Varchar(10),
	@DailyTax		Varchar(10),
	@InterBranchBal		Varchar(10),
	
	@GSTExemptNum		Varchar(15),
	@PSTExemptNum		Varchar(15),
	@FFAssignedDate		VarChar(24),
	@OverrideMinimumAge	VarChar(1) = '0',
    @OptOut		VarChar(1) = '0',
	@FFSwiped		VarChar(1),
	@AMCouponCode		VarChar(25),
	@ArrivedThroughAP   		VarChar(1) = '0',
	@PVRTExemptNum		Varchar(15)=''

AS
	/* 4/09/99 - cpy bug fix - changed @DoNotExtendReason param length from 50 to 255 */
	/* 9/27/99 - np added FF Assigned Date */
	/* 10/05/99 - @CompanyName varchar(20) -> varchar(30) 
			@EmailAddr varchar(35) -> varchar(50) 
			@LastName, @FirstName varchar(20) -> varchar(25) */

	DECLARE @dRateAssignedDate Datetime
	DECLARE @iLocalPickup smallint
	DECLARE @bWizardDropOff bit
	DECLARE @iWizardNumber int
	SELECT @dRateAssignedDate = ISNULL(
			Convert(Datetime, NULLIF(@RateAssignedDate,'')),
			GetDate())
			
	select @FFSwiped = NULLIF(@FFSwiped,'')
	
	If @OverrideMinimumAge = ''
		SELECT @OverrideMinimumAge = '0'

	INSERT INTO Contract
		(Confirmation_Number,
		 Customer_ID,
		 Referring_Organization_ID,
		 Pick_Up_Location_ID,
		 Pick_Up_On,
		 Drop_Off_Location_ID,
		 Drop_Off_On,
		 Vehicle_Class_Code,
		 Last_Name, First_Name,
		 Renter_Driving,
		 Birth_Date,
		 Gender, Phone_Number,
		 Address_1, Address_2,
		 City, Province_State,
		 Country, Postal_Code,
		 Fax_Number, Email_Address,
		 Smoking_Non_Smoking, Company_Name,
		 Company_Phone_Number, Local_Phone_Number,
		 Local_Address_1, Local_Address_2,
		 Local_City,
		 Do_Not_Extend_Rental,
		 Do_Not_Extend_Reason,
		 Rate_Id,
		 Rate_Assigned_Date,
		 Rate_Level,
		 Flex_Discount,
		 Member_Discount_ID,
		 Frequent_Flyer_Plan_ID,
		 Pre_Authorization_Method,
		 BCD_Rate_Organization_ID,
		 Customer_Program_Number,
		 LDW_Declined_Reason, LDW_Declined_Details,
		 IATA_Number,
		 Referring_Employee_Id,
		 Print_Comment,
		 Copied,
		 Status,
		 Apply_Violation_Rate,
		 Sub_Vehicle_Class_Code,
		 FF_Member_Number,
		 Last_Update_By,
		 Last_Update_On,
		 Quoted_Rate_Id,
		 Foreign_Contract_Number,
		 Contract_Currency_ID,
		 Percentage_Tax1,
		 Percentage_Tax2,
		 Daily_Tax,
		 Interbranch_Balance,
		 GST_Exempt_Num,
		 PST_Exempt_Num,
		FF_Assigned_Date,
		Override_Minimum_Age,
		Opt_out,
		FF_Swiped,
		AM_Coupon_Code,
		Arrived_Through_AP,
		PVRT_Exempt_Num
		)
	VALUES 	(Convert(Int, NULLIF(@ConfirmNum,'')),
		 Convert(Int, NULLIF(@CustId,'')),
		 Convert(Int, NULLIF(@RefOrgId,'')),
		 Convert(SmallInt, NULLIF(@PULocId,'')),
		 Convert(Datetime, NULLIF(@PUDatetime,'')),
		 Convert(SmallInt, NULLIF(@DOLocId,'')),
		 Convert(Datetime, NULLIF(@DODatetime,'')),
		 NULLIF(@VehClassCode,''),
		 NULLIF(@LastName,''), NULLIF(@FirstName,''),
		 Convert(Bit, @RenterDriving),
		 Convert(Datetime, NULLIF(@BirthDate,'')),
		 NULLIF(@Gender,''), NULLIF(@Phone,''),
		 NULLIF(@Addr1,''), NULLIF(@Addr2,''),
		 NULLIF(@City,''), NULLIF(@Province,''),
		 NULLIF(@Country,''), NULLIF(@PostalCode,''),
		 NULLIF(@FaxNumber,''), NULLIF(@EmailAddr,''),
		 NULLIF(@SmokingPref,''), NULLIF(@CompanyName,''),
		 NULLIF(@CompanyPhone,''), NULLIF(@LocalPhone,''),
		 NULLIF(@LocalAddr1,''), NULLIF(@LocalAddr2,''),
		 NULLIF(@LocalCity,''),
		 Convert(Bit, NULLIF(@DoNotExtendRental,'')),
		 NULLIF(@DoNotExtendReason,''),
		 Convert(Int, NULLIF(@RateId,'')),
		 @dRateAssignedDate,
		 NULLIF(@RateLevel,''),
		 Convert(Decimal(7,4), NULLIF(@FlexDiscount,'')),
		 NULLIF(@MemberDiscountId,''),
		 Convert(SmallInt, NULLIF(@FreqFlyerPlanId ,'')),
		 NULLIF(@PreAuthMethod,''),
		 Convert(Int, NULLIF(@BCDOrgId,'')),
		 NULLIF(@BCN,''),
		 NULLIF(@LDWDeclinedReason,''), NULLIF(@LDWDeclinedDetails,''),
		 NULLIF(@IATANumber,''),
		 Convert(SmallInt, NULLIF(@RefEmployeeId,'')),
		 NULLIF(@PrintComment,''),
		 Convert(Bit, NULLIF(@Copied,'')),
		 NULLIF(@Status,''),
		 Convert(Bit, NULLIF(@ApplyViolationRate,'')),
		 NULLIF(@SubVehClassCode,''),
		 NULLIF(@FFMemberNum,''),
		 NULLIF(@LastUpdateBy,''),
		 Convert(Datetime, NULLIF(@LastUpdateDate,'')),
		 Convert(Int, NULLIF(@QuotedRateId, '')),
		 NULLIF(@ForeignContractNumber, ''),
		 Convert(Smallint,NULLIF(@ContractCurrencyID, '')),
		 Convert(decimal(7,4),NULLIF(@PercentageTax1, '')),
		 Convert(decimal(7,4),NULLIF(@PercentageTax2, '')),
		 Convert(decimal(7,4),NULLIF(@DailyTax, '')),
		 Convert(Decimal(9,2),NULLIF(@InterBranchBal,'')),
		 NULLIF(@GSTExemptNum,''),
		 NULLIF(@PSTExemptNum,''),
		Convert(Datetime, NULLIF(@FFAssignedDate,'')),
		Convert(Bit, @OverrideMinimumAge),
		Convert(Bit, @OptOut),
		Convert(Bit, @FFSwiped),
 		NULLIF(@AMCouponCode,''),
 		Convert(Bit, @ArrivedThroughAP),
 		NULLIF(@PVRTExemptNum,'')
 		 
		)
			 
		Select @iLocalPickup= count(*) from location where Owning_Company_ID = (select code from lookup_table where category='BudgetBC Company') and Location_id= Convert(SmallInt, NULLIF(@PULocId,''))
		
		SELECT @bWizardDropOff=dbo.Owning_Company.wizard_location
		FROM  dbo.Owning_Company 
		INNER JOIN dbo.Location  
				ON dbo.Owning_Company.Owning_Company_ID = dbo.Location.Owning_Company_ID
		WHERE --(dbo.Owning_Company.Delete_Flag = 0) and Location.Delete_Flag = 0 And Location.Rental_location=1	And  
		dbo.Location.Location_ID= Convert(SmallInt, NULLIF(@DOLocId,''))
		-- If Pick up Locally and drop in wizard location 
		if (@iLocalPickup>0 and @bWizardDropOff=1)
			Begin
				Update Wizard_RA_Numbers Set Contract_number=@@IDENTITY where Wizard_RA_Number =(select top 1 Wizard_RA_Number from Wizard_RA_Numbers where Contract_Number Is null)
				SELECT @iWizardNumber=Wizard_RA_Number from Wizard_RA_Numbers where contract_number=@@IDENTITY
				Update Contract SET Foreign_Contract_Number=@iWizardNumber where contract_number=@@IDENTITY
			End
		
	RETURN @@IDENTITY
	
	
	--select * from contract where contract_number=1860181
	
	--select * from Wizard_RA_Numbers where Wizard_RA_Number=(select top 1 Wizard_RA_Number from Wizard_RA_Numbers)
GO
