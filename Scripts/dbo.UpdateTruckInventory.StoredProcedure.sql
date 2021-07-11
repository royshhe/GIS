USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTruckInventory]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateTruckInventory    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckInventory    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckInventory    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckInventory    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Truck_Inventory table .
MOD HISTORY:
Name    Date        	Comments
NP	Jan/21/2000	If AM/PM/OV Inventory = '', set them to 0.
*/

CREATE PROCEDURE [dbo].[UpdateTruckInventory]
	@LocId 		Varchar(5),
	@VehClassCode 	Varchar(1),
	@CalendarDate	Varchar(11),
	@AMInv		Varchar(5),
	@PMInv		Varchar(5),
	@OVInv		Varchar(5)
AS
DECLARE @iLocId SmallInt,
	@dCalendarDate Datetime,
	@iAMInv SmallInt,
	@iPMInv SmallInt,
	@iOVInv SmallInt

	/* 981116 - Cindy Yee - update truck inventory
		for given loc, veh class, and date range */
	SELECT 	@iLocId = Convert(SmallInt, NULLIF(@LocId,"")),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@dCalendarDate = Convert(Datetime, NULLIF(@CalendarDate,""))

	IF @AMInv = ''
		SELECT @iAMInv = 0
	ELSE
		SELECT @iAMInv = Convert(SmallInt, @AMInv)

	IF @PMInv = ''
		SELECT @iPMInv = 0
	ELSE
		SELECT @iPMInv = Convert(SmallInt, @PMInv)

	IF @OVInv = ''
		SELECT @iOVInv = 0
	ELSE
		SELECT @iOVInv = Convert(SmallInt, @OVInv)

	/* if this record exists, update values */
	/* Jan 20 1999 - cpy - adjust availability according to difference
			between Old and New inventory */
	UPDATE	Truck_Inventory
	SET	AM_Availability = AM_Availability + (@iAMInv - AM_Inventory),
		PM_Availability = PM_Availability + (@iPMInv - PM_Inventory),
		OV_Availability = OV_Availability + (@iOVInv - OV_Inventory),
		AM_Inventory = @iAMInv,
		PM_Inventory = @iPMInv,
		OV_Inventory = @iOVInv
	WHERE	Location_Id = @iLocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Calendar_Date = @dCalendarDate

	IF @@ROWCOUNT = 0
		/* if no record exists, insert a record */
		
		/* Jan 20, 1999 - cpy - default availability to inventory amount */
		INSERT INTO Truck_Inventory
			(Location_ID,
			 Vehicle_Class_Code,
			 Calendar_Date,
			 AM_Inventory, PM_Inventory, OV_Inventory,
			 AM_Availability, PM_Availability, OV_Availability)
		VALUES 	(@iLocId,
			 @VehClassCode,
			 @dCalendarDate,
			 @iAMInv, @iPMInv, @iOVInv,
			 @iAMInv, @iPMInv, @iOVInv)
	RETURN @@ROWCOUNT
















GO
