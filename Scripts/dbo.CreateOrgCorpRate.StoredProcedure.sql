USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrgCorpRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.CreateOrgCorpRate    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCorpRate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCorpRate    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCorpRate    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Organization_Rate table.
MOD HISTORY:
Name    Date        Comments
Don K	29 Mar 2000 Force dates to midnight
*/

CREATE PROCEDURE [dbo].[CreateOrgCorpRate]
	@OrgId 		Varchar(10),
	@RateId 	Varchar(10),
	@RateLevel	Char(1),
	@ValidFrom 	Varchar(24),
	@ValidTo 	Varchar(24),
	@UserName	varchar(20),
	@MaestroRate Varchar(10)=''
AS
	INSERT INTO Organization_Rate
		(Organization_ID,Rate_Id,Rate_Level,
		 Effective_Date,Valid_From,
		 Valid_To,
		 Termination_Date,Maestro_Rate)
	VALUES	(Convert(Int, @OrgId), Convert(Int, @RateId),@RateLevel,
		 GetDate(),
		CAST(@ValidFrom AS datetime), 
		-- Truncate time from @ValidFrom date/time
		--CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
		-- Truncate time from @ValidTo date/time
		CAST(@ValidTo AS datetime),
		--CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
		 'Dec 31 2078 11:59PM',upper(@MaestroRate))
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
