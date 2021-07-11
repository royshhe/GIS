USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetLocLastUpdated]
	@LocId VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given Location Id.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iLocId SmallInt
	SELECT @iLocId = CONVERT(SmallInt, NULLIF(@LocId, ''))

	SELECT	
			Location_ID,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Location

	WHERE	Location_Id = @iLocId
	
RETURN @@ROWCOUNT


GO
