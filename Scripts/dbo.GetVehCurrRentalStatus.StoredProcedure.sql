USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehCurrRentalStatus]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehCurrRentalStatus]
	@UnitNum Varchar(10)
AS
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum, ""))

	SET ROWCOUNT 1
	SELECT 	Current_Rental_Status

	FROM		Vehicle
	WHERE	Unit_Number = @nUnitNum

	RETURN @@ROWCOUNT










GO
