USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateFlagsByName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateFlagsByName    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateFlagsByName    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetRateFlagsByName
PURPOSE: To get some flags from the rate based on the rate name
AUTHOR: Don Kirkby
DATE CREATED: Jan 21, 1999
CALLED BY: Rate
REQUIRES:
MOD HISTORY:
Name    Date        Comments
Don K	Mar  1 1999 Changed date constraints.
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateFlagsByName]
	@RateName	varchar(25),
	@BookedOn	varchar(24)
AS
	DECLARE	@dBookedOn	datetime
	SELECT	@dBookedOn = CONVERT(datetime, NULLIF(@BookedOn, ''))
	SELECT	@RateName = NULLIF(@RateName, '')

	SELECT	CONVERT(tinyint, rate.commission_paid) cpd,
		CONVERT(tinyint, rate.frequent_flyer_plans_honoured) ffph
	  FROM	vehicle_rate rate
	 WHERE	rate.rate_name = @RateName
	   AND	@dBookedOn
		BETWEEN rate.effective_date
		    AND rate.termination_date












GO
