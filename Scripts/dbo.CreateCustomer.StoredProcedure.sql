USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCustomer]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.CreateCustomer    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.CreateCustomer    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCustomer    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCustomer    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Customer table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateCustomer]
	@LastName 	Varchar(25),

	@FirstName 	Varchar(25),
	@Address1 	Varchar(50),
	@Phone 		Varchar(35),
	@Licence 	Varchar(25),
	@BirthDate 	Varchar(11),
	@BCN 		Varchar(15),
	@OrgId 		Varchar(10),
	@Gender 	Char(1),	
	@DoNotRent 	Char(1),
	@Remarks 	Varchar(255),
	@Address2 	Varchar(50),
	@City 		Varchar(25),
	@Province 	Varchar(25),
	@PostalCode 	Varchar(10),
	@Country 	Varchar(25),
	@Email 		Varchar(50),
	@LicExpiry 	Varchar(11),
	@LicJuris 	Varchar(20),
	@PayMethod 	varchar(20),
	@VehClassName 	Varchar(20),
	@SmokingPref 	Char(1),
	@AddLdw 	Char(1),
	@AddPai 	Char(1),
	@AddPec 	Char(1),
	@UserName 	Varchar(20),
	@DriverLicenceClass	VarChar(20) = NULL,
	@Inactive		Char(1) = NULL,
	@CompanyName varchar(30)='',
	@CompanyPhone varchar(31)=''
AS
	/* 981019 - cpy - removed LicProv and LicCountry, added LicJuris */
	/* 990330 - np - added DriverLicenceClass */
	/* 990413 - cpy - added Inactive flag */
	/* 10/05/99 - @Licence varchar(15) -> varchar(25) */

DECLARE @NewCustId Int
DECLARE @VehClassCode Char(1)
DECLARE @dBirthDate datetime
DECLARE @dLicExpiry datetime
	SELECT 	@dBirthDate = Convert(datetime, NULLIF(@BirthDate,'')),
		@dLicExpiry = Convert(datetime, NULLIF(@LicExpiry,''))

	SELECT @VehClassCode = (SELECT Vehicle_Class_Code
				FROM   Vehicle_Class
				WHERE  Vehicle_Class_Name = @VehClassName)
	
	INSERT INTO Customer
		(Last_Name, First_Name,
		 Address_1, Address_2,
		 City, Province,
		 Postal_Code, Country,
		 Phone_Number, Email_Address, Birth_Date,
		 Gender, Driver_Licence_Number, Driver_Licence_Expiry,
		 Jurisdiction,
		 Program_Number, Payment_Method,
		 Do_Not_Rent, Remarks,
		 Vehicle_Class_Code,
		 Organization_ID,
		 Add_LDW,
		 Add_PAI,
		 Add_PEC,
		 Smoking_Non_Smoking, Inactive,
		 Last_Changed_By, Last_Changed_On,
		 Driver_Licence_Class,
		 Company_Name,
		 Company_Phone_Number)
	VALUES
		(NULLIF(@LastName,''), NULLIF(@FirstName,''),
		 NULLIF(@Address1,''), NULLIF(@Address2,''),
		 NULLIF(@City,''), NULLIF(@Province,''),
		 NULLIF(@PostalCode,''), NULLIF(@Country,''),
		 NULLIF(@Phone,''), NULLIF(@Email,''), @dBirthDate,
		 NULLIF(@Gender,''), 
         replace(replace(replace(Replace(NULLIF(@Licence,''), ' ',''),'-',''),'/',''),'*',''), @dLicExpiry,
		 NULLIF(@LicJuris,''),
		 NULLIF(@BCN,''), NULLIF(@PayMethod,''),
		 Convert(Bit, NULLIF(@DoNotRent,'')), NULLIF(@Remarks,''),
		 NULLIF(@VehClassCode,''),
		 Convert(Int, NULLIF(@OrgId,'')),
		 Convert(Bit, NULLIF(@AddLdw,'')),
		 Convert(Bit, NULLIF(@AddPai,'')),
		 Convert(Bit, NULLIF(@AddPec,'')),
		 NULLIF(@SmokingPref,''), ISNULL(NULLIF(@Inactive,''), 0),
		 NULLIF(@UserName,''), GetDate(),
		 NULLIF(@DriverLicenceClass, ''),
		 nullif(@CompanyName,''),
		 nullif(@CompanyPhone,''))
	SELECT @NewCustId = @@IDENTITY
	RETURN @NewCustId



GO
