USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocationVehicleClass]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLocationVehicleClass    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleClass    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleClass    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleClass    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Location_Vehicle_Class table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLocationVehicleClass]
	@LocationID		VarChar(10),
	@VehicleClassCode	VarChar(1),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)
AS
	/* 7/14/99 - save ValidTo as Date + 23:59 */

	Declare @NewLocationVehicleClassID	SmallInt
	DECLARE @dValidTo 			Datetime

	SELECT	@dValidTo = Convert(Datetime, NULLIF(@ValidTo,''))

	IF @dValidTo IS NOT NULL
		-- validTo = floor(validTo) + 1 day - 2 millisecs
		-- 	   = validTo + 23:59:59.997
		SELECT	@dValidTo = DATEADD(millisecond, -2,
					    FLOOR(CAST(@dValidTo AS FLOAT)) + 1)

	INSERT INTO Location_Vehicle_Class
	  (	Location_ID,
		Vehicle_Class_Code,
		Valid_From,
		Valid_To
	  )
	VALUES
	  (	CONVERT(SmallInt, @LocationID),
		@VehicleClassCode,
		CONVERT(DateTime, @ValidFrom),
		@dValidTo
	  )
	Select @NewLocationVehicleClassID = @@IDENTITY

Return @NewLocationVehicleClassID










GO
