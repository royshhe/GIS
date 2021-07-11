USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetVehicleLastUpdated]
	@UnitNumber VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given Unit Number
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iUnitNumber Integer
	SELECT	@iUnitNumber = CONVERT(Integer, NULLIF(@UnitNumber, ''))

	SELECT	
			Unit_Number,
			CONVERT(VarChar, Last_Update_On, 113) Last_Update_On
	
	FROM		Vehicle

	WHERE	Unit_Number = @iUnitNumber
	
RETURN @@ROWCOUNT



GO
