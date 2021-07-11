USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVehicleOnContract]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To lock the vehicles on a contract
AUTHOR: Don Kirkby
DATE CREATED: Oct 1 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVehicleOnContract]
	@CtrctNum varchar(11)
AS

	DECLARE @nCtrctNum integer
	SELECT @nCtrctNum = CAST(NULLIF(@CtrctNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	vehicle_on_contract AS voc WITH(UPDLOCK)
	  JOIN	vehicle AS veh WITH(UPDLOCK)
	    ON	veh.unit_number = voc.unit_number
	  JOIN	condition_history AS ch WITH(UPDLOCK)
	    ON	voc.unit_number = ch.unit_number 
	JOIN	override_Movement_Completion AS omc WITH(UPDLOCK)
	    ON	voc.unit_number = omc.unit_number
	
	 WHERE	contract_number = @nCtrctNum









GO
