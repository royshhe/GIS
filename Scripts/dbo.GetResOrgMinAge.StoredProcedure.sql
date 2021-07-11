USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOrgMinAge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResOrgMinAge    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrgMinAge    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrgMinAge    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResOrgMinAge    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetResOrgMinAge]
	@OrgId Varchar(10)
AS
	DECLARE	@nOrgId Integer
	SELECT	@nOrgId = Convert(Int, NULLIF(@OrgId,""))

	SELECT 	Vehicle_Class_Code, Minimum_Age
	FROM	Organization_Min_Age_Override
	WHERE	Organization_ID = @nOrgId
	RETURN @@ROWCOUNT













GO
