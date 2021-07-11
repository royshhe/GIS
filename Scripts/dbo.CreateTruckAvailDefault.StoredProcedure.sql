USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTruckAvailDefault]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PURPOSE: To insert a list of records into Truck_Inventory table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateTruckAvailDefault] 
	@LocId Varchar(5),
	@VehClassCode Varchar(1),
	@ValidFrom Varchar(24),
	@ValidTo Varchar(24),
	@AMAvail Varchar(5),
	@PMAvail Varchar(5),
	@OVAvail Varchar(5)
AS
DECLARE @iLocId 	SmallInt,
	@dCurrDate 	Datetime,
	@dStartDate 	Datetime,
	@dEndDate 	Datetime,
	@iAMAvail SmallInt,
	@iPMAvail SmallInt,
	@iOVAvail SmallInt

DECLARE @iRowCount Int
	/* 2/23/99 - cpy created - copied from CreateTruckInvDefault 
			- if a record does not exist for each day 
			between ValidFrom and ValidTo, create a default record
			with inventory = 0 and availability = A/P/O Avail */
	/* 10/5/99 - NP - @ValidFrom, @ValidTo varchar(11) -> varchar(24) */

	SELECT	@iLocId = Convert(SmallInt, NULLIF(@LocId,'')),
		@VehClassCode = NULLIF(@VehClassCode,''),
		@dStartDate = Convert(Datetime, NULLIF(@ValidFrom,'')),
		@dEndDate = Convert(Datetime, NULLIF(@ValidTo,'')),
		@iAMAvail = Convert(SmallInt, NULLIF(@AMAvail,'')),
		@iPMAvail = Convert(SmallInt, NULLIF(@PMAvail,'')),
		@iOVAvail = Convert(SmallInt, NULLIF(@OVAvail,''))

	IF @dStartDate <= @dEndDate
	BEGIN
		SELECT @dCurrDate = @dStartDate

		WHILE DATEDIFF(day, @dCurrDate, @dEndDate) >= 0
		BEGIN
			SELECT	@iRowCount = Count(*)
			FROM	Truck_Inventory
			WHERE	Location_ID = @iLocid
			AND	Vehicle_Class_Code = @VehClassCode
			AND	Calendar_Date = @dCurrdate

			IF @iRowCount = 0
			BEGIN
				INSERT INTO Truck_Inventory
					(Location_ID, 
					 Vehicle_Class_Code, 
					 Calendar_Date, 
					 AM_Inventory, PM_Inventory, OV_Inventory, 
					 AM_Availability, PM_Availability, OV_Availability)
				VALUES	(@iLocId, 
					 @VehClassCode, 
					 @dCurrDate,
					 0, 0, 0,
					 @iAMAvail, @iPMAvail, @iOVAvail)
			END

			SELECT @dCurrDate = DATEADD(day, 1, @dCurrDate)
		END
	END
	RETURN 1



















GO
