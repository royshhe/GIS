USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckCoverageIsAvailable]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PURPOSE:	- Return 0 if @CoverageType was not available to be added
	       	for the Vcls type of this UnitNumber; otherwise, return 1
		- situations when CoverageType is not available for a Vcls type
		include: optional extra exists in optional_extra_restriction
		for the given Vcls
		- @CoverageType can be: LDW, PAI, PEC, Cargo, Buydown
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckCoverageIsAvailable]
	@UnitNumber	VarChar(10),
	@CoverageType	Varchar(20)
AS
	/* 4/26/99 - cpy created  */
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @sVehClassCode Char(1)
DECLARE @iUnitNum Int

	SELECT	@iUnitNum = Convert(Int, NULLIF(@UnitNumber,'')),
		@CoverageType = NULLIF(@CoverageType,'')

	-- get veh class code for this Unit
	SELECT	@sVehClassCode = Vehicle_Class_Code
	FROM	Vehicle
	WHERE	Unit_Number = @iUnitNum

	-- see if there are any coverages of type @CoverageType available for this @sVehClassCode
	SELECT	'1'
	FROM	Optional_Extra OE
	WHERE	OE.Type = @CoverageType
	AND 	OE.Delete_Flag = 0
	AND	OE.Optional_Extra_ID NOT IN
				(SELECT	Optional_Extra_ID
				 FROM	Optional_Extra_Restriction
				 WHERE	Vehicle_Class_Code = @sVehClassCode)

	IF @@ROWCOUNT > 0
		RETURN 1
	ELSE
		RETURN 0

	














GO
