USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomerLic]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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

create PROCEDURE [dbo].[UpdateCustomerLic]
	@CustId 		Varchar(10),
	@Licence 		Varchar(25),
	@LicExpiry 		Varchar(11),
	@LicJuris 		Varchar(20),
	@DriverLicClass		Char(1) = NULL,
	@CtrctNum		Varchar(20)

AS
DECLARE @dLicExpiry datetime
DECLARE @iCustId Integer
DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))
	SELECT 	@dLicExpiry = Convert(datetime, NULLIF(@LicExpiry,'')),
		@iCustId = Convert(Int, NULLIF(@CustId, ''))
		

if ltrim(rtrim(@CustID))<>'' 
	UPDATE 	Customer
	SET Driver_Licence_Number = Replace(NULLIF(@Licence,''),' ', ''),
		Driver_Licence_Expiry = @dLicExpiry,
		Jurisdiction = NULLIF(@LicJuris,''),
		Driver_Licence_Class = CONVERT(Int, NULLIF(@DriverLicClass, ''))
	WHERE	Customer_Id = @iCustId

if @CtrctNum<>''
	UPDATE 	Renter_Driver_Licence
	SET Licence_Number = Replace(NULLIF(@Licence,''),' ', ''),
		Expiry = @dLicExpiry,
		Jurisdiction = NULLIF(@LicJuris,''),
		Class = CONVERT(Int, NULLIF(@DriverLicClass, ''))
	WHERE	Contract_Number = @iCtrctNum
GO
