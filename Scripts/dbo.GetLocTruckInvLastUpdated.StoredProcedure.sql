USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocTruckInvLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetLocTruckInvLastUpdated]
	@VehClassCode	varchar(1),
	@ValidOn	varchar(24)
AS
/*  PURPOSE:		To retrieve thelocation's truck inventory last update date for the given parameters.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/

	DECLARE 
		@dValidOn		datetime

	SELECT 	
		@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))

	SELECT 	
		loc.Location_Id,
		CONVERT(VarChar, loc.TruckInv_Last_Updated_On, 113) TruckInv_Last_Updated_On
	FROM 	Location loc
	JOIN	location_vehicle_class lvc
	ON	loc.location_id = lvc.location_id

	WHERE	Delete_Flag = 0
	AND	Rental_Location = 1
	AND	lvc.vehicle_class_code = @VehClassCode
	AND	@dValidOn BETWEEN lvc.valid_from AND ISNULL(lvc.valid_to, @dValidOn)

	ORDER BY  loc.Location_Id






GO
