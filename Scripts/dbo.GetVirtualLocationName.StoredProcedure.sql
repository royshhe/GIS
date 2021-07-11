USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVirtualLocationName]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE PROCEDURE [dbo].[GetVirtualLocationName]
	@Category VarChar(25)
AS
	
   	SELECT	LOC.Location

   	FROM   	Location LOC,
			Lookup_Table LT

	WHERE	LT.Category = @Category
	AND		LT.Code = LOC.Location_ID

   	RETURN 1







GO
