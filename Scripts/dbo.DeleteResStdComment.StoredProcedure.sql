USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteResStdComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteResStdComment    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResStdComment    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResStdComment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResStdComment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Reservation_Comment table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteResStdComment]
	@ConfirmNum 	Varchar(10),
	@OldResCommentId	Varchar(5)
AS
	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @OldResCommentId = ""
		SELECT @OldResCommentId = NULL
	DELETE	Reservation_Comment
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	AND	Reservation_Comment_ID = Convert(SmallInt, @OldResCommentId)
	RETURN @@ROWCOUNT













GO
