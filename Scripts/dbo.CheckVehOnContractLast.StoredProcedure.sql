USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckVehOnContractLast]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckVehOnContractLast    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehOnContractLast    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckVehOnContractLast    Script Date: 1/11/99 1:03:13 PM ******/
/*
PURPOSE: To return 0 if there are no records for the same unit that have a check out time > check in time; else return rowcount.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckVehOnContractLast]
	@ContractNum Varchar(10),
	@UnitNum Varchar(10),
	@OrgCODatetime Varchar(24),
	@ActualCIDatetime Varchar(24)
AS
	/* 4/15/99 - cpy bug fix - changed comparison to check if Checked_Out >= CIDatetime */
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @dOrgCODatetime Datetime
DECLARE @dCIDatetime Datetime
DECLARE @iCtrctNum Int
DECLARE @iUnitNum Int

	SELECT 	@dOrgCODatetime = Convert(Datetime, NULLIF(@OrgCODatetime,"")),
		@dCIDatetime = Convert(Datetime, NULLIF(@ActualCIDatetime,"")),
		@iCtrctNum = Convert(Int, NULLIF(@ContractNum,"")),
		@iUnitNum = Convert(Int, NULLIF(@UnitNum,""))

	SET ROWCOUNT 1

	SELECT	Contract_Number, Unit_Number, Checked_Out, Actual_Check_In
	FROM	Vehicle_On_Contract
	WHERE	Unit_Number = @iUnitNum
	AND	Checked_Out >= @dCIDatetime
	AND	Contract_Number <> @iCtrctNum
	AND	Checked_Out <> @dOrgCODatetime

	RETURN @@ROWCOUNT
















GO
