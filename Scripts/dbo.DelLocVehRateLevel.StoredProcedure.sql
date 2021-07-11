USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelLocVehRateLevel]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelLocVehRateLevel    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehRateLevel    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehRateLevel    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelLocVehRateLevel    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Location_Vehicle_Rate_Level table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DelLocVehRateLevel]
	@LocationVehicleClassID	VarChar(10),
	@RateID			VarChar(10),
	@RateLevel		VarChar(1),
	@RateType		VarChar(20),
	@SelectionType		VarChar(20),
	@ValidFrom		VarChar(24)
	
AS
	
   	Delete	Location_Vehicle_Rate_Level
	WHERE	Location_Vehicle_Class_ID 	= CONVERT(SmallInt, @LocationVehicleClassID)
	AND	Rate_ID				= CONVERT(Int, @RateID)
	AND	Rate_Level			= @RateLevel
	AND	Location_Vehicle_Rate_Type	= @RateType
	AND	Rate_Selection_Type 		= @SelectionType
	AND	Valid_From			= CONVERT(DateTime, @ValidFrom)
   	RETURN 1













GO
