USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrgMinAgeOverride]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateOrgMinAgeOverride    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgMinAgeOverride    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgMinAgeOverride    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgMinAgeOverride    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Organization_Min_Age_Override table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateOrgMinAgeOverride]

	@OrgId Varchar(10),
	@OldVehClassCode Char(1),
	@NewVehClassCode Char(1),
	@MinAge Varchar(10),
	@UserName varchar(20)
AS
	Declare	@nOrgID Integer

	Select		@nOrgID = Convert(int, NULLIF(@OrgID, ''))

	UPDATE 	Organization_Min_Age_Override
	SET	Vehicle_Class_Code = @NewVehClassCode,
		Minimum_Age = Convert(Int, @MinAge)

	WHERE	Organization_Id = @nOrgId
	AND	Vehicle_Class_Code = @OldVehClassCode

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
