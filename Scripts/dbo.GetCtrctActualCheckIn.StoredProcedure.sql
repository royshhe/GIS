USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctActualCheckIn]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: retrieve the date that the contract was actually checked in.
REQUIRES: the contract must be checked in. (Duh!)
MOD HISTORY:
Name	Date	    Comment
Don K	Sep 7 1999  Created
CPY     Sep 30 1999 do type conversion and nullif outside of select 
*/
CREATE PROCEDURE [dbo].[GetCtrctActualCheckIn]
	@CtrctNum Varchar(11)
AS
DECLARE @iCtrctNum Int

	SELECT  @iCtrctNum = CAST(NULLIF(@CtrctNum, '') AS int)

	SELECT	CONVERT(varchar, MAX(actual_check_in), 120)
	  FROM	vehicle_on_contract
	 WHERE	contract_number = @iCtrctNum








GO
