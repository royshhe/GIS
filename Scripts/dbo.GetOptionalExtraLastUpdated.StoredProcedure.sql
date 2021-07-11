USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptionalExtraLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetOptionalExtraLastUpdated]
	@OptionalExtraId VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given optional extra id
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iOptionalExtraId SmallInt
	SELECT @iOptionalExtraId = CONVERT(SmallInt, NULLIF(@OptionalExtraId, ''))

	SELECT	
			Optional_Extra_Id,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Optional_Extra

	WHERE	Optional_Extra_Id = @iOptionalExtraId
	
RETURN @@ROWCOUNT


GO
