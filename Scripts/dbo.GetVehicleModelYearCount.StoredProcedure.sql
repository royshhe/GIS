USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelYearCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehicleModelYearCount]
	@VehicleModelID Varchar(11)
AS
	Declare	@nVehicleModelID SmallInt
	Select		@nVehicleModelID  = CONVERT(SmallInt, NULLIF(@VehicleModelID, ''))

	SELECT	Count(*)
	FROM		Vehicle
	WHERE	Vehicle_Model_ID = @nVehicleModelID
	RETURN 1











GO
