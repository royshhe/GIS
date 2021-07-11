USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateErrorLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateErrorLog    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CreateErrorLog    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateErrorLog    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateErrorLog    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Error_Log table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateErrorLog]
	@ScreenID	VarChar(20),
	@Location	VarChar(25),
	@UserID		VarChar(35),
	@Date		VarChar(24),
	@ErrorMessage	VarChar(255)
AS
	If @Date = ''
		Select @Date = NULL
	INSERT INTO Error_Log
		(
		Screen_ID,
		Location,
		User_ID,
		Date,
		Error_Message
		)
	VALUES	
		(
		@ScreenID,
		@Location,
		@UserID,
		CONVERT(DateTime, @Date),
		@ErrorMessage
		)
RETURN 1













GO
