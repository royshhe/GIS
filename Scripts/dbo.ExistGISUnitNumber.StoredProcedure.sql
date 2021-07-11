USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistGISUnitNumber]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: To retrieve the count for number of vehicles that meet the given parameters.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[ExistGISUnitNumber]
	@UnitNumber 		Varchar(20),
	@OwningCompanyID	VarChar(10),
	@LicencePlate		VarChar(10)
AS
	/* 10/10/99 - do type conversion and nullif outside of sql statement */
DECLARE	@iUnitNum Int,
	@iOwningCompanyId Int

	SELECT	@iUnitNum = CONVERT(Int, NULLIF(@UnitNumber, '')),
		@iOwningCompanyId = CONVERT(SmallInt, NULLIF(@OwningCompanyID, '')),
		@LicencePlate = NULLIF(@LicencePlate, '')

	SELECT	Count(*)
	FROM	Vehicle
	WHERE	Unit_Number = @iUnitNum
	AND	Owning_Company_ID = @iOwningCompanyId
	AND	Current_Licence_Plate = @LicencePlate

	RETURN @@ROWCOUNT













GO
