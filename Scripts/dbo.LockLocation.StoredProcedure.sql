USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockLocation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the location record for the given location id
AUTHOR: Niem Phan
DATE CREATED: Jan 12, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockLocation]
	@LocId varchar(11)
AS

	DECLARE @iLocId SmallInt
	SELECT @iLocId = CAST(NULLIF(@LocId, '') AS SmallInt)

	SELECT	COUNT(*)
	  FROM	Location WITH(UPDLOCK)
	 WHERE	Location_Id = @iLocId





GO
