USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationID]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLocationID    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationID    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetLocationID]
	@Location VarChar(25)
AS
	
   	SELECT	Distinct Location_ID
   	FROM   	Location
	WHERE	Location.Location = @Location
	AND	Location.Delete_Flag = 0
   	ORDER BY 	
		Location_ID
   	RETURN 1












GO
