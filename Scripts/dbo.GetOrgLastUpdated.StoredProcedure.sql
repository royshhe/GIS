USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetOrgLastUpdated]
	@OrgId VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given Organization Id.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iOrgId Integer
	SELECT @iOrgId = CONVERT(Integer, NULLIF(@OrgId, ''))

	SELECT	
			Organization_ID,
			CONVERT(VarChar, Last_Changed_On, 113) Last_Changed_On
	
	FROM		Organization

	WHERE	Organization_Id = @iOrgId
	
RETURN @@ROWCOUNT


GO
