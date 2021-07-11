USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocation]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateLocation    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocation    Script Date: 2/16/99 2:05:39 PM ******/
/*
PURPOSE: To insert a record into Location table.
MOD HISTORY:
Name    Date       	 Comments
NP	Jan/11/2000	Add Last_Updated_By and Last_Updated_On
NP	Jan/18/2000	Add TruckInv_Last_Updated_By and Last_Updated_On
*/

CREATE PROCEDURE [dbo].[CreateLocation]
	@LocationID			VarChar(10),
	@LocationName		VarChar(25),
	@OwningCompanyID		VarChar(10),
	@Manager			VarChar(25),
	@CorporateID			VarChar(10),
	@HubMember			VarChar(25),
	@RentalLocation		VarChar(1),
	@ResNet			VarChar(1),
        	@GISMember			VarChar(1),
        	@GracePeriod			VarChar(10),
        	@FuelPrice			VarChar(10),
        	@DieselFuelPrice		VarChar(10),
        	@FPOFuelPrice			VarChar(10),
        	@FPODieselFuelPrice		VarChar(10),
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
        	@PhoneNumber			VarChar(35),
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
	@AccountSegement    VarChar(15),
	@LocationDisplayName VarChar(50),
	@HoursEmailDisplay   VarChar(100),
    @Payment_Processing  varchar(1)
AS
	/* 6/10/99 - added MnemonicCode to param list and to insert */

	Declare @FlatFee 		Decimal(7,2)
	Declare @PercentageFee		Decimal(5,2)
	
	Declare @LicenseFeePerDay 	Decimal(7,2)
	Declare @LicenseFeeFlat 	Decimal(7,2)
	Declare @LicenseFeePercentage	Decimal(5,2)

	Declare @NewLocationID		SmallInt
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

	INSERT INTO Location
	  (	Location,
		Owning_Company_Id,
		Hub_ID,
		Address_1,
		Address_2,
		City,
		Province,
		Postal_Code,
		Fax_Number,
		Phone_Number,
		Grace_Period,
		Manager,
		Remarks,
		Address_Description,
		Hours_Of_Service_Description,
		Corporate_Location_ID,
		Percentage_Fee,
		Flat_Fee,
                LicenseFeeFlat,                           
		LicenseFeePerDay,                       
		LicenseFeePercentage,                
		Rental_Location,
		ResNet,
		GIS_Member,
		Fuel_Price_Per_Liter,
		Fuel_Price_Per_Liter_Diesel,
		FPO_Fuel_Price_Per_Liter,
		FPO_Fuel_Price_Per_Liter_Dsel,
		Default_Unauthorized_Charge,
		Delete_Flag,
		Mnemonic_Code,
		StationNumber,
		CounterCode,
		GDSCode,
		DBRCode,
		IB_Zone,
		BroadcastMssg,
		AllowResForOther,
		Last_Updated_By,
		Last_Updated_On, 
		TruckInv_Last_Updated_By,
		TruckInv_Last_Updated_On,
		Acctg_Segment,
		LocationName,
		Email_Hour_Description,
		Payment_Processing
	  )
	VALUES
	  (	@LocationName,
		CONVERT(SmallInt, @OwningCompanyID),
		@HubMember,
		@Address1,
		@Address2,
		@City,
		@Province,
		@PostalCode,
		@FaxNumber,
		@PhoneNumber,
		CONVERT(SmallInt, NULLIF(@GracePeriod, '')),
		@Manager,
		@Comments,
		@AddressDescription,
		@HoursDescription,
		CONVERT(SmallInt, @CorporateID),
		@PercentageFee,
		@FlatFee,
		@LicenseFeeFlat,
		@LicenseFeePerDay,
		@LicenseFeePercentage,
		CONVERT(Bit, @RentalLocation),
		CONVERT(Bit, @ResNet),
		CONVERT(Bit, @GISMember),
		CONVERT(Decimal(7, 4), @FuelPrice),
		CONVERT(Decimal(7, 4), @DieselFuelPrice),
		CONVERT(Decimal(7, 4), @FPOFuelPrice),
		CONVERT(Decimal(7, 4), @FPODieselFuelPrice),
		CONVERT(Decimal(7,2), @DefaultUnauthorizedCharge),
		CONVERT(Bit, 0),
		NULLIF(@MnemonicCode,''),
		NULLIF(@StationNumber,''),
		NULLIF(@CounterCode,''),
		NULLIF(@GDSCode,''),
		NULLIF(@DBRCode,''),
		NULLIF(@IBZone,''),

		@BroadcastMssg,
		@AllowResForOther,
		@LastUpdatedBy,
		GetDate(),
		@LastUpdatedBy,
		GetDate(),
		NULLIF(@AccountSegement,''),
		NULLIF(@LocationDisplayName,''),
		NULLIF(@HoursEmailDisplay,''),
		@Payment_Processing
	  )
	Select @NewLocationID = @@IDENTITY
Return @NewLocationID
GO
