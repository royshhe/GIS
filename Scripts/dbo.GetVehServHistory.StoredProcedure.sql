USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehServHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
NP Sep 10 1999 : Added an optional parameter to limit the number of rows returned. The default is 4 rows.
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */

CREATE PROCEDURE [dbo].[GetVehServHistory]
	@UnitNumber 	Varchar(10),
	@Limit		VarChar(10) = Null
AS

	Declare  @I Int
	If @Limit IS NULL OR @Limit = ''
	  Begin
		Set RowCount 4
	  End
	Else
	  Begin
		Select @I = CONVERT(Int, @Limit)
		Set RowCount @I
	  End
	/* 6/07/99 created - return all vehicle service history records for a unit */

	Declare	@nUnitNumber Integer
	Select		@nUnitNumber = Convert(Int, NULLIF(@UnitNumber,''))

	SELECT	Convert(Char(11), Service_Performed_On, 13),
		Convert(Char(8), Service_Performed_On, 108),
		Km_Reading,
		LT.Value AS Condition_Status,
		Fuel_Added_Dollars,
		Fuel_Added_Litres,
		Fuel_Tank_Level,
		Litres_Remaining,
		Case Smoking
			WHEN 1 THEN 'Smoking'
			ELSE 'Non-Smoking'
		END
	FROM	Vehicle_Service VS,
		Lookup_Table LT
	WHERE	VS.Condition_Status = LT.Code
	AND	LT.Category = 'Vehicle Condition Status'
	AND	VS.Unit_Number = @nUnitNumber
	ORDER BY Service_Performed_On DESC

	RETURN @@ROWCOUNT

















GO
