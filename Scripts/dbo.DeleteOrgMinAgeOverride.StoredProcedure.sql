USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOrgMinAgeOverride]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteOrgMinAgeOverride    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgMinAgeOverride    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgMinAgeOverride    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgMinAgeOverride    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Organization_Min_Age_Override table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteOrgMinAgeOverride]

	@OrgId Varchar(10),
	@VehClassCode Char(1),
	@UserName varchar(20)
AS
	DELETE	Organization_Min_Age_Override
	WHERE	Organization_Id = Convert(Int, @OrgId)
	AND	Vehicle_Class_Code = @VehClassCode

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
