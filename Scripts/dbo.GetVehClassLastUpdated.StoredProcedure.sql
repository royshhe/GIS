USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassLastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetVehClassLastUpdated]
	@VehClassCode VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update date for the given vehicle class code
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	SELECT	
			Vehicle_Class_Code,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Vehicle_Class

	WHERE	Vehicle_Class_Code = @VehClassCode
	
RETURN @@ROWCOUNT


GO
