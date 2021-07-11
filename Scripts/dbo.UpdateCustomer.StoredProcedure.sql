USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomer]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.UpdateCustomer    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustomer    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustomer    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCustomer    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Customer table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateCustomer]
	@CustId 		Varchar(10),
	@LastName 		Varchar(25),
	@FirstName 		Varchar(25),
	@Address1 		Varchar(50),
	@Phone 		Varchar(35),
	@Licence 		Varchar(25),
	@BirthDate 		Varchar(11),
	@BCN 			Varchar(15),
	@OrgId 		Varchar(10),
	@Gender 		Char(1),	
	@DoNotRent 		Char(1),
	@Remarks 		Varchar(255),
	@Address2 		Varchar(50),
	@City 			Varchar(25),
	@Province 		Varchar(25),
	@PostalCode 		Varchar(10),
	@Country 		Varchar(25),
	@Email 			Varchar(50),
	@LicExpiry 		Varchar(11),
	@LicJuris 		Varchar(20),
	@PayMethod 		varchar(20),
	@VehClassName 	Varchar(20),
	@SmokingPref 		Char(1),
	@AddLdw 		Char(1),
	@AddPai		Char(1),
	@AddPec		Char(1),
      	@UserName		Varchar(20),
	@CalledFromCI		Char(1) = NULL,
	@DriverLicClass		Char(1) = NULL,
	@Inactive		Char(1) = NULL,
	@CompanyName Varchar(30)=null,
	@CompanyPhone Varchar(31)=null

AS
	/* 981019 - cpy - removed LicProv and LicCountry, added LicJuris */
	/* 990413 - cpy - added Inactive param */
	/* 10/05/99 - @Licence varchar(15) -> varchar(25) */


DECLARE @VehClassCode Char(1)
DECLARE @dBirthDate datetime
DECLARE @dLicExpiry datetime
DECLARE @iCustId Integer
	SELECT 	@dBirthDate = Convert(datetime, NULLIF(@BirthDate,'')),
		@dLicExpiry = Convert(datetime, NULLIF(@LicExpiry,'')),
		@iCustId = Convert(Int, NULLIF(@CustId, ''))
	SELECT @VehClassCode = (SELECT Vehicle_Class_Code
				FROM   Vehicle_Class
				WHERE  Vehicle_Class_Name = @VehClassName)
	/* If Called from Check In, only certain fields will be updated. */

    If @CalledFromCI = '1'
	UPDATE 	Customer

	SET    	Last_Name = NULLIF(@LastName,''),
		First_Name = NULLIF(@FirstName,''),
		Address_1 = NULLIF(@Address1,''),
		Address_2 = NULLIF(@Address2,''),
		City = NULLIF(@City,''),
		Province = NULLIF(@Province,''),
		Postal_Code = NULLIF(@PostalCode,''),
		Country = NULLIF(@Country,''),
		Phone_Number = NULLIF(@Phone,''),
		Email_Address = isnull(@Email,Email_Address),
		Birth_Date = @dBirthDate,
		Gender = NULLIF(@Gender,''),
		Driver_Licence_Number = Replace(NULLIF(@Licence,''),' ', ''),
		Driver_Licence_Expiry = @dLicExpiry,
		Jurisdiction = NULLIF(@LicJuris,''),
		Program_Number = @BCN,
		Payment_Method = NULLIF(@PayMethod,''),
--		Remarks = NULLIF(@Remarks,''),
	 	Vehicle_Class_Code = NULLIF(@VehClassCode,''),
--		Organization_ID = Convert(Int, NULLIF(@OrgId,'')),
		Add_LDW = Convert(Bit, NULLIF(@AddLdw,'')),
		Add_PAI = Convert(Bit, NULLIF(@AddPai,'')),	
		Add_PEC = Convert(Bit, NULLIF(@AddPec,'')),	
		Smoking_Non_Smoking = NULLIF(@SmokingPref,''),
		Driver_Licence_Class = CONVERT(Int, NULLIF(@DriverLicClass, '')),
		Inactive = ISNULL(NULLIF(@Inactive,''), Inactive),
		Last_Changed_By = NULLIF(@UserName,''),
	 	Last_Changed_On = GetDate(),
	 	Company_Name=@CompanyName ,
	 	Company_Phone_Number=@CompanyPhone 
	WHERE	Customer_Id = @iCustId
    Else
	UPDATE 	Customer

	SET    	Last_Name = NULLIF(@LastName,''),
		First_Name = NULLIF(@FirstName,''),
		Address_1 = NULLIF(@Address1,''),
		Address_2 = NULLIF(@Address2,''),
		City = NULLIF(@City,''),
		Province = NULLIF(@Province,''),
		Postal_Code = NULLIF(@PostalCode,''),
		Country = NULLIF(@Country,''),
		Phone_Number = NULLIF(@Phone,''),
		Email_Address = isnull(@Email,Email_Address),
		Birth_Date = @dBirthDate,
		Gender = NULLIF(@Gender,''),
		Driver_Licence_Number = NULLIF(@Licence,''),
		Driver_Licence_Expiry = @dLicExpiry,
		Jurisdiction = NULLIF(@LicJuris,''),
	--	Driver_Licence_Province = @LicProvince,

	--	Driver_Licence_Country = @LicCountry,
		Program_Number = @BCN,
		Payment_Method = NULLIF(@PayMethod,''),
		Do_Not_Rent = Convert(Bit, NULLIF(@DoNotRent,'')),
		Remarks = NULLIF(@Remarks,''),
	 	Vehicle_Class_Code = NULLIF(@VehClassCode,''),
		Organization_ID = Convert(Int, NULLIF(@OrgId,'')),
		Add_LDW = Convert(Bit, NULLIF(@AddLdw,'')),
		Add_PAI = Convert(Bit, NULLIF(@AddPai,'')),	
		Add_PEC = Convert(Bit, NULLIF(@AddPec,'')),	
		Smoking_Non_Smoking = NULLIF(@SmokingPref,''),
	--	Inactive = 0,
		Last_Changed_By = NULLIF(@UserName,''),
	 	Last_Changed_On = GetDate(),
	 	Company_Name=@CompanyName ,
	 	Company_Phone_Number =@CompanyPhone 
	WHERE	Customer_Id = @iCustId

	RETURN @iCustId

GO
