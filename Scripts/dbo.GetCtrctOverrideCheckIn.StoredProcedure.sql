USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctOverrideCheckIn]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctOverrideCheckIn    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctOverrideCheckIn    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the override check in information for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctOverrideCheckIn]
	@CtrctNum		VarChar(10),
	@UnitNum		VarChar(10),
	@CheckedOutDateTime	VarChar(24)
AS
	/* 3/30/99 - cpy modified - cleanup unused params; previously 5 params, now 3 */

	/* Modified to return 'Movement' if Override_Contract_Number = Overridden_Contract_Number; otherwise return Override_Contract_Number*/
	/* 10/19/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iOverriddenCtrctNum Int, 
	@iUnitNum Int,
	@dCheckOutDatetime Datetime

	SELECT 	@iOverriddenCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,'')), 
		@iUnitNum = CONVERT(Int, NULLIF(@Unitnum, '')),
		@dCheckOutDatetime = CONVERT(DateTime, NULLIF(@CheckedOutDateTime, ''))

	Set RowCount 1

	SELECT
		Case	
			When Override_Contract_Number = Overridden_Contract_Number Then
				'Movement'
			Else
				Convert(VarChar, Override_Contract_Number)
		End,
		Drop_Off_Location_ID,
		Convert(varchar,Check_In,111),
		Convert(varchar,Check_In,108),
		Km_In,
		Fuel_Level,
		Fuel_Remaining
	FROM	Override_Check_In
	WHERE	Overridden_Contract_Number = @iOverriddenCtrctNum
	AND	Unit_Number = @iUnitNum
	AND	Checked_Out = @dCheckOutDatetime

	RETURN @@ROWCOUNT


















GO
