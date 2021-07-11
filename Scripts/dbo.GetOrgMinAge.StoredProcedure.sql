USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgMinAge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOrgMinAge    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgMinAge    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgMinAge    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgMinAge    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgMinAge]
	@OrgId Varchar(10)
AS
	SELECT	Organization_ID, Vehicle_Class_Code, Minimum_Age
	FROM 	Organization_Min_Age_Override
	WHERE	Organization_ID = Convert(Int, @OrgId)
	
	RETURN 1












GO
