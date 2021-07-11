USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocVehRateLevelPeriod]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocVehRateLevelPeriod    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLevelPeriod    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLevelPeriod    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehRateLevelPeriod    Script Date: 11/23/98 3:55:33 PM ******/
--exec GetLocVehRateLevelPeriod '1','C','18 May 2011','Walk Up','2078/12/31 11:59:00 PM'

CREATE PROCEDURE [dbo].[GetLocVehRateLevelPeriod]
	@LocationID 		VarChar(10),
	@VehicleClassCode 	VarChar(1),
	@ValidFrom 		VarChar(24),
	@RateType		VarChar(20),
	@MaxSmallDate		VarChar(24)
AS
DECLARE	@dValidFrom		DateTime
	SELECT @dValidFrom = CONVERT(DateTime, NULLIF(@ValidFrom, ''))
	Set Rowcount 2000
	SELECT	DISTINCT
		CONVERT(VarChar, LVRL.Valid_From, 111) Valid_From,
		CONVERT(VarChar, LVRL.Valid_To, 111) Valid_To
	FROM	Location_Vehicle_Rate_Level LVRL,
		Vehicle_Rate VR,
		Location_Vehicle_Class LVC
	WHERE	LVC.Location_ID = CONVERT(SmallInt, @LocationID)
	AND	LVC.Vehicle_Class_Code = @VehicleClassCode
	AND	ISNULL(LVRL.Valid_To, @dValidFrom) >= @dValidFrom
	AND	LVC.Location_Vehicle_Class_ID = LVRL.Location_Vehicle_Class_ID

	AND	LVRL.Rate_ID = VR.Rate_ID
	AND	LVRL.Location_Vehicle_Rate_Type = @RateType
	AND	VR.Termination_Date >= CONVERT(DateTime, @MaxSmallDate)
	ORDER BY
		CONVERT(VarChar, LVRL.Valid_From, 111) DESC
Return 1












GO
