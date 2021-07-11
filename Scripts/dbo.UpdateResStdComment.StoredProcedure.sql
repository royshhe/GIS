USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResStdComment]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateResStdComment    Script Date: 2/18/99 12:11:49 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStdComment    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStdComment    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStdComment    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Reservation_Comment table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateResStdComment]
@ConfirmNum varchar(10), @OldResCommentId varchar(5),
@NewResCommentId varchar(5)
AS
	Declare	@nConfirmNum Integer
	Declare	@nOldResCommentId SmallInt

	Select		@nConfirmNum = Convert(Int, NULLIF(@ConfirmNum, ''))
	Select		@nOldResCommentId = Convert(SmallInt, NULLIF(@OldResCommentId, ''))

	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @OldResCommentId = ""

		SELECT @OldResCommentId = NULL
	IF @NewResCommentId = ""
		SELECT @NewResCommentId = NULL

	UPDATE	Reservation_Comment
	SET	Reservation_Comment_ID = Convert(SmallInt, @NewResCommentId)

	WHERE	Confirmation_Number = @nConfirmNum
	AND	Reservation_Comment_ID = @nOldResCommentId

	RETURN @@ROWCOUNT














GO
