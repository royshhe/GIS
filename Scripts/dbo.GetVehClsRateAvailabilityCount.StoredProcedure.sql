USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClsRateAvailabilityCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehClsRateAvailabilityCount    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClsRateAvailabilityCount    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClsRateAvailabilityCount    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehClsRateAvailabilityCount    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehClsRateAvailabilityCount]
	@RateID			VarChar(10),
	@VehicleClassCode	VarChar(1),
	@MaxSmallDateTime	VarChar(24)
AS
	SELECT	Count(*)
	FROM	Rate_Vehicle_Class
	WHERE	Rate_ID = CONVERT(Int, @RateID)
	AND	Vehicle_Class_Code = @VehicleClassCode
	AND	Termination_Date >= CONVERT(DateTime, @MaxSmallDateTime)
RETURN 1












GO
