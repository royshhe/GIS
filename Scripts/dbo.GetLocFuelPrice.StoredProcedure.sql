USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocFuelPrice]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetLocFuelPrice]
	@LocID	Varchar(10),
	@Diesel	VarChar(1)
AS
	DECLARE	@nLocID SmallInt
	SELECT	@nLocID = CONVERT(SmallInt, NULLIF(@LocID, ''))

	If @Diesel = 1

		SELECT 	Fuel_Price_Per_Liter_Diesel
		FROM		Location
		WHERE	Location_ID = @nLocID
	Else
		SELECT 	Fuel_Price_Per_Liter
		FROM		Location
		WHERE	Location_ID = @nLocID
	
	
	RETURN @@ROWCOUNT














GO
