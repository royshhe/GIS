USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrgEmployee]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateOrgEmployee    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgEmployee    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgEmployee    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgEmployee    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Referring_Employee table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateOrgEmployee]
	@OrgId Varchar(10),
	@RefEmpId Varchar(15),
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@UserName Varchar(20)
AS
	Declare	@nRefEmpId Integer
	Declare	@nOrgID Integer

	Select		@nRefEmpId = Convert(Int, NULLIF(@RefEmpId, ''))
	Select		@nOrgID = Convert(int, NULLIF(@OrgID, ''))

	/* 981120 - Cindy Yee - removed OrgId from where clause */
	UPDATE	Referring_Employee
	SET	Last_Name = @LastName,
		First_Name = @FirstName

	WHERE	Referring_Employee_ID = @nRefEmpId

/* Update Audit Info */
Update
	Organization
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = @nOrgID

RETURN 1














GO
