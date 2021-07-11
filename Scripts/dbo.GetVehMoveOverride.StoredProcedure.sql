USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehMoveOverride]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehMoveOverride]
	@UnitNumber Varchar(10)
AS

	/* 6/14/99 - return override info for any outstanding (not completed)
			movements for a unit */

	Declare	@nUnitNumber Integer
	Select		@nUnitNumber = Convert(Int, NULLIF(@UnitNumber,''))

	SELECT	OMC.Unit_Number,
		OMC.Movement_Out,
		OMC.Override_Contract_Number,
		OMC.Receiving_Location_ID,
		OMC.Movement_In,
		OMC.Km_In,
		OMC.Fuel_Level,
		OMC.Litres_of_Fuel_Remaining
	FROM	Override_Movement_Completion OMC,
		Vehicle_Movement VM
	WHERE	OMC.Unit_Number = @nUnitNumber
	AND	OMC.Unit_NUmber = VM.Unit_Number
	AND	OMC.Movement_Out = VM.Movement_Out
	AND 	NULLIF(VM.Movement_In,'') IS NULL
	ORDER BY OMC.Movement_Out DESC

RETURN @@ROWCOUNT



GO
