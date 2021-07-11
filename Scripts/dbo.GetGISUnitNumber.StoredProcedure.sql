USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGISUnitNumber]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
/*  PURPOSE:		To retrieve the GIS unit number for the given parameters.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetGISUnitNumber]
	@ForeignUnitNumber	Varchar(20),
	@OwningCompanyID	Varchar(11),
	@LicencePlate		VarChar(10)
AS
	DECLARE	@nOwningCompanyID SmallInt

	SELECT	@nOwningCompanyID = CONVERT(SmallInt, NULLIF(@OwningCompanyID, ''))
	SELECT	@ForeignUnitNumber = NULLIF(@ForeignUnitNumber, '')
	SELECT	@LicencePlate = NULLIF(@LicencePlate, '')

	SELECT	Unit_Number
	FROM		Vehicle
	WHERE	Foreign_Vehicle_Unit_Number = @ForeignUnitNumber
	AND		Owning_Company_ID = @nOwningCompanyID
	AND		Current_Licence_Plate = @LicencePlate
	RETURN @@ROWCOUNT


















GO
