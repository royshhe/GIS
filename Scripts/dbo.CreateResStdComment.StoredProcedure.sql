USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResStdComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateResStdComment    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreateResStdComment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResStdComment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResStdComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Reservation_Comment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateResStdComment]
	@ConfirmNum 	Varchar(10),
	@NewResCommentId	Varchar(5)
AS
	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @NewResCommentId = ""
		SELECT @NewResCommentId = NULL
	INSERT INTO Reservation_Comment
		(Confirmation_Number, Reservation_Comment_ID)
	VALUES	(Convert(Int, @ConfirmNum),
		 Convert(SmallInt, @NewResCommentId))
	RETURN @@ROWCOUNT













GO
