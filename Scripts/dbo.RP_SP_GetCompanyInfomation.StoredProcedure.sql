USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_GetCompanyInfomation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[RP_SP_GetCompanyInfomation] 
	
AS

DECLARE 	@companyName Varchar(80), @contactPerson Varchar(50), @contactPhone Varchar(50), @CompanyAddress Varchar(100), 
		@companyCity Varchar(30), @companyProvince Varchar(30), @companyPostalCode Varchar(30),@CompanyCountry varchar(50),
		@VendorNumber Varchar(30)


--, @companyLogo Image




SELECT   @companyName=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'CompanyName') AND (SystemSetting.SettingName = 'CompanyInfo')

SELECT   @contactPerson=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PTicketContact') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @contactPhone=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PTicketPhone') AND (SystemSetting.SettingName = 'CompanyInfo')


--

SELECT   @CompanyAddress=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Address') AND (SystemSetting.SettingName = 'CompanyInfo')


SELECT   @companyCity=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'City') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @companyProvince=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Province') AND (SystemSetting.SettingName = 'CompanyInfo')



SELECT   @companyPostalCode=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'PostalCode') AND (SystemSetting.SettingName = 'CompanyInfo')

SELECT   @CompanyCountry=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'Country') AND (SystemSetting.SettingName = 'CompanyInfo')

SELECT   @VendorNumber=  SystemSettingValues.SettingValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'VendorNumber') AND (SystemSetting.SettingName = 'CompanyInfo')

/*
SELECT   @companyLogo=  SystemSettingValues.ImageValue
FROM         SystemSettingValues INNER JOIN
                      SystemSetting ON SystemSettingValues.SettingID = SystemSetting.SettingID 
WHERE     (SystemSettingValues.ValueName = 'CompanyLogo') AND (SystemSetting.SettingName = 'CompanyInfo')
*/


select	@companyName as CompanyName,
		@contactPerson as ContactPerson,
		@contactPhone as ContactPhone,
		@CompanyAddress as CompanyAddress,
		@companyCity as companyCity,
		@companyProvince as CompanyProvince,
		@companyPostalCode as CompanyPostalCode,
		@CompanyCountry as CompanyCountry,
		@VendorNumber as VendorNumber

GO
