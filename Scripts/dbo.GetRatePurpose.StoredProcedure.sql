USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRatePurpose]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[GetRatePurpose]
	@RateId 	Varchar(10),
	@CurrDate	Varchar(24)
AS
	/* 6/23/99 - created - return purpose id and description of a rate */

	SELECT	@RateId = NULLIF(@RateId,''),
		@CurrDate = NULLIF(@CurrDate,'')

	SELECT 	VR.Rate_Purpose_ID, RP.Rate_Purpose
	FROM	Vehicle_Rate VR,
		Rate_Purpose RP

	WHERE	VR.Rate_Id = Convert(Int, @RateId)
	AND	VR.Rate_Purpose_ID = RP.Rate_Purpose_ID
	AND	Convert(Datetime, @CurrDate)
		BETWEEN VR.Effective_Date AND VR.Termination_Date

	RETURN @@ROWCOUNT










GO
