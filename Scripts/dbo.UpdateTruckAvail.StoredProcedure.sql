USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTruckAvail]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateTruckAvail    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Truck_Inventory table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateTruckAvail]
	@PULocId Varchar(5),
	@VehClassCode Varchar(1),
	@CalendarDate Varchar(24),
	@AMAvail Varchar(5),
	@PMAvail Varchar(5),
	@OVAvail Varchar(5)
AS
	Declare	@nPULocId SmallInt
	Declare	@dCalendarDate DateTime

	Select		@nPULocId = Convert(SmallInt, NULLIF(@PULocId,""))
	Select		@dCalendarDate = Convert(Datetime, NULLIF(@CalendarDate,""))
	Select		@VehClassCode = NULLIF(@VehClassCode,"")

	UPDATE	Truck_Inventory

	SET	AM_Availability = Convert(SmallInt, NULLIF(@AMAvail,"")),
		PM_Availability = Convert(SmallInt, NULLIF(@PMAvail,"")),
		OV_Availability = Convert(SmallInt, NULLIF(@OVAvail,""))

	WHERE	Location_ID = @nPULocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Calendar_Date = @dCalendarDate

	RETURN @@ROWCOUNT














GO
