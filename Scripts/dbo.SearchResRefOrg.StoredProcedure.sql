USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchResRefOrg]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.SearchResRefOrg    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.SearchResRefOrg    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.SearchResRefOrg    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.SearchResRefOrg    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[SearchResRefOrg]
	@OrgType Varchar(25),

	@OrgName Varchar(50)
AS
	SELECT	top 100 O.Organization_ID, O.Organization, O.BCD_Number, O.Address_1,
		O.City, L.Value, O.Tour_Rate_Account
--	FROM	Lookup_Table L,
--		Organization O
--select *
FROM	Organization O
	LEFT  JOIN 	Lookup_Table L
	ON L.Category = 'OrgType'  and O.Org_Type = L.Code --And L.Code =@OrgType 

	WHERE	
--	O.Org_Type *= L.Code
--	AND	L.Category = "OrgType"	AND	
	 L.Code =@OrgType and 
	O.Inactive = 0
--	AND	O.Org_Type LIKE LTRIM(@OrgType  + "%")
	AND	O.Organization LIKE LTRIM(@OrgName + '%')
	ORDER BY Organization
	RETURN 1






GO
