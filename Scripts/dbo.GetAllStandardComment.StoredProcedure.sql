USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllStandardComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllStandardComment    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAllStandardComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllStandardComment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllStandardComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of reservation standard comments.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllStandardComment]
AS
	SELECT	Reservation_Comment,
		Reservation_Comment_ID
	FROM	Reservation_Standard_Comment
	ORDER BY
		Reservation_Comment
	RETURN 1













GO
