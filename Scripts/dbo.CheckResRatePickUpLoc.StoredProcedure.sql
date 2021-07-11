USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResRatePickUpLoc]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckResRatePickUpLoc    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRatePickUpLoc    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRatePickUpLoc    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRatePickUpLoc    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check whether the given Current Date of the rate and pickup location is in between Effective and Termination Date.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckResRatePickUpLoc]
	@RateId Varchar(20),
	@PULocId Varchar(5),
	@CurrDate Varchar(24)
AS
	SELECT	"1"
	FROM	Rate_Location_Set_Member
	WHERE	Location_Id = Convert(SmallInt, @PULocId)
	AND	Rate_Id = Convert(Int, @RateId)
	AND	Convert(Datetime, @CurrDate) BETWEEN
			Effective_Date AND Termination_Date
	RETURN @@ROWCOUNT













GO
