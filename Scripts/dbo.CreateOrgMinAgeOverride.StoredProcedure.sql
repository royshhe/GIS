USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrgMinAgeOverride]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateOrgMinAgeOverride    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgMinAgeOverride    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgMinAgeOverride    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgMinAgeOverride    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Organization_Min_Age_Override table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOrgMinAgeOverride]

	@OrgId Varchar(10),
	@VehClassCode Char(1),
	@MinAge Varchar(10),
	@UserName varchar(20)
AS
	INSERT INTO Organization_Min_Age_Override
		(Organization_ID, Vehicle_Class_Code, Minimum_Age)
	VALUES
		(Convert(Int, @OrgId), @VehClassCode, Convert(Int, @MinAge))
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
