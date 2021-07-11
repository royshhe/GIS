USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocVehClassOverlapDateRange]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapDateRange    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapDateRange    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapDateRange    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocVehClassOverlapDateRange    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocVehClassOverlapDateRange]
	@LocationID		VarChar(10),
	@VehicleClassCode	VarChar(1),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),	
	@LocationVehicleClassID	VarChar(10)
AS
	SELECT	CONVERT(VarChar, Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111)
	FROM	Location_Vehicle_Class
	WHERE	Location_ID = CONVERT(SmallInt, @LocationID)
	AND	Vehicle_Class_Code = @VehicleClassCode
	AND	(
			(	CONVERT(DateTime, CONVERT(VarChar, Valid_From, 111)) <=
				CONVERT(DateTime, @ValidFrom)
			AND
				ISNULL(Valid_To, CONVERT(DateTime, @ValidFrom)) >= CONVERT(DateTime, @ValidFrom)
			)
		OR
			(	CONVERT(DateTime, CONVERT(VarChar, Valid_From, 111)) <=
				CONVERT(DateTime, @ValidTo)
			AND
				ISNULL(Valid_To, CONVERT(DateTime, @ValidTo)) >= CONVERT(DateTime, @ValidTo)
			)
		OR
			(	Valid_From >= CONVERT(DateTime, @ValidFrom)
			AND
				ISNULL(Valid_To, CONVERT(DateTime, '2078/12/31')) <= CONVERT(DateTime, @ValidTo)
			)
		)
	AND	Location_Vehicle_Class_ID	<> CONVERT(SmallInt, @LocationVehicleClassID)
	ORDER BY
		Valid_From DESC
RETURN 1












GO
