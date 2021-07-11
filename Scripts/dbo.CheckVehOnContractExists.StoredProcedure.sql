USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehOnContractExists]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehOnContractExists    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehOnContractExists    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehOnContractExists    Script Date: 1/11/99 1:03:13 PM ******/
/*
PURPOSE: To vehicle on contract rows that contain date overlaps for the given unit number and CO/CI datetime.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckVehOnContractExists]
	@ContractNum Varchar(10),
	@UnitNum Varchar(10),
	@OrgCODatetime Varchar(24),
	@CODatetime Varchar(24),
	@ActualCIDatetime Varchar(24)
AS
DECLARE @dCODatetime Datetime
DECLARE @dCIDatetime Datetime
DECLARE @iCount Integer
DECLARE @iUnitNum Int
DECLARE @dOrgCODatetime Datetime

	/* 4/13/99 - cpy bug fix - return expected_check_in */
	/* 4/14/99 - cpy bug fix - if CIDatetime is = Checked_Out, not considered overlap
				- handle NULL Actual_Check_In */
	/* 10/08/99 - do type conversion and nullif outside of select */
	
	SELECT 	@dCODatetime = Convert(Datetime, NULLIF(@CODatetime,"")),
		@dCIDatetime = Convert(Datetime, NULLIF(@ActualCIDatetime,"")),
		@iUnitNum = Convert(Int, NULLIF(@UnitNum,"")),
		@dOrgCODatetime = Convert(Datetime, NULLIF(@OrgCODatetime,""))

	SET ROWCOUNT 1

	SELECT	Contract_Number, Unit_Number, Checked_Out, Actual_Check_In, Expected_Check_In
	FROM	Vehicle_On_Contract
	WHERE	Unit_Number = @iUnitNum
	AND    ((@dCODatetime >= Checked_Out AND
			@dCODatetime < COALESCE(Actual_Check_In, Expected_Check_In))
	   OR	(@dCIDatetime > Checked_Out AND
			@dCIDatetime <= COALESCE(Actual_Check_In, Expected_Check_In))
	   OR   (Checked_Out >= @dCODatetime
			AND Checked_Out < @dCIDatetime)
	   OR	(COALESCE(Actual_Check_In, Expected_Check_In) > @dCODatetime
			AND COALESCE(Actual_Check_In, Expected_Check_In) <= @dCIDatetime))
	AND	Checked_Out <> @dOrgCODatetime

	RETURN @@ROWCOUNT

























GO
