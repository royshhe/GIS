USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocVehClass]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdLocVehClass    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehClass    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehClass    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehClass    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Location_Vehicle_Class table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLocVehClass]
	@LocationVehicleClassID	VarChar(10),
	@VehicleClassCode	VarChar(1),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)
AS
	Declare	@nLocationVehicleClassID SmallInt
	Select		@nLocationVehicleClassID = CONVERT(SmallInt, NULLIF(@LocationVehicleClassID, ''))

	/* 7/14/99 - save ValidTo as Date + 23:59 */
	DECLARE @dValidTo Datetime

	SELECT	@dValidTo = Convert(Datetime, NULLIF(@ValidTo,''))

	IF @dValidTo IS NOT NULL
		-- validto = floor(validto) + 1 day - 1 millisec
		--         = validto + 23:59:59.997
		SELECT	@dValidTo = DATEADD(millisecond, -2,
					    FLOOR(CAST(@dValidTo AS FLOAT)) + 1)

	UPDATE	Location_Vehicle_Class
	SET	Vehicle_Class_Code		= @VehicleClassCode,
		Valid_From			= CONVERT(DateTime, @ValidFrom),
		Valid_To			= @dValidTo

	WHERE	Location_Vehicle_Class_ID	= @nLocationVehicleClassID
Return 1















GO
