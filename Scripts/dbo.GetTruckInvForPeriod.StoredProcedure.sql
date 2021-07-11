USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTruckInvForPeriod]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetTruckInvForPeriod    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckInvForPeriod    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckInvForPeriod    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetTruckInvForPeriod    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetTruckInvForPeriod]
	@LocId 		Varchar(5),
	@VehClassCode 	Varchar(1),
	@StartDate	Varchar(11),
	@EndDate	Varchar(11)
AS
DECLARE @iLocId SmallInt,
	@dStartDate Datetime,
	@dEndDate Datetime
	SELECT 	@iLocId = Convert(SmallInt, NULLIF(@LocId,"")),
		@VehClassCode = NULLIF(@VehClassCode,""),
		@dStartDate = Convert(Datetime, NULLIF(@StartDate,"")),
		@dEndDate = Convert(Datetime, NULLIF(@EndDate,""))
	SELECT	Calendar_Date,
		AM_Inventory,
		PM_Inventory,
		OV_Inventory
	FROM	Truck_Inventory
	WHERE	Location_Id = @iLocId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Calendar_Date BETWEEN @dStartDate AND @dEndDate
	ORDER BY Calendar_Date
		
	RETURN @@ROWCOUNT












GO
