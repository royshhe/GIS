USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassByUnitNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehClassByUnitNum]
	@UnitNum Varchar(10)
AS
	/* 3/27/99 - cpy created - return vehicle class code for given unit num
			- currently called from TruckInventory (maintain truck availability) */
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum,''))

	SELECT	Vehicle_Class_Code
	FROM	Vehicle WITH( UPDLOCK )
	WHERE	Unit_Number = @nUnitNum

	RETURN @@ROWCOUNT



















GO
