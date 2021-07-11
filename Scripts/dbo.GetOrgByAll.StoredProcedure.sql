USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgByAll]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To search for an organization
AUTHOR: ?
DATE: ?
MOD HISTORY:
Name	Date	    Comments
Don K	Aug 9 1999  Added maestro_commission_paid and maestro_freq_flyer_honoured
*/
CREATE PROCEDURE [dbo].[GetOrgByAll]

@OrgName	Varchar(50),
@City		Varchar(25),
@OrgType	Varchar(25),
@BCD		Varchar(25),
@Phone		Varchar(35)
	
AS
	SELECT
		Organization_Id, Organization, BCD_Number, City,
		Contact_Name, Contact_Phone_Number, Address_1, Address_2,
		Province, Remarks, Postal_Code, Country,
		Phone_Number, Fax_Number, Contact_Position, Contact_Email_Address,
		Contact_Fax_Number, Org_Type, Commission_Payable,
		CAST(Maestro_Commission_Paid AS tinyint),
		CAST(Maestro_Freq_Flyer_Honoured AS tinyint),
		CAST(Tour_Rate_Account AS tinyint),
		CAST(Maestro_Rate_Override AS tinyint),
		AR_Customer_Code, Marketing_Source
	FROM
		Organization
	WHERE
		Inactive = 0
                AND     Organization like LTRIM(@OrgName + '%')
                AND     City like LTRIM(@City + '%')
                AND     Org_Type like LTRIM(@OrgType + '%')
                AND     BCD_Number like LTRIM(@BCD + '%')
                AND     Phone_Number like LTRIM(@Phone + '%')
	ORDER BY
		Organization, City

RETURN 1
GO
