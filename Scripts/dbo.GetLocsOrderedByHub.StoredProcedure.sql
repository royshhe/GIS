USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocsOrderedByHub]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO














CREATE PROCEDURE [dbo].[GetLocsOrderedByHub]
	@StartLocId Varchar(5),
	@VehClassCode	varchar(1),
	@ValidOn	varchar(24),
	@HubCode 	varchar(25)
AS
	-- 990115 - Niem Phan - Changed iHubId SmallInt to HubId VarChar(25)
	-- 990223 - Don K - Filter out locations that don't carry the vehicle class.
DECLARE @iStartLocId	SmallInt,
	@HubId 		VarChar(25),
	@iOwningCoId	SmallInt,
	@dValidOn	datetime
	SELECT 	@iStartLocId = Convert(SmallInt, NULLIF(@StartLocId,"")),
		@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT @HubCode = NULLIF(@HubCode, '')
	SELECT @HubCode = NULLIF(@HubCode, 'ALL')
		--SELECT @HubId = @HubCode
	--else
		SELECT	@HubId = Hub_Id,
			@iOwningCoId = Owning_Company_Id
		FROM	Location
		WHERE	Location_Id = @iStartLocId

	/* 981106 - Cindy Yee - return list of locations ordered by:
	 *	1. current location
	 *	2. locations in same hub as current location
	 *	3. other locations not in the same hub but
	 *	   with the same owning company
	 *	4. foreign locations
	 */
	SELECT 	loc.Location_Id, Location,
		tmporder = CASE
		WHEN loc.Location_Id = @iStartLocId THEN 1
		WHEN loc.Location_Id IN (
			SELECT 	b.Location_Id
			FROM 	Location b
			WHERE	b.Hub_Id = @HubId) THEN 2
		WHEN loc.Location_Id IN (
			SELECT 	c.Location_Id
			FROM 	Location c
			WHERE	c.Owning_Company_Id = @iOwningCoId) THEN 3
		ELSE 4
		END
		, Hub_Id, Owning_Company_Id
	FROM 	Location loc
	JOIN	location_vehicle_class lvc
	ON	loc.location_id = lvc.location_id
	WHERE	Delete_Flag = 0
	AND	Rental_Location = 1
	AND	lvc.vehicle_class_code = @VehClassCode
	AND	@dValidOn BETWEEN lvc.valid_from AND ISNULL(lvc.valid_to, @dValidOn)
	AND 	Hub_id = ISNULL(@HubCode, loc.Hub_id)
	ORDER BY tmporder, Hub_Id, Location


GO
