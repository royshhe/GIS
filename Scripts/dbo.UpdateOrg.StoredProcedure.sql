USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrg]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PURPOSE: To update an organization
AUTHOR: ?
DATE: ?
MOD HISTORY:
Name    Date        Comments
Don K   Aug 9 1999  Added maestro_commission_paid and maestro_freq_flyer_honoured
*/
CREATE PROCEDURE [dbo].[UpdateOrg]
@OrgId Varchar(10),
@OrgName Varchar(50),
@BCD Char(10),
@Addr1 Varchar(50),
@Addr2 Varchar(50),
@City Varchar(25),
@Province Varchar(25),
@Country Varchar(25),
@PostalCode Varchar(10),
@Phone Varchar(35),
@Fax Varchar(35),
@ContactName Varchar(25),
@ContactPosition Varchar(25),
@ContactPhone Varchar(35),
@ContactFax Varchar(35),
@ContactEmail Varchar(50),
@CommPayable Char(1),
@OrgType Varchar(25),
@Remarks Varchar(255),
@LastChangedBy Varchar(20),
@MaestroCommissionPaid char(1),
@MaestroFreqFlyerHonoured char(1),
@TourRateAccount char(1),
@MaestroRateOverride char(1),
@ARCode varchar(20),
@MarketingSource varchar(30),
@Inactive varchar(1)
AS
DECLARE @iOrgId Integer
	IF @OrgId = ''	SELECT @OrgId = NULL
	SELECT @iOrgId = Convert(Int, @OrgId)
	UPDATE 	Organization
	SET 	Organization = @OrgName,
		BCD_Number = @BCD,
		Address_1 = @Addr1,
		Address_2 = @Addr2,
		City = @City,
		Province = @Province,
		Country = @Country,
		Postal_Code = @PostalCode,
		Phone_Number = @Phone,
		Fax_Number = @Fax,
		Contact_Name = @ContactName,
		Contact_Position = @ContactPosition,
		Contact_Phone_Number = @ContactPhone,
		Contact_Fax_Number = @ContactFax,
		Contact_Email_Address = @ContactEmail,
		Commission_Payable = @CommPayable,
		Org_Type = @OrgType,
		Remarks = @Remarks,
	/*	Inactive = 0,  */
		Last_Changed_By = @LastChangedBy,
		Last_Changed_On = GetDate(),
		Maestro_Commission_Paid = CAST(NULLIF(@MaestroCommissionPaid, '') AS bit),
		Maestro_Freq_Flyer_Honoured = CAST(NULLIF(@MaestroFreqFlyerHonoured, '') AS bit),
		Tour_Rate_Account = CAST(NULLIF(@TourRateAccount, '') AS bit),
		Maestro_Rate_Override = CAST(NULLIF(@MaestroRateOverride, '') AS bit),
		AR_Customer_Code = @ARCode,
		Marketing_Source = @MarketingSource,
		Inactive = case when @Inactive ='1'
							then CAST(@Inactive AS bit) --CAST(NULLIF(@Inactive, '0') AS bit)
							else 0
					end		
	WHERE	Organization_Id = @iOrgId

	RETURN @iOrgId

GO
