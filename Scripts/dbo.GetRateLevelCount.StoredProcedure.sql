USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLevelCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateLevelCount    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevelCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevelCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevelCount    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateLevelCount]
	@RateID		VarChar(10),
	@RateLevel	VarChar(1)
AS
--SET CONCAT_NULL_YIELDS_NULL OFF
	SELECT	Count(*)
	FROM	Rate_Level
	WHERE	Rate_ID 		= CONVERT(Int, @RateID)
	AND	Rate_Level 		= @RateLevel
RETURN 1













GO
