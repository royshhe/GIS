USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchResOrg]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SearchResOrg    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.SearchResOrg    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.SearchResOrg    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.SearchResOrg    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[SearchResOrg]  
	@OrgBCD Varchar(10),
	@OrgName Varchar(50)
AS
	/* 2/25/99 - cpy bug fix - don't return org if bcdnumber is null 
		rhe- aug 20 2005  - fix for db compability level 80	
	*/

	SELECT	@OrgBCD = NULLIF(@OrgBCD,'') --,
--		@OrgName = NULLIF(@OrgName,'')

	SELECT top 100 Organization_ID, Organization, BCD_Number, Address_1, City,   
					isnull(Tour_Rate_Account,0) as Tour_Rate_Account
	FROM	Organization
	WHERE	Inactive = 0

	AND	ISNULL(BCD_Number,'') = ISNULL(@OrgBCD, BCD_Number)
	AND	Organization like LTRIM(@OrgName + '%')
	ORDER BY Organization

	RETURN 1

GO
