USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateID    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateID    Script Date: 2/16/99 2:05:42 PM ******/
/*
PURPOSE: Retrieve rate id for a given rate name
MOD HISTORY:
Name	Date		Comment
CPY	15-dec-1999	Modified to match on @RateName using =, instead of Like;
			Added nullif checks
*/
CREATE PROCEDURE [dbo].[GetRateID]
	@RateName 		varchar(25),
	@MaxSmallDateTime 	varchar(24)
AS
	Set Rowcount 2000

	SELECT	@RateName = NULLIF(@RateName,''),
		@MaxSmallDateTime = NULLIF(@MaxSmallDateTime,'')

	SELECT	DISTINCT Rate_ID
	FROM	Vehicle_Rate
	WHERE	Rate_Name = @RateName 
	AND 	Termination_Date >= CONVERT(DateTime, @MaxSmallDateTime)

	RETURN 1














GO
