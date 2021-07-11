USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckTruckInvExists]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckTruckInvExists    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CheckTruckInvExists    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckTruckInvExists    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckTruckInvExists    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To - check if a truck inventory record exists for a given location,  veh class code, and date.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckTruckInvExists]
	@LocId 		Varchar(5),
	@VehClassCode 	Varchar(1),
	@StartDate	Varchar(11),
	@EndDate	Varchar(11)
AS
DECLARE @iLocId SmallInt,
	@dStartDate Datetime,
	@dEndDate   Datetime,
	@iAMInv SmallInt,
	@iPMInv SmallInt,
	@iOVInv SmallInt,
	@iExist SmallInt

	SELECT 	@iLocId = Convert(SmallInt, NULLIF(@LocId,"")),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@dStartDate = Convert(Datetime, NULLIF(@StartDate,"")),
		@dEndDate = Convert(Datetime, NULLIF(@EndDate,""))
	SELECT	@iExist = Count(*)
	FROM	Truck_Inventory
	WHERE	Location_Id = @iLocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate
	AND	COALESCE(AM_Inventory, PM_Inventory, OV_Inventory) IS NOT NULL
/*	AND	AM_Inventory IS NOT NULL
	AND	PM_Inventory IS NOT NULL
	AND	OV_Inventory IS NOT NULL */
		
	RETURN @iExist













GO
