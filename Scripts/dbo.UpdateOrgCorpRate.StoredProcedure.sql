USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrgCorpRate]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdateOrgCorpRate    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCorpRate    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCorpRate    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCorpRate    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Organization_Rate table .
MOD HISTORY:
Name    Date        Comments
Don K	29 Mar 2000 Force dates to midnight
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateOrgCorpRate]
	@OrgId 		Varchar(10),
	@RateId 	Varchar(10),
	@RateLevel 	char(1),	
	@ValidFrom 	Varchar(24),
	@ValidTo 	Varchar(24),
	@UserName	Varchar(20),
	@MaestroRate Varchar(10)='',
	@EffectiveDate Varchar(24)
AS
	DECLARE 	@CurrDateTime DateTime
	Declare	@nOrgId Integer
	Declare	@nRateId Integer
	
	SELECT	@CurrDateTime = GetDate()
	select	@EffectiveDate=isnull(nullif(@EffectiveDate,''),convert(Varchar,@CurrDateTime,20))
	Select		@nOrgId = Convert(Int, NULLIF(@OrgId, ''))
	Select		@nRateId = Convert(Int, NULLIF(@RateId, ''))

--select * from Organization_Rate
	UPDATE 	Organization_Rate
	SET	Termination_Date = @CurrDateTime
	WHERE	Organization_ID = @nOrgId
	AND	Rate_Id = @nRateId
	and valid_from >=convert(datetime,@ValidFrom)
--	and valid_to<=convert(datetime,@ValidTo)
	and  convert(varchar,Effective_Date,20 )= convert(varchar,@EffectiveDate,20 )
	AND	Termination_Date='Dec 31 2078 11:59PM'

	--Create a record for Organization Rate because the current record has been expired
	INSERT INTO Organization_Rate
		(Organization_ID, Rate_Id,Rate_Level,
		 Effective_Date,
		 Valid_From, Valid_To,
		 Termination_Date,Maestro_Rate)
	VALUES	(@nOrgId, @nRateId, @RateLevel,
		 DATEADD(millisecond, 1, @CurrDateTime),
		 -- truncate time from @ValidFrom date/time
		 --CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
		CAST(@ValidFrom AS datetime), --cancel Truncate
		 -- truncate time from @ValidTo date/time
		 --CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
		CAST(@ValidTo AS datetime), --cancel Truncate
		 'Dec 31 2078 11:59PM',upper(@MaestroRate))

/* Update Audit Info */
Update
	Organization
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = @nOrgId

RETURN 1



--exec UpdateOrgCorpRate '998', '5681', 'A', '12 Feb 2011 00:00:00', '30 Aug 2012 23:59', 'Peter Ni', 'TXI', '4/12/2011 10:48:02 AM'
GO
