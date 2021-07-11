USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehMovementExists]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehMovementExists    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehMovementExists    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehMovementExists    Script Date: 1/11/99 1:03:13 PM ******/
/*
PURPOSE: To retrieve vehicle movement rows that contain date overlaps for the given unit number and CO/CI datetime.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CheckVehMovementExists]
	@UnitNum Varchar(10),
	@CODatetime Varchar(24),
	@ActualCIDatetime Varchar(24)
AS
DECLARE @dCODatetime Datetime
DECLARE @dCIDatetime Datetime
DECLARE @iUnitNum Int

	-- return vehicle movement rows that contain date overlaps for the
	-- given unit number and CO/CI datetime

	/* 4/14/99 - cpy bug fix - if ActualCIDatetime is = Movement_Out, not considered overlap
				- handle NULL values in Movement_In */

	SELECT 	@dCODatetime = Convert(Datetime, NULLIF(@CODatetime,"")),
		@dCIDatetime = Convert(Datetime, NULLIF(@ActualCIDatetime,"")), 
		@iUnitNum = Convert(Int, NULLIF(@UnitNum,""))

	SET ROWCOUNT 1

	/* SELECT	Unit_Number, Movement_Type, Movement_Out, Movement_In
	FROM	Vehicle_Movement
	WHERE	Unit_Number = Convert(Int, NULLIF(@UnitNum,""))
	AND    (@dCODatetime BETWEEN Movement_Out AND Movement_In
	   OR	@dCIDatetime BETWEEN Movement_Out AND Movement_In
	   OR   Movement_Out BETWEEN @dCODatetime AND @dCIDatetime
	   OR	Movement_In  BETWEEN @dCODatetime AND @dCIDatetime) */

	SELECT	Unit_Number, Movement_Type, Movement_Out, Movement_In
	FROM	Vehicle_Movement
	WHERE	Unit_Number = @iUnitNum
	AND    ((@dCODatetime >= Movement_Out AND
			@dCODatetime < COALESCE(Movement_In,GetDate()))
	   OR	(@dCIDatetime > Movement_Out AND
			@dCIDatetime <= COALESCE(Movement_In,GetDate()))
	   OR   (Movement_Out >= @dCODatetime AND
			Movement_Out < @dCIDatetime)
	   OR	(COALESCE(Movement_In,GetDate())  > @dCODatetime AND
			COALESCE(Movement_In, GetDate()) <= @dCIDatetime))

	RETURN @@ROWCOUNT

















GO
