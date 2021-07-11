USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateAvailabilityCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateAvailabilityCount    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailabilityCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailabilityCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailabilityCount    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateAvailabilityCount]
	@RateID			VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@MaxSmallDateTime	VarChar(24)
AS
	SELECT	Count(*)
	FROM	Rate_Availability
	WHERE	Rate_ID = CONVERT(Int, @RateID)
	AND	Termination_Date >= CONVERT(DateTime, @MaxSmallDateTime)
	
	AND	CONVERT(DateTime, CONVERT(VarChar, Valid_From, 111)) <=
		CONVERT(DateTime, @ValidFrom)
	AND	ISNULL(Valid_To, CONVERT(DateTime, @ValidTo)) >= CONVERT(DateTime, @ValidTo)
RETURN 1












GO
