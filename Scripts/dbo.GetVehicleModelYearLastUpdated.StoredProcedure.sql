USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelYearLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetVehicleModelYearLastUpdated]
	@VehicleModelId VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given vehicle model id
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iVehicleModelId SmallInt
	SELECT	@iVehicleModelId = CONVERT(SmallInt, NULLIF(@VehicleModelId, ''))

	SELECT	
			Vehicle_Model_ID,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Vehicle_Model_Year

	WHERE	Vehicle_Model_Id = @iVehicleModelId
	
RETURN @@ROWCOUNT


GO
