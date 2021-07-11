USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateContract]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To update a record in Contract table .
MOD HISTORY:
Name    Date        Comments
*/
-- Don K - May 5 1999 -	Set Foreign_Contract_Number to NULL instead of blank
-- Roy H - OCT 28 2002 - fix y2k problem
-- 16 year later we have to modify the program ha ha

CREATE PROCEDURE [dbo].[UpdateContract]
	@ContractNum	Varchar(10),
	@ConfirmNum	Varchar(10),
	@CustId		Varchar(10),
	@RefOrgId	Varchar(10),
	@PULocId	Varchar(5),
	
	@PUDatetime	Varchar(24),
	@DOLocId	Varchar(5),
	@DODatetime	Varchar(24),
	@VehClassCode	Varchar(1),
	@LastName	Varchar(20),
	
	@FirstName	Varchar(20),
	@RenterDriving	Varchar(1),
	@BirthDate	Varchar(24),
	@Gender		Varchar(1),
	@Phone		Varchar(35),
	
	@Addr1		Varchar(50),
	@Addr2		Varchar(50),
	@City		Varchar(20),
	@Province	Varchar(20),
	@Country	Varchar(20),
	
	@PostalCode	Varchar(10),
	@FaxNumber	Varchar(35),
	@EmailAddr	Varchar(50),
	@SmokingPref	Varchar(1),
	@CompanyName	Varchar(30),
	
	@CompanyPhone	Varchar(35),
	@LocalPhone	Varchar(35),
	@LocalAddr1	Varchar(50),
	@LocalAddr2	Varchar(20),
	@LocalCity	Varchar(20),
	
	@DoNotExtendRental	Varchar(1),
	@DoNotExtendReason	Varchar(255),
	@RateId		Varchar(10),
	@RateAssignedDate	Varchar(24),
	@RateLevel	Varchar(1),

	@FlexDiscount	Varchar(7),
	@MemberDiscountId	Varchar(1),
	@FreqFlyerPlanId	Varchar(5),
	@PreAuthMethod	Varchar(20),
	@BCDOrgId	Varchar(10),
	
	@BCN		Varchar(10),
	@LDWDeclinedReason	Varchar(20),
	@LDWDeclinedDetails	Varchar(255),
	@IATANumber	Varchar(10),
	@RefEmployeeId	Varchar(5),
	
	@PrintComment	Varchar(255),
	@Copied		Varchar(1),
	@Status		Varchar(2),
	@ApplyViolationRate	Varchar(1),
	@SubVehClassCode	Varchar(1),
	
	@DoNotReplaceVeh	Varchar(1),
	@LastUpdateBy		Varchar(20),
	@LastUpdateDate		Varchar(24),
	@FFMemberNum		Varchar(20),
	@QuotedRateId		Varchar(10),
	
	@ForeignContractNumber	Varchar(20),
	@ContractCurrencyID	Varchar(10),
	@PercentageTax1		Varchar(10),
	@PercentageTax2		Varchar(10),
	@DailyTax		Varchar(10),
	
	@InterBranchBal		Varchar(10),
	@GSTExemptNum		Varchar(15),
	@PSTExemptNum		Varchar(15),
	@FFAssignedDate		VarChar(24),
	@OverrideMinimumAge	VarChar(1) = '0',
    @OptOut	VarChar(1) = '0',
	@FFSwiped		VarChar(1),
	@AMCouponCode		VarChar(25),
	@ArrivedThroughAP   		VarChar(1) = '0',
	@PVRTExemptNum		Varchar(15)=''
AS
	/* 4/09/99 - cpy bug fix - changed @DoNotExtendReason param length from	50 to 255 */
	/* 10/05/99 - @CompanyName varchar(20) -> varchar(30) 
			@EmailAddr varchar(35) -> varchar(50) 
			@LastName, @FirstName varchar(20) -> varchar(25) */

DECLARE	@iContractNum Int
DECLARE	@dRateAssignedDate Datetime
DECLARE @dTmpBirthdate DateTime
DECLARE @iLocalPickup smallint
DECLARE @bWizardDropOff bit
DECLARE @iWizardNumber int


SELECT	@iContractNum =	CONVERT(int, NULLIF(@ContractNum,'')),
		@dRateAssignedDate = Convert(Datetime, NULLIF(@RateAssignedDate,''))

If @OverrideMinimumAge = ''
	SELECT @OverrideMinimumAge = '0'
	
select @FFSwiped = NULLIF(@FFSwiped,'')

-- fix 2 digit birth date problem

select @dTmpBirthdate= Convert(Datetime, NULLIF(@BirthDate,''))

-- We don't this issue since we have upgrade to SQL 2000 and later
--if @dTmpBirthdate>'2000-01-01'
--        select @dTmpBirthdate=DATEADD(year,-100,@dTmpBirthdate)

UPDATE	Contract
SET	Confirmation_Number	= Convert(Int,NULLIF(@ConfirmNum,'')),
	Customer_ID		= Convert(Int, NULLIF(@CustId,'')),
	Referring_Organization_ID = Convert(Int, NULLIF(@RefOrgId,'')),
	Pick_Up_Location_ID	= Convert(SmallInt, NULLIF(@PULocId,'')),
	Pick_Up_On		= Convert(Datetime, NULLIF(@PUDatetime,'')),
	Drop_Off_Location_ID	= Convert(SmallInt, NULLIF(@DOLocId,'')),
	Drop_Off_On		= Convert(Datetime, NULLIF(@DODatetime,'')),
	Vehicle_Class_Code	= NULLIF(@VehClassCode,''),
	Last_Name	= NULLIF(@LastName,''),
	First_Name	= NULLIF(@FirstName,''),
	Renter_Driving	= Convert(Bit, @RenterDriving),
	Birth_Date	= @dTmpBirthdate,
	Gender		= NULLIF(@Gender,''),
	Phone_Number	= NULLIF(@Phone,''),
	Address_1	= NULLIF(@Addr1,''),
	Address_2	= NULLIF(@Addr2,''),
	City		= NULLIF(@City,''),
	Province_State	= NULLIF(@Province,''),
	Country		= NULLIF(@Country,''),
	Postal_Code	= NULLIF(@PostalCode,''),
	Fax_Number	= NULLIF(@FaxNumber,''),
	Email_Address	= NULLIF(@EmailAddr,''),
	Smoking_Non_Smoking	= NULLIF(@SmokingPref,''),
	Company_Name		= NULLIF(@CompanyName,''),
	Company_Phone_Number	= NULLIF(@CompanyPhone,''),
	Local_Phone_Number	= NULLIF(@LocalPhone,''),
	Local_Address_1		= NULLIF(@LocalAddr1,''),
	Local_Address_2		= NULLIF(@LocalAddr2,''),
	Local_City		= NULLIF(@LocalCity,''),
	Do_Not_Extend_Rental	= Convert(Bit, NULLIF(@DoNotExtendRental,'')),
	Do_Not_Extend_Reason	= NULLIF(@DoNotExtendReason,''),
	Rate_Id			= Convert(Int, NULLIF(@RateId,'')),
	Rate_Assigned_Date	= ISNULL(@dRateAssignedDate, Rate_Assigned_Date),
	Rate_Level		= NULLIF(@RateLevel,''),
	Flex_Discount		= Convert(Decimal(7,4),NULLIF(@FlexDiscount,'')),
	Member_Discount_ID	= NULLIF(@MemberDiscountId,''),
	Frequent_Flyer_Plan_ID	= CONVERT(smallint, NULLIF(@FreqFlyerPlanId,'')),
	Pre_Authorization_Method	= NULLIF(@PreAuthMethod,''),
	BCD_Rate_Organization_ID	= Convert(Int, NULLIF(@BCDOrgId,'')),
	Customer_Program_Number		= NULLIF(@BCN,''),
	LDW_Declined_Reason	= NULLIF(@LDWDeclinedReason,''),
	LDW_Declined_Details	= NULLIF(@LDWDeclinedDetails,''),
	IATA_Number		= NULLIF(@IATANumber,''),
	Referring_Employee_Id	= Convert(SmallInt, NULLIF(@RefEmployeeId,'')),
	Print_Comment		= NULLIF(@PrintComment,''),
	Copied			= Convert(Bit, NULLIF(@Copied,'')),
	Status			= NULLIF(@Status,''),
	Apply_Violation_Rate	= Convert(Bit, NULLIF(@ApplyViolationRate,'')),
	Sub_Vehicle_Class_Code	= NULLIF(@SubVehClassCode,''),
	FF_Member_Number	= NULLIF(@FFMemberNum,''),
	Last_Update_By		= NULLIF(@LastUpdateBy,''),
	Last_Update_On		= Convert(Datetime, NULLIF(@LastUpdateDate,'')),
	Quoted_Rate_Id		= Convert(Int, NULLIF(@QuotedRateId,'')),
	Foreign_Contract_Number	= NULLIF(@ForeignContractNumber,''),
	Contract_Currency_ID	= Convert(Smallint,NULLIF(@ContractCurrencyID, '')),
	Percentage_Tax1		= Convert(decimal(7,4),NULLIF(@PercentageTax1, '')),
	Percentage_Tax2		= Convert(decimal(7,4),NULLIF(@PercentageTax2, '')),
	Daily_Tax		= Convert(decimal(7,4),NULLIF(@DailyTax, '')),
	Interbranch_Balance	= Convert(Decimal(9,2),NULLIF(@InterBranchBal,'')),
	GST_Exempt_Num	= NULLIF(@GSTExemptNum,''),
	PST_Exempt_Num	= NULLIF(@PSTExemptNum,''),
	FF_Assigned_Date	= Convert(Datetime, NULLIF(@FFAssignedDate,'')),
	Override_Minimum_Age 	= Convert(Bit, @OverrideMinimumAge),
             Opt_out			=   Convert(Bit, @OptOut),
	FF_Swiped 		= Convert(Bit, @FFSwiped),
	AM_Coupon_Code		=NULLIF(@AMCouponCode,''),
	Arrived_Through_AP = Convert(Bit, @ArrivedThroughAP),
	PVRT_Exempt_Num	= NULLIF(@PVRTExemptNum,'')
	
	
WHERE	Contract_Number	= @iContractNum




Select @iLocalPickup= count(*) from location where Owning_Company_ID = (select code from lookup_table where category='BudgetBC Company') and Location_id= Convert(SmallInt, NULLIF(@PULocId,''))
	
SELECT @bWizardDropOff=dbo.Owning_Company.wizard_location
FROM  dbo.Owning_Company 
INNER JOIN dbo.Location  
		ON dbo.Owning_Company.Owning_Company_ID = dbo.Location.Owning_Company_ID
WHERE --(dbo.Owning_Company.Delete_Flag = 0) and Location.Delete_Flag = 0 And Location.Rental_location=1	And  
dbo.Location.Location_ID= Convert(SmallInt, NULLIF(@DOLocId,''))
-- If Pick up Locally and drop in wizard location 
if (@iLocalPickup>0 and @bWizardDropOff=1) and @ForeignContractNumber='' and (@Status='CO' or @Status='OP')
	Begin
		Update Wizard_RA_Numbers Set Contract_number=@iContractNum where Wizard_RA_Number =(select top 1 Wizard_RA_Number from Wizard_RA_Numbers where Contract_Number Is null or Contract_Number=@iContractNum)
		SELECT @iWizardNumber=Wizard_RA_Number from Wizard_RA_Numbers where contract_number=@iContractNum
		Update Contract SET Foreign_Contract_Number=@iWizardNumber where contract_number=@iContractNum
	End
			
RETURN @iContractNum

GO
