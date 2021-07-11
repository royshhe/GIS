USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllAvailableLocations]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllAvailableLocations    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAvailableLocations    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAvailableLocations    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllAvailableLocations    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of availale locations.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllAvailableLocations]
AS
   	Set Rowcount 2000
	
   	SELECT	Location,
		Location_ID
   	FROM   	Location
	WHERE	Delete_Flag = 0
   	ORDER BY 	
		Location
   	RETURN 1













GO
