USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOrg]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResOrg    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrg    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrg    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrg    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResOrg]
	@OrgId Varchar(10)
AS
	IF @OrgId = "" 	SELECT @OrgId = NULL
	SELECT	BCD_Number, Organization, Tour_Rate_Account
	FROM	Organization
	WHERE	Organization_ID = Convert(Int, @OrgId)
	RETURN @@ROWCOUNT
GO
