USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrgEmployee]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateOrgEmployee    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgEmployee    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgEmployee    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgEmployee    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Referring_Employee table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOrgEmployee]
	@OrgId Varchar(10),
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@UserName varchar(20)
AS
DECLARE @CurrRefEmpId SmallInt
	INSERT INTO Referring_Employee
		(Organization_ID, Last_Name, First_Name)
	VALUES	(Convert(Int, @OrgId), @LastName, @FirstName)
/* Update Audit Info */
Update
	Organization
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = Convert(int,@OrgID)
	SELECT @CurrRefEmpId = @@Identity
	RETURN @CurrRefEmpId













GO
