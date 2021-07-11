USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVehicleModelYear]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the vehicle model year record for the given vehicle model id
AUTHOR: Niem Phan
DATE CREATED: Jan 14, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVehicleModelYear]
	@VehicleModelId varchar(11)
AS

	DECLARE	@iVehicleModelId SmallInt
	SELECT 	@iVehicleModelId = CAST(NULLIF(@VehicleModelId, '') AS SmallInt)

	SELECT	COUNT(*)
	  FROM	Vehicle_Model_Year WITH(UPDLOCK)
	 WHERE	Vehicle_Model_Id = @iVehicleModelId





GO
