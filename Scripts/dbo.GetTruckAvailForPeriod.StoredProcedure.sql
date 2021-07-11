USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTruckAvailForPeriod]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckAvailForPeriod    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetTruckAvailForPeriod]
	@LocId Varchar(5),
	@VehClassCode Varchar(1),
	@StartDate Varchar(24),
	@EndDate Varchar(24)
AS
	/* 10/5/99 - NP - @StartDate, @EndDate varchar(11) -> 24 */

DECLARE @iLocId SmallInt
DECLARE @dStartDate Datetime
DECLARE @dEndDate Datetime
	SELECT 	@iLocId = Convert(SmallInt, NULLIF(@LocId,'')),
		@VehClassCode = NULLIF(@VehClassCode,''),
		@dStartDate = Convert(Datetime, NULLIF(@StartDate,'')),
		@dEndDate = Convert(Datetime, NULLIF(@EndDate,''))
	SELECT 	convert(varchar,Calendar_Date, 106) Calendar_Date,
		AM_Availability, 
		PM_Availability, 
		OV_Availability
	FROM	Truck_Inventory
	WHERE	Location_ID = @iLocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate
	ORDER BY Calendar_Date
	RETURN @@ROWCOUNT
GO
