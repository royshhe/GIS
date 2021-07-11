USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ResetTruckAvail]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

create PROCEDURE [dbo].[ResetTruckAvail] --'8','j','2010-06-10','2010-08-27',3,3,3
	@PULocId Varchar(5),
	@VehClassCode Varchar(1),
	@StartDate Varchar(24),
	@EndDate Varchar(24),
	@AMAvail Varchar(5),
	@PMAvail Varchar(5),
	@OVAvail Varchar(5)
AS
	Declare	@nPULocId SmallInt
	Declare	@dStartDate DateTime
	Declare	@dEndDate DateTime

	Select		@nPULocId = Convert(SmallInt, NULLIF(@PULocId,''))
	Select		@dStartDate = Convert(Datetime, NULLIF(@StartDate,''))
	Select		@dEndDate = Convert(Datetime, NULLIF(@EndDate,''))
	Select		@VehClassCode = NULLIF(@VehClassCode,'')

	UPDATE	Truck_Inventory

	SET	AM_Availability = case when AM_Availability+Convert(SmallInt, NULLIF(@AMAvail,''))>AM_Inventory
								then AM_Inventory
								else AM_Availability+Convert(SmallInt, NULLIF(@AMAvail,''))
							end ,
		PM_Availability = case when PM_Availability+Convert(SmallInt, NULLIF(@PMAvail,''))>PM_Inventory
								then PM_Inventory
								else PM_Availability+Convert(SmallInt, NULLIF(@PMAvail,''))
							end ,
		OV_Availability = case when OV_Availability+Convert(SmallInt, NULLIF(@OVAvail,''))>OV_Inventory
								then OV_Inventory
								else OV_Availability+Convert(SmallInt, NULLIF(@OVAvail,''))
							end 

	WHERE	Location_ID = @nPULocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	(Calendar_Date  between  @dStartDate and @dEndDate)

	RETURN @@ROWCOUNT
















GO
