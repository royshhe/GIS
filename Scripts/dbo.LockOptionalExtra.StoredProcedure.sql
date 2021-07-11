USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockOptionalExtra]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock a optional extra
AUTHOR: Niem Phan
DATE CREATED: Jan 12, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockOptionalExtra]
	@OptionalExtraId varchar(11)
AS

	DECLARE @iOptionalExtraId SmallInt
	SELECT @iOptionalExtraId = CAST(NULLIF(@OptionalExtraId, '') AS SmallInt)

	SELECT	COUNT(*)
	  FROM	Optional_Extra WITH(UPDLOCK)
	 WHERE	Optional_Extra_Id = @iOptionalExtraId





GO
