USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResPickUpLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResPickUpLoc    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResPickUpLoc    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResPickUpLoc    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResPickUpLoc    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResPickUpLoc]
	@LocName Varchar(25)
AS
DECLARE @ResNetFlag Int
DECLARE @LocId SmallInt
DECLARE @Location Varchar(25)
	-- set default resnet flag
	SELECT	@ResNetFlag = 0, 
		@LocName = NULLIF(@LocName,'')
	-- Get ResNetFlag

	SELECT 	@ResNetFlag = 1
	FROM 	Location
	WHERE 	Location = @LocName
	AND	Delete_Flag = 0
	AND	ResNet = 1
	AND	Rental_Location = 0
	-- if loc is a ResNet centre, get all the rental locs
	-- else return only the loc id and loc name of the loc param

Exec GetRentalLocation @ResNetFlag
	/*ELSE
	BEGIN
		SELECT 	@Location = Location, @LocId = Location_ID
		FROM	Location
		WHERE	Location = NULLIF(@LocName,"")
		AND	Delete_Flag = 0
		-- return (null, null) if location does not exist or is deleted
		SELECT @Location, @LocId
	END
*/
		
	RETURN @@ROWCOUNT














GO
