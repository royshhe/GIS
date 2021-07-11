USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrg]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To create a new organization
AUTHOR: ?
DATE: ?
MOD HISTORY:
Name    Date        Comments
Don K   Aug 9 1999  Added maestro_commission_paid and maestro_freq_flyer_honoured
*/
CREATE PROCEDURE [dbo].[CreateOrg]
	@OrgName Varchar(50), @BCD Char(10), @Addr1 Varchar(50),
	@Addr2 Varchar(50), @City Varchar(25), @Province Varchar(25),
	@Country Varchar(25),
	@PostalCode Varchar(10), @Phone Varchar(35), @Fax Varchar(35),
	@ContactName Varchar(25), @ContactPosition Varchar(25),
	@ContactPhone VarChar(35), @ContactFax VarChar(35),
	@ContactEmail Varchar(50), @CommPayable Char(1), @OrgType Varchar(25),
	@Remarks Varchar(255), @LastChangedBy Varchar(20),
	@MaestroCommissionPaid char(1),
	@MaestroFreqFlyerHonoured char(1),
	@TourRateAccount char(1),
	@MaestroRateOverride char(1),
	@ARCode varchar(20),
	@MarketingSource varchar(30)
AS
DECLARE @NewOrgId Int
	INSERT INTO Organization
		(Organization, BCD_Number, Address_1, Address_2,
		 City, Province, Country, Postal_Code,
		 Phone_Number, Fax_Number,
		 Contact_Name, Contact_Position, Contact_Phone_Number,
		 Contact_Fax_Number, Contact_Email_Address, Commission_Payable,
		 Org_Type, Remarks, Inactive, Last_Changed_By, Last_Changed_On,
		 Maestro_Commission_Paid, Maestro_Freq_Flyer_Honoured, Tour_Rate_Account,
		 Maestro_Rate_Override, AR_Customer_Code, Marketing_Source)
	VALUES
		(@OrgName, @BCD, @Addr1, @Addr2,
		 @City, @Province, @Country, @PostalCode,
		 @Phone, @Fax,
		 @ContactName, @ContactPosition, @ContactPhone,
		 @ContactFax, @ContactEmail, @CommPayable,
		 @OrgType, @Remarks, 0, @LastChangedBy, GetDate(),
		 CAST(NULLIF(@MaestroCommissionPaid, '') AS bit),
		 CAST(NULLIF(@MaestroFreqFlyerHonoured, '') AS bit),
		 CAST(NULLIF(@TourRateAccount, '') AS bit),
		 CAST(NULLIF(@MaestroRateOverride, '') AS bit),
		 @ARCode, @MarketingSource
		)
	SELECT @NewOrgId = @@IDENTITY
	RETURN @NewOrgId
GO
