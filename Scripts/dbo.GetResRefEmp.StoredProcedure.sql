USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRefEmp]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRefEmp    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResRefEmp    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRefEmp    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRefEmp    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetResRefEmp]
	@OrgId Varchar(10)
AS
	DECLARE	@nOrgId Integer
	SELECT	@nOrgId = Convert(Int, NULLIF(@OrgId,""))

	SELECT	Referring_Employee_Id, First_Name, Last_Name
	FROM 	Referring_Employee
	WHERE	Organization_ID = @nOrgId
	ORDER BY First_Name, Last_Name
	
	RETURN @@ROWCOUNT













GO
