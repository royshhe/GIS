USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationVehicleRateLevel]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocationVehicleRateLevel    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleRateLevel    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleRateLevel    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleRateLevel    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationVehicleRateLevel]
	@LocationVehicleClassID VarChar(10),
	@RateType		VarChar(20),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@MaxSmallDate		VarChar(24)
AS
	Set Rowcount 2000
	SELECT	DISTINCT
		LVRL.Rate_Selection_Type,
		LVRL.Rate_Selection_Type,
		LVRL.Rate_ID,
		VR.Rate_Name,
		LVRL.Rate_Level,
		LVRL.Rate_Level,
		CONVERT(VarChar, Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111)
	FROM	Location_Vehicle_Rate_Level LVRL,
		Vehicle_Rate VR
	WHERE	LVRL.Location_Vehicle_Class_ID = CONVERT(SmallInt, @LocationVehicleClassID)
 	
	AND	(	(
	  			CONVERT(DateTime, CONVERT(VarChar, LVRL.Valid_From, 111)) <=
				CONVERT(DateTime, @ValidFrom)
   			AND	CONVERT(DateTime, CONVERT(VarChar, LVRL.Valid_To, 111)) >=
				CONVERT(DateTime, @ValidTo)
			)
		OR
			(
	  			CONVERT(DateTime, CONVERT(VarChar, LVRL.Valid_From, 111)) <=
				CONVERT(DateTime, @ValidFrom)
   			AND	LVRL.Valid_To Is Null
			)
		)
	AND	LVRL.Rate_ID = VR.Rate_ID
	AND	LVRL.Location_Vehicle_Rate_Type = @RateType
/*
   	AND	CONVERT(DateTime, CONVERT(VarChar, VR.Effective_Date, 111)) <=
		CONVERT(DateTime, @ValidFrom)
*/
	AND	VR.Termination_Date >= CONVERT(DateTime, @MaxSmallDate)
	ORDER BY
		LVRL.Rate_Selection_Type
Return 1












GO
