USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOwningCompany]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.CreateOwningCompany    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreateOwningCompany    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOwningCompany    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOwningCompany    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Owning_Company table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOwningCompany]
   	@OwningCompanyID		VarChar(10),
	@Name				VarChar(50),
	@Address1			VarChar(50),
	@Address2			VarChar(50),
	@City				VarChar(25),
	@Province			VarChar(25),
	@Country			VarChar(25),
	@PostalCode			VarChar(10),
	@Zone				VarChar(2),
	@PhoneNumber			VarChar(35),
	@FaxNumber			VarChar(35),
	@ContactName			VarChar(25),
	@ContactPosition		VarChar(25),
	@ContactPhoneNumber		VarChar(35),
	@ContactEmailAddress		VarChar(50),
	@APCurrencyID			VarChar(10),
	@APInterbranchAccount		VarChar(25),
	@ARInterbranchCANAccount	VarChar(25),
	@ARInterbranchUSAccount		VarChar(25),
	@Remarks			VarChar(255),
	@LastUpdateBy			VarChar(20),
	@VendorCode             varchar(12),
	@CustomerCode           varchar(12),
	@IBZone					varchar(10),
	@ResnetCharge           varchar(12),
	@SystemID				varchar(10)
AS
	/* 7/22/99 - changed Remarks param length from 25 to 255 */

	select @ResnetCharge=nullif(@ResnetCharge,'0')
	if @ResnetCharge='' 
		 select @ResnetCharge='0'

	INSERT INTO Owning_Company

	(	Owning_Company_ID,
		Name,
		Address1,
		Address2,
		City,
		Province,
		Country,
		Postal_Code,
		Zone,
		Phone_Number,
		Fax_Number,
		Contact_Name,
		Contact_Position,
		Contact_Phone_Number,
		Contact_Email_Address,
		AP_Currency_ID,
		AP_Interbranch_Account,
		AR_Interbranch_CAN_Account,
		AR_Interbranch_US_Account,
		Remarks,
		Last_Update_By,
		Last_Update_On,
		Delete_Flag,
		Vendor_Code,
		Customer_Code,
		IB_Zone,
		Resnet_Charge,
		System_ID
	)
	VALUES
	(	CONVERT(SmallInt,@OwningCompanyID),
		@Name,
		@Address1,
		@Address2,
		@City,
		@Province,
		@Country,
		@PostalCode,
		@Zone,
		@PhoneNumber,
		@FaxNumber,
		@ContactName,
		@ContactPosition,
		@ContactPhoneNumber,
		@ContactEmailAddress,
		CONVERT(TinyInt, @APCurrencyID),
		@APInterbranchAccount,
		@ARInterbranchCANAccount,
		@ARInterbranchUSAccount,
		@Remarks,
		@LastUpdateBy,
		GetDate(),
		CONVERT(BIT, 0),
		@VendorCode,
		@CustomerCode,
		@IBZone,
		CONVERT(Decimal(9,2), @ResnetCharge),
		@SystemID
	)



GO
