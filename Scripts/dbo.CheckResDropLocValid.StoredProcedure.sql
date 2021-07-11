USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResDropLocValid]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To check whether or not a given location is valid as a drop off location
	 for a given pick up location
MOD HISTORY:
Name	Date        	Comments
Don K	27 Mar 2000	Only check drop off to the nearest day.
*/
CREATE PROCEDURE [dbo].[CheckResDropLocValid]
	@DOLocId Varchar(5),
	@PULocId Varchar(5),
	@DODatetime Varchar(24)
AS
	-- Remove time part of @DODatetime
	DECLARE @dDropOff datetime
	SELECT	@dDropOff = CAST(FLOOR(CAST(CAST(@DODatetime AS datetime) AS float)) AS datetime)

	/* if DOLocId is a valid drop off location for PULocId during
	   DODatetime, then return "1" for each row found */
	SELECT 	"1"
	FROM	Pick_Up_Drop_Off_Location
	WHERE	Pick_Up_Location_ID = Convert(SmallInt, @PULocId)
	AND	Drop_Off_Location_ID = Convert(SmallInt, @DOLocId)
	AND	@dDropOff BETWEEN Valid_From AND ISNULL(Valid_To, @dDropOff)
	RETURN @@ROWCOUNT














GO
