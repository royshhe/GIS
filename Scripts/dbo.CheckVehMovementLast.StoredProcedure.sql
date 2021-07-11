USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehMovementLast]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehMovementLast    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehMovementLast    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehMovementLast    Script Date: 1/11/99 1:03:13 PM ******/
/*
PURPOSE: To return 0 if there are no other movement records for this UnitNum that have movement out time > check in time; else return rowcount.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CheckVehMovementLast]
	@UnitNum Varchar(10),
	@OrgCODatetime Varchar(24),
	@ActualCIDatetime Varchar(24)
AS
	/* 4/15/99 - cpy bug fix - changed comparison to check if Movement_Out >= CIDatetime */

DECLARE @dOrgCODatetime Datetime
DECLARE @dCIDatetime Datetime
DECLARE @iUnitNum Int

	SELECT 	@dOrgCODatetime = Convert(Datetime, NULLIF(@OrgCODatetime,"")),
		@dCIDatetime = Convert(Datetime, NULLIF(@ActualCIDatetime,"")),
		@iUnitNum = Convert(Int, NULLIF(@UnitNum,""))

	SET ROWCOUNT 1

	SELECT	Unit_Number, Movement_Type, Movement_Out, Movement_In
	FROM	Vehicle_Movement
	WHERE	Unit_Number = @iUnitNum
	AND	Movement_Out >= @dCIDatetime
	AND	Movement_Out <> @dOrgCODatetime

	RETURN @@ROWCOUNT
















GO
