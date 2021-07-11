USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTruckInvDefault]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateTruckInvDefault    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateTruckInvDefault    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateTruckInvDefault    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateTruckInvDefault    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a list of records into Truck_Inventory table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateTruckInvDefault]
	@LocId Varchar(5),
	@VehClassCode Varchar(1),
	@ValidFrom Varchar(11),
	@ValidTo Varchar(11),
	@AMInv Varchar(5),
	@PMInv Varchar(5),
	@OVInv Varchar(5)
AS
DECLARE @iLocId 	SmallInt,
	@dCurrDate 	Datetime,
	@dStartDate 	Datetime,
	@dEndDate 	Datetime,
	@iAMInv SmallInt,
	@iPMInv SmallInt,
	@iOVInv SmallInt
	/* 981116 - Cindy Yee - create truck inventory defaults
			for given loc, veh class, and date range */
	SELECT	@iLocId = Convert(SmallInt, NULLIF(@LocId,"")),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@dStartDate = Convert(Datetime, NULLIF(@ValidFrom,"")),
		@dEndDate = Convert(Datetime, NULLIF(@ValidTo,"")),
		@iAMInv = Convert(SmallInt, NULLIF(@AMInv,"")),
		@iPMInv = Convert(SmallInt, NULLIF(@PMInv,"")),
		@iOVInv = Convert(SmallInt, NULLIF(@OVInv,""))
	IF @dStartDate <= @dEndDate
	BEGIN
		SELECT @dCurrDate = @dStartDate
		WHILE DATEDIFF(day, @dCurrDate, @dEndDate) >= 0
		BEGIN
			/* Jan 20 1999 - cpy - adjust availability according to difference
					between Old and New inventory */
			UPDATE	Truck_Inventory
			SET	AM_Availability = AM_Availability + (@iAMInv - AM_Inventory),
				PM_Availability = PM_Availability + (@iPMInv - PM_Inventory),
				OV_Availability = OV_Availability + (@iOVInv - OV_Inventory),
				AM_Inventory = @iAMInv,
				PM_Inventory = @iPMInv,
				OV_Inventory = @iOVInv
			WHERE	Location_ID = @iLocid
			AND	Vehicle_Class_Code = @VehClassCode
			AND	Calendar_Date = @dCurrdate
			IF @@ROWCOUNT = 0
			BEGIN
				/* Jan 7 99, cpy - default availability values to
				   inventory amount */
				INSERT INTO Truck_Inventory
					(Location_ID,
					 Vehicle_Class_Code,
					 Calendar_Date,
					 AM_Inventory, PM_Inventory, OV_Inventory,
					 AM_Availability, PM_Availability, OV_Availability)
				VALUES	(@iLocId,
					 @VehClassCode,
					 @dCurrDate,
					 @iAMInv, @iPMInv, @iOVInv,
					 @iAMInv, @iPMInv, @iOVInv)
			END

			SELECT @dCurrDate = DATEADD(day, 1, @dCurrDate)
		END
	END
	RETURN 1













GO
