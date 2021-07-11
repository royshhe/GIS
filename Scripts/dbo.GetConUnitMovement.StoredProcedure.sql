USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConUnitMovement]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve the latest movement record for the given unit
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 6 2000	Added Movement_Out to be returned
NP	May 01 2000	Return additional column, VEH.Foreign_Vehicle_Unit_Number
*/
CREATE PROCEDURE [dbo].[GetConUnitMovement]
	@UnitNum Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iUnitNum Int
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,''))

SET ROWCOUNT 1
	SELECT	M.Unit_Number, 
		M.Sending_Location_Id, 
		LS.Location,
		M.Receiving_Location_Id, 
		LR.Location,
		M.Movement_Out,
		VEH.Foreign_Vehicle_Unit_Number
	FROM	Vehicle_Movement M,
		Location LS,
		Location LR,
		Vehicle VEH
	WHERE	M.Receiving_Location_Id = LR.Location_Id
	AND	M.Sending_Location_Id = LS.Location_Id
	AND	M.Unit_Number = @iUnitNum
	AND	M.Unit_Number = VEH.Unit_Number
	ORDER BY M.Movement_Out DESC
	RETURN @@ROWCOUNT















GO
