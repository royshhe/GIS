USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdOwningCompany]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  Stored Procedure dbo.UpdOwningCompany    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.UpdOwningCompany    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdOwningCompany    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdOwningCompany    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Owning_Company table .
MOD HISTORY:
Name    Date        Comments
*/
/* Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdOwningCompany]
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
	@ResnetCharge           varchar(12)='0',
	@SystemID				varchar(10)
AS
	/* 7/22/99 - changed Remarks param length from 25 to 255 */

	Declare @nOwningCompanyID SmallInt
	Select	@nOwningCompanyID = CONVERT(SmallInt, NULLIF(@OwningCompanyID, ''))
	select @ResnetCharge=nullif(@ResnetCharge,'0')
	if @ResnetCharge='' 
		 select @ResnetCharge='0'

	UPDATE	Owning_Company
   	SET	Name				= @Name,
		Address1			= @Address1,
		Address2			= @Address2,
		City				= @City,
		Province			= @Province,
		Country				= @Country,
		Postal_Code			= @PostalCode,
		Zone				= @Zone,
		Phone_Number			= @PhoneNumber,
		Fax_Number			= @FaxNumber,
		Contact_Name			= @ContactName,
		Contact_Position		= @ContactPosition,
		Contact_Phone_Number		= @ContactPhoneNumber,
		Contact_Email_Address		= @ContactEmailAddress,
		AP_Currency_ID			= CONVERT(TinyInt, @APCurrencyID),
		AP_Interbranch_Account		= @APInterbranchAccount,
		AR_Interbranch_CAN_Account	= @ARInterbranchCANAccount,
		AR_Interbranch_US_Account	= @ARInterbranchUSAccount,
		Remarks				= @Remarks,
		Last_Update_By			= @LastUpdateBy,
		Last_Update_On			= GetDate(),
		Vendor_code             = @VendorCode,
		Customer_code           = @CustomerCode,
		IB_Zone					= @IBZone,
		Resnet_Charge           = CONVERT(Decimal(9,2), @ResnetCharge),
		System_ID               = @SystemID

	WHERE	Owning_Company_ID	= @nOwningCompanyID

   	RETURN 1



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
