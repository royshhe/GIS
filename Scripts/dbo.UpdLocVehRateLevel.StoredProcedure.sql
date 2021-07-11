USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLocVehRateLevel]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdLocVehRateLevel    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevel    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevel    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLocVehRateLevel    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Location_Vehicle_Rate_Level table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLocVehRateLevel]
	@LocationVehicleClassID		VarChar(10),
	@RateID				VarChar(10),
	@RateLevel			VarChar(1),
	@LocationVehicleRateType	VarChar(20),
	@ValidFrom			VarChar(24),
	@ValidTo			VarChar(24),
	@RateSelectionType		VarChar(20),
	@OldRateID			VarChar(10),
	@OldRateLevel			VarChar(1),
	@OldRateSelectionType		VarChar(20),
	@OldValidFrom			VarChar(24)
AS
	Declare	@nLocationVehicleClassID SmallInt
	Declare	@nOldRateID Integer
	Declare	@dOldValidFrom DateTime

	Select		@nLocationVehicleClassID = CONVERT(SmallInt, NULLIF(@LocationVehicleClassID, ''))
	Select		@nOldRateID = CONVERT(Int, NULLIF(@OldRateID, ''))
	Select		@dOldValidFrom = CONVERT(DateTime, NULLIF(@OldValidFrom, ''))
	/*
	Set blank to Null for the values will be converted to numeric
	*/	
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	Else
		Select @ValidFrom = CONVERT(VarChar, CONVERT(DateTime, @ValidFrom), 111) + ' 00:00:00'
	If @ValidTo = ''
		Select @ValidTo = NULL
	Else
		Select @ValidTo = CONVERT(VarChar, CONVERT(DateTime, @ValidTo), 111) + ' 23:59:59'

	Select @RateLevel = Upper(@RateLevel)

	UPDATE 	Location_Vehicle_Rate_Level
	
	SET	Rate_Selection_Type		= @RateSelectionType,
		Rate_ID			= CONVERT(Int, @RateID),
		Rate_Level			= @RateLevel,
		Valid_From			= CONVERT(DateTime, @ValidFrom),
		Valid_To			= CONVERT(DateTime, @ValidTo)

	WHERE	Location_Vehicle_Class_ID		= @nLocationVehicleClassID
	AND		Rate_ID				= @nOldRateID
	AND		Rate_Level				= @OldRateLevel
	AND		Location_Vehicle_Rate_Type	= @LocationVehicleRateType
	AND		Valid_From				= @dOldValidFrom
	AND		Rate_Selection_Type			= @OldRateSelectionType
Return 1














GO
