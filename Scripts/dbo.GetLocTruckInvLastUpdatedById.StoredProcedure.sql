USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocTruckInvLastUpdatedById]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetLocTruckInvLastUpdatedById]
	@LocId	varchar(10)

AS
/*  PURPOSE:		To retrieve thelocation's truck inventory last update date for the given location id.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/

	DECLARE 
		@iLocId		SmallInt

	SELECT 	
		@iLocId = CONVERT(SmallInt, NULLIF(@LocId, ''))

	SELECT 	
		loc.Location_Id,
				CONVERT(VarChar, loc.TruckInv_Last_Updated_On, 113) TruckInv_Last_Updated_On

	FROM 	Location loc

	WHERE	location_id = @iLocId



GO
