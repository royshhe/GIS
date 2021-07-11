USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLocSetID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateLocSetID    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLocSetID    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLocSetID    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLocSetID    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateLocSetID]
	@PULocID	VarChar(10),
	@RateID		VarChar(10),
	@RateDate	VarChar(24)
AS
	DECLARE @dRateDate DateTime
	Set Rowcount 2000
	SELECT @dRateDate = CONVERT(DateTime, @RateDate)
	SELECT	Distinct Rate_Location_Set_ID
	FROM	Rate_Location_Set_Member
	WHERE	Location_ID = CONVERT(SmallInt, @PULocID)
	AND	Rate_ID	= CONVERT(Int, @RateID)
	AND	@dRateDate BETWEEN Effective_Date AND Termination_Date
RETURN 1












GO
