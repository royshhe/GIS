USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockOrganization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the organization record for the given organization id
AUTHOR: Niem Phan
DATE CREATED: Jan 17, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockOrganization]
	@OrgId varchar(11)
AS

	DECLARE @iOrgId Integer
	SELECT @iOrgId = CAST(NULLIF(@OrgId, '') AS Integer)

	SELECT	COUNT(*)
	  FROM	Organization WITH(UPDLOCK)
	 WHERE	Organization_Id = @iOrgId




GO
