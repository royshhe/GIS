USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocVehRateLevelOutOfRange]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdLocVehRateLevelOutOfRange    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevelOutOfRange    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevelOutOfRange    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevelOutOfRange    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Location_Vehicle_Rate_Level table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLocVehRateLevelOutOfRange]
	@LocationVehicleClassID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)	
AS
	Declare	@nLocationVehicleClassID SmallInt
	Declare	@dValidFrom DateTime
	Declare	@dValidTo DateTime

	Select		@nLocationVehicleClassID = CONVERT(SmallInt, NULLIF(@LocationVehicleClassID, ''))
	Select		@dValidFrom = CONVERT(DateTime, NULLIF(@ValidFrom, ''))
	Select		@dValidTo = CONVERT(DateTime, NULLIF(@ValidTo, ''))

	If @ValidTo = ''
		Select @ValidTo = NULL

	/*Update the Valid_From */
	UPDATE	Location_Vehicle_Rate_Level
	SET	Valid_From = CONVERT(DateTime, @ValidFrom)
	
	WHERE	Location_Vehicle_Class_ID	= @nLocationVehicleClassID
	AND		Valid_From 			< @dValidFrom
	

	/*Update the Valid_To */
	UPDATE	Location_Vehicle_Rate_Level
	SET	Valid_To = CONVERT(DateTime, @ValidTo)
	
	WHERE	Location_Vehicle_Class_ID	= @nLocationVehicleClassID
	AND		Valid_To 			> @dValidTo
	AND		@dValidTo 			 IS Not NULL	

RETURN 1





GO
