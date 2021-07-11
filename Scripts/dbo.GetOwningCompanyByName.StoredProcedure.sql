USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOwningCompanyByName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetOwningCompanyByName    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyByName    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyByName    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyByName    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOwningCompanyByName]
	@Name VarChar(50)
AS
	--If @Name = ''
		--SELECT @Name = NULL
	Set Rowcount 2000
	
   	SELECT	Owning_Company_ID,
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
		Vendor_code,
		Customer_code,
		IB_Zone,
		Resnet_Charge,
		System_ID
	FROM	Owning_Company
	WHERE	Name Like @Name + '%'
	AND	Delete_Flag		= 0
   	RETURN 1
GO
