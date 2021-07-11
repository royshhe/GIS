USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLocationVehicleRateLevel]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLocationVehicleRateLevel    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleRateLevel    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleRateLevel    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLocationVehicleRateLevel    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Location_Vehicle_Rate_Level table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLocationVehicleRateLevel]
	@LocationVehicleClassID		VarChar(10),
	@RateID				VarChar(10),
	@RateLevel			VarChar(1),
	@LocationVehicleRateType	VarChar(20),
	@ValidFrom			VarChar(24),
	@ValidTo			VarChar(24),
	@RateSelectionType		VarChar(20)
AS
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
	INSERT INTO Location_Vehicle_Rate_Level
	  (	Location_Vehicle_Class_ID ,
		Rate_ID,
		Rate_Level,
		Location_Vehicle_Rate_Type,
		Valid_From,
		Valid_To,
		Rate_Selection_Type
	  )
	VALUES
	  (	CONVERT(SmallInt, @LocationVehicleClassID),
		CONVERT(Int, @RateID),
		@RateLevel,
		@LocationVehicleRateType,
		CONVERT(DateTime, @ValidFrom),
		CONVERT(DateTime, @ValidTo),
		@RateSelectionType
	  )
Return 1













GO
