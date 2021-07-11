USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationVehicleClassID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocationVehicleClassID    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClassID    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClassID    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationVehicleClassID    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLocationVehicleClassID]
	@LocationID		VarChar(10),
	@VehicleClassCode	VarChar(1),
	@ValidFrom		VarChar(24)
AS
DECLARE @dValidFrom		DateTime
	SELECT @dValidFrom = CONVERT(DateTime, NULLIF(@ValidFrom, ''))
	
	Set Rowcount 2000
	SELECT	DISTINCT Location_Vehicle_Class_ID
	FROM	Location_Vehicle_Class
	WHERE	Location_ID = CONVERT(SmallInt, @LocationID)
	AND	Vehicle_Class_Code = @VehicleClassCode
	AND	@dValidFrom BETWEEN Valid_From AND ISNULL(Valid_To, @dValidFrom)
RETURN 1












GO
