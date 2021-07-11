USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocation]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdLocation    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocation    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocation    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocation    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Location table .
MOD HISTORY:
Name    Date        	Comments
NP	Jan/11/2000	Add Last_Updated_By and Last_Updated_On
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLocation]
@LocationID	 		VarChar(10),	
@LocationName 		VarChar(25),	
@OwningCompanyID		VarChar(10), 
@Manager	  		VarChar(25),	
@CorporateID 			VarChar(10),
@HubMember	  		VarChar(25),	
@RentalLocation		VarChar(1),
@ResNet  			VarChar(1),        
@GISMember			VarChar(1),
@GracePeriod	   		VarChar(10),        
@FuelPrice			VarChar(10),
@DieselFuelPrice	   	VarChar(10),        
@FPOFuelPrice			VarChar(10),
@FPODieselFuelPrice 		VarChar(10),        
@FeeType			VarChar(10),
@FeeAmount			VarChar(10),	
@LicenseFeeType		VarChar(10),
@LicenseFeeAmount		VarChar(10),        
@Comments			VarChar(255),
@Address1			VarChar(50),        
@Address2			VarChar(50),
@City				VarChar(25),  	
@Province			VarChar(25),
@PostalCode			VarChar(10),       
 @PhoneNumber		VarChar(35),
@FaxNumber			VarChar(35),        
@AddressDescription		VarChar(100),
@HoursDescription		VarChar(100),        
@DefaultUnauthorizedCharge	VarChar(10),
@MnemonicCode		VarChar(4),
@StationNumber		Varchar(10),
@CounterCode		Varchar(10),
@GDSCode			Varchar(10),
@DBRCode			Varchar(20),
@IBZone				Varchar(10),
@BroadcastMssg		VarChar(800),
@AllowResForOther		VarChar(1),	
@LastUpdatedBy		VarChar(20),
@AccountSegment    VarChar(15),
@LocationDisplayName VarChar(50),
@HoursEmailDisplay   VarChar(100),
@Payment_Processing  varchar(1)
AS
	/* 2/17/99 - bug fix - put NULLIF check on Grace Period before saving */
	/* 6/10/99 - UAT#286 - added MnemonicCode to param list and to update */


	Declare @FlatFee 		Decimal(7,2)
	Declare @PercentageFee		Decimal(5,2)

	Declare @LicenseFeePerDay 		Decimal(7,2)
	Declare @LicenseFeeFlat 		Decimal(7,2)
	Declare @LicenseFeePercentage	Decimal(5,2)

	Declare	@nLocationID SmallInt

	Select		@nLocationID = CONVERT(SmallInt, @LocationID)

	/*
	Set blank to Null for the values will be converted to numeric
	*/	
	If @CorporateID = ''
		Select @CorporateID = NULL
	If @HubMember = ''
		Select @HubMember = NULL
	If @FuelPrice = ''
		Select @FuelPrice = NULL
	If @DieselFuelPrice = ''
		Select @DieselFuelPrice = NULL
	If @FPOFuelPrice = ''
		Select @FPOFuelPrice = NULL
	If @FPODieselFuelPrice = ''
		Select @FPODieselFuelPrice = NULL
	If @FeeAmount = ''
		Select @FeeAmount = NULL
	if @LicenseFeeAmount=''
		Select @LicenseFeeAmount = NULL
	If @DefaultUnauthorizedCharge = ''
		Select @DefaultUnauthorizedCharge = NULL
	/*
	Assign the Amountfee to Flat or Percentage based on the FeeType
	*/
	If @FeeType = 'Flat'
	  BEGIN
		Select @FlatFee = CONVERT(Decimal(7, 2), @FeeAmount)
		Select @PercentageFee = NULL
	  END
	Else
	  BEGIN
		Select @FlatFee = NULL
		Select @PercentageFee = CONVERT(Decimal(5, 2), @FeeAmount)
	  END

	If @LicenseFeeType = 'PerDay'
		BEGIN
			Select @LicenseFeePerDay = CONVERT(Decimal(7, 2), @LicenseFeeAmount)
			Select @LicenseFeePercentage = NULL
			Select @LicenseFeeFlat=NULL
	  	END
	Else
	  	BEGIN
                          		if @LicenseFeeType = 'Flat'
				BEGIN
					Select @LicenseFeeFlat= CONVERT(Decimal(7, 2), @LicenseFeeAmount)
					Select @LicenseFeePercentage = NULL					
					Select @LicenseFeePerDay = NULL
				END
			else
				BEGIN
					Select @LicenseFeePercentage =  CONVERT(Decimal(5, 2), @LicenseFeeAmount)
					Select @LicenseFeeFlat= NULL					
					Select @LicenseFeePerDay = NULL	
				END 	
	  END

	UPDATE	Location
	SET	Location			= @LocationName,
		Owning_Company_Id 		= CONVERT(SmallInt, @OwningCompanyID),

		Hub_ID				= @HubMember,
		Address_1			= @Address1,
		Address_2			= @Address2,
		City				= @City,
		Province			= @Province,
		Postal_Code			= @PostalCode,

		Fax_Number			= @FaxNumber,
		Phone_Number			= @PhoneNumber,
		Grace_Period			= CONVERT(SmallInt, NULLIF(@GracePeriod,'')),
		Manager				= @Manager,
		Remarks				= @Comments,
		Address_Description		= @AddressDescription,
		Hours_Of_Service_Description	= @HoursDescription,
		Corporate_Location_ID		= CONVERT(SmallInt, @CorporateID),
		Percentage_Fee			= @PercentageFee,
		Flat_Fee			= @FlatFee,
		LicenseFeeFlat                             = @LicenseFeeFlat,
		LicenseFeePerDay                       = @LicenseFeePerDay,
		LicenseFeePercentage                = @LicenseFeePercentage,
		Rental_Location			= CONVERT(Bit, @RentalLocation),
		ResNet				= CONVERT(Bit, @ResNet),
		GIS_Member			= CONVERT(Bit, @GISMember),
		Fuel_Price_Per_Liter	 	= CONVERT(Decimal(7, 4), @FuelPrice),
		Fuel_Price_Per_Liter_Diesel 	= CONVERT(Decimal(7, 4), @DieselFuelPrice),
		FPO_Fuel_Price_Per_Liter	= CONVERT(Decimal(7, 4), @FPOFuelPrice),
		FPO_Fuel_Price_Per_Liter_Dsel 	= CONVERT(Decimal(7, 4), @FPODieselFuelPrice),
		Default_Unauthorized_Charge 	= CONVERT(Decimal(7, 2), @DefaultUnauthorizedCharge),
		Mnemonic_Code			= NULLIF(@MnemonicCode,''),
		StationNumber=NULLIF(@StationNumber,''),
		CounterCode=NULLIF(@CounterCode,''),
		GDSCode=NULLIF(@GDSCode,''),
		DBRCode=NULLIF(@DBRCode,''),
		IB_Zone=NULLIF(@IBZone,''),
		BroadcastMssg 			= NULLIF(@BroadcastMssg,''),
		AllowResForOther		= NULLIF(@AllowResForOther,''),
		Acctg_Segment           = NULLIF(@AccountSegment,''),
		LocationName            = NULLIF(@LocationDisplayName,''),
		Email_Hour_Description  = NULLIF(@HoursEmailDisplay,''),
		Payment_Processing      = NULLIF(@Payment_Processing,''),
		Last_Updated_By			= @LastUpdatedBy,
		Last_Updated_On			= GetDate()
		
	WHERE	Location_ID	= @nLocationID
Return 1
GO
