USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResRateLevel]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckResRateLevel    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateLevel    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateLevel    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateLevel    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check whether the given Current Date of the rate is in between Effective and Termination Date.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckResRateLevel]
	@RateId Varchar(20),
	@RateLevel Varchar(1),
	@CurrDate Varchar(24)
AS
	SELECT 	"1"
	FROM	Rate_Level
	WHERE	Rate_Id = Convert(Int, @RateID)
	AND	Rate_Level = @RateLevel
	AND	Convert(Datetime, @CurrDate) BETWEEN
			Effective_Date AND Termination_Date
	RETURN @@ROWCOUNT













GO
