USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOwningCompanyLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetOwningCompanyLastUpdated]
	@OwningCompanyId VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given Owning Company Id.
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iOwningCompanyId SmallInt
	SELECT 	@iOwningCompanyId = CONVERT(SmallInt, NULLIF(@OwningCompanyId, ''))

	SELECT	
			Owning_Company_Id,
			CONVERT(VarChar, Last_Update_On, 113) Last_Update_On
	
	FROM		Owning_Company

	WHERE	Owning_Company_Id = @iOwningCompanyId
	
RETURN @@ROWCOUNT


GO
