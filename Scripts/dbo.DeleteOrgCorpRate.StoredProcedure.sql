USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteOrgCorpRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.DeleteOrgCorpRate    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgCorpRate    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgCorpRate    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteOrgCorpRate    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Organization_Rate table by setting the Termination Date
MOD HISTORY:
Name    Date        Comments
Don K	29 Mar 2000 Force dates to midnight
*/

CREATE PROCEDURE [dbo].[DeleteOrgCorpRate]
	@OrgId 		Varchar(10),
	@RateId 	Varchar(10),
	@ValidFrom	Varchar(20),
	@ValidTo	Varchar(20),
	@UserName	varchar(20)
AS

UPDATE
	Organization_Rate
SET
	Termination_Date = GetDate()
WHERE
	Organization_ID = Convert(Int, @OrgId)
	AND	Rate_Id = Convert(Int, @RateId)
	AND	Termination_Date = 'Dec 31 2078 11:59PM'
	--AND	CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime)
	AND	CAST(@ValidFrom AS datetime) Between Valid_From And Valid_To
	--AND	CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime)
	AND	CAST(@ValidTo AS datetime) Between Valid_From And Valid_To

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
