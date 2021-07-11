USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckConUnitRestrictLoc]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckConUnitRestrictLoc    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.CheckConUnitRestrictLoc    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckConUnitRestrictLoc    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckConUnitRestrictLoc    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check if the unit number is restricted at the given drop off location.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckConUnitRestrictLoc]

	@UnitNum Varchar(10),
	@DOLocId Varchar(5)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iUnitNum Int
DECLARE @Valid Bit
DECLARE @Count TinyInt
DECLARE @iDOLocId Int

	SELECT 	@iUnitNum = Convert(Int, NULLIF(@UnitNum,"")), 
		@iDOLocId = Convert(SmallInt, NULLIF(@DOLocId,""))
	-- set default
	SELECT @Valid = 1
	/* check if this unit contains any restricted locs */
	SELECT 	"1"
	FROM	Vehicle_Location_Restriction
	WHERE	Unit_Number = @iUnitNum
	IF @@ROWCOUNT > 0
	BEGIN
		/* if restricted locs exist, see whether or not
		   DOLocId is in restricted loc list;
		   if DOLocId is in list, then DOLocId is restricted
		   and not valid */
		SELECT 	"1"
		FROM	Vehicle_Location_Restriction
		WHERE	Unit_Number = @iUnitNum
		AND	Location_Id = @iDOLocId
		IF @@ROWCOUNT > 0
			SELECT @Valid = 0
	END
	RETURN @Valid














GO
