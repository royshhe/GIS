USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOrgEmployee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteOrgEmployee    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgEmployee    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgEmployee    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgEmployee    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Referring_Employee table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteOrgEmployee]
	@OrgId Varchar(10),
	@RefEmpId Varchar(15),
	@UserName varchar(20)
AS
	/* 981120 - Cindy Yee - removed OrgId from where clause */
	DELETE	Referring_Employee
	WHERE	Referring_Employee_ID = Convert(Int, @RefEmpId)

/* Update Audit Info */
Update
	Organization
Set

	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = Convert(int,@OrgID)
	
RETURN 1













GO