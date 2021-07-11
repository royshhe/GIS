USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResStdComments]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResStdComments    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetResStdComments    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResStdComments    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetResStdComments    Script Date: 11/23/98 3:55:34 PM ******/

CREATE PROCEDURE [dbo].[GetResStdComments]
	@ConfirmNum Varchar(20)
AS
	IF @ConfirmNum = ""	SELECT @ConfirmNum = NULL

	SELECT 	RC.Reservation_Comment_ID,
			RC.Reservation_Comment_ID

	FROM		Reservation_Comment RC,
			Reservation_Standard_Comment RSC

	WHERE	RC.Confirmation_Number = Convert(Int, @ConfirmNum)
	AND		RC.Reservation_Comment_ID = RSC.Reservation_Comment_ID

	ORDER BY	RSC.Reservation_Comment
	
RETURN @@ROWCOUNT







GO
