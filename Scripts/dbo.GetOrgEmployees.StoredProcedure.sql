USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgEmployees]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOrgEmployees    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgEmployees    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgEmployees    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgEmployees    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgEmployees]
	@OrgId Varchar(10)
AS

	SELECT	Organization_ID, Referring_Employee_Id, First_Name, Last_Name
	FROM 	Referring_Employee
	WHERE	Organization_ID = Convert(Int, @OrgId)
	ORDER BY First_Name, Last_Name
	
	RETURN 1












GO
